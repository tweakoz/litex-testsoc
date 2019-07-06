from migen import *

from litex.build.generic_platform import *

from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *

from litex.soc.interconnect.stream import *
from litex.soc.interconnect.csr import *
from litex.soc.interconnect import wishbone
from litex.soc.interconnect.csr_eventmanager import *

from litex.soc.cores import gpio, uart

from squaregen import SQUGEN
import pwm
import os

from migen.genlib.fifo import SyncFIFO as SynchronousFifo

######################################################

class RGBLed(Module, AutoCSR):
  def __init__(self, soc, ioname, ioindex):
    super(RGBLed, self).__init__()
    io = soc.platform.request(ioname, ioindex)
    self.submodules.r = pwm.PWM(io.r, invert=False)
    self.submodules.g = pwm.PWM(io.g, invert=False)
    self.submodules.b = pwm.PWM(io.b, invert=False)


class PMODGPOUT(Module, AutoCSR):
  def __init__(self, soc, ioname):
    super(PMODGPOUT, self).__init__()
    ios = soc.platform.request(ioname, 0)
    self.submodules.io1 = gpio.GPIOOut(ios.io1)
    self.submodules.io2 = gpio.GPIOOut(ios.io2)
    self.submodules.io3 = gpio.GPIOOut(ios.io3)
    self.submodules.io4 = gpio.GPIOOut(ios.io4)
    self.submodules.io5 = gpio.GPIOOut(ios.io5)
    self.submodules.io6 = gpio.GPIOOut(ios.io6)
    self.submodules.io7 = gpio.GPIOOut(ios.io7)
    self.submodules.io8 = gpio.GPIOOut(ios.io8)

class PMODGPINP(Module, AutoCSR):
  def __init__(self, soc, ioname):
    super(PMODGPINP, self).__init__()
    ios = soc.platform.request(ioname, 0)
    self.submodules.io1 = gpio.GPIOIn(ios.io1)
    self.submodules.io2 = gpio.GPIOIn(ios.io2)
    self.submodules.io3 = gpio.GPIOIn(ios.io3)
    self.submodules.io4 = gpio.GPIOIn(ios.io4)
    self.submodules.io5 = gpio.GPIOIn(ios.io5)
    self.submodules.io6 = gpio.GPIOIn(ios.io6)
    self.submodules.io7 = gpio.GPIOIn(ios.io7)
    self.submodules.io8 = gpio.GPIOIn(ios.io8)

################################################
# generate a 1 clock pulse on a recurring period
################################################

class Pulsor(Module):
    def __init__(self):
        self.output = output  = Signal()
        self.counter = counter = Signal(24)
        self.prevcounter = prvcnt = Signal(24)

        self.sync += [
            prvcnt.eq(counter),
            counter.eq(counter + 1),
        ]
        self.comb += [
            # should trigger when:
            # counter=0x800000, prvcnt==0x7fffff
            # and
            # counter=0x000000, prvcnt==0xffffff
            # @ 100mhz - should fire about 12 times a second..
            output.eq(counter[23]!=prvcnt[23])
        ]

###################################
# Simple IRQ generator test
#  should fire an IRQ 12 times a second
#   (when pulsor fires)
###################################

class IRQTest(Module, AutoCSR):
  def __init__(self, soc):

    self.submodules.pulsor = pulsor = Pulsor()

    ####################
    # create IRQ event(s)
    ####################

    self.submodules.ev = EventManager()
    self.ev.pulsor = EventSourcePulse() # one shot

    ####################

    soc.comb += [
        self.ev.pulsor.trigger.eq(pulsor.output),
    ]

#######################################################
# Simple CPU->HW and HW->CPU FIFO test
#######################################################

class FIFOTest(Module, AutoCSR):

  def __init__(self, soc):

    fifo_width = 32 # 32 bits wide
    fifo_depth = 16 # 16 items in fifo

    #####################################################
    # out fifo (CPU->FIFO)
    #####################################################

    out_fifo_raw = SynchronousFifo(fifo_width, fifo_depth)
    out_fifo = ResetInserter()(out_fifo_raw)

    self.submodules += out_fifo

    self.out_datareg = CSRStorage(fifo_width, reset=0)
    self.out_ready = CSRStatus()
    self.out_level = CSRStatus(log2_int(fifo_depth)+1)
    self.out_reset = CSRStorage(reset=0)
    self.out_writeoccured = Signal()
    self.out_writecounter = CSRStatus(32,reset=0)

    self.sync += [

        ####################
        # CPU->OUTFIFO
        ####################

        out_fifo.din[0:fifo_width].eq(self.out_datareg.storage[0:fifo_width]),
        out_fifo.we.eq(self.out_datareg.re),
        out_fifo.reset.eq(self.out_reset.re),
        out_fifo.replace.eq(0),
        self.out_writeoccured.eq(out_fifo.we),

        If( self.out_reset.re,
            out_fifo.level,eq(0),
            self.out_datareg.storage.eq(0) ),

        If( self.out_reset.re,
            self.out_writecounter.status.eq(0) ).
        Elif( self.out_datareg.re,
            self.out_writecounter.status.eq(self.out_writecounter.status+1)),

        ####################
        # control / status
        ####################

        self.out_ready.status.eq(out_fifo.writable),
        self.out_level.status.eq(out_fifo.level),
    ]

    #####################################################
    # useless machinery
    # inp fifo (FIFO->CPU) just mirrors what went into out_fifo
    #####################################################

    # cant use a CSR for inp_datareg, CSRs dont work correctly with 32 bit words
    #  mainly because bus widths
    # so use a CSRStatus which can break up fifo_width(32) into bus_width(8) chunks

    self.inp_datareg = CSRStatus(fifo_width)
    self.inp_dataavail = CSRStatus()
    self.inp_level = CSRStatus(8)
    self.inp_ack = CSR()
    self.inp_reset = CSRStorage(reset=0)
    self.inp_writable = CSRStatus()
    self.inp_writeoccured = Signal()
    self.inp_readcounter = CSRStatus(32,reset=0)

    inp_fifo_raw = SynchronousFifo(fifo_width, fifo_depth)
    inp_fifo = ResetInserter()(inp_fifo_raw)

    self.submodules += inp_fifo

    ################################################
    # readstate fsm
    ################################################

    out2inpfsm = genlib.fsm.FSM(reset_state="IDLE")
    self.submodules += out2inpfsm
    out2inpfsm.act("IDLE",
        NextState("WAIT")
    )
    out2inpfsm.act("WAIT",
        If(out_fifo.readable & inp_fifo.writable,
            NextState("READ1")
        )
    )
    out2inpfsm.act("READ1",
        NextState("READ2")
    )
    out2inpfsm.act("READ2",
        NextState("READ3")
    )
    out2inpfsm.act("READ3",
        NextState("READ4")
    )
    out2inpfsm.act("READ4",
        NextState("WAIT")
    )

    ################################################

    self.sync += [

        ####################
        # OUTFIFO->INPFIFO
        ####################


        inp_fifo.we.eq(out2inpfsm.ongoing("READ1")), # inp_fifo read transaction
        self.inp_writeoccured.eq(inp_fifo.we),
        out_fifo.re.eq(self.inp_writeoccured), # out_fifo read ack (above delayed by one cycle)

        inp_fifo.din[0:fifo_width].eq(out_fifo.dout[0:fifo_width]), # outfifo feeds inpfifo
        inp_fifo.replace.eq(0),

        ####################
        # INPFIFO->CPU
        ####################

        inp_fifo.re.eq( self.inp_ack.re ), # read ack from CPU

        If( self.inp_reset.re,
            inp_fifo.level,eq(0),
            self.inp_datareg.storage.eq(0) ),

        If( self.inp_reset.re,
            self.inp_readcounter.status.eq(0) ).
        Elif( self.inp_ack.re,
            self.inp_readcounter.status.eq(self.inp_readcounter.status+1)),

        self.inp_datareg.status[0:fifo_width].eq(inp_fifo.dout[0:fifo_width]),
        self.inp_dataavail.status.eq(inp_fifo.readable),
        self.inp_level.status.eq(inp_fifo.level),
        self.inp_writable.status.eq(inp_fifo.writable),
        inp_fifo_raw.reset.eq(self.inp_reset.re),
    ]

    self.comb += [
    ]

#######################################################

def configureEthernet(soc, local_ip, remote_ip):
    local_ip = local_ip.split(".")
    remote_ip = remote_ip.split(".")

    soc.add_constant("LOCALIP1", int(local_ip[0]))
    soc.add_constant("LOCALIP2", int(local_ip[1]))
    soc.add_constant("LOCALIP3", int(local_ip[2]))
    soc.add_constant("LOCALIP4", int(local_ip[3]))

    soc.add_constant("REMOTEIP1", int(remote_ip[0]))
    soc.add_constant("REMOTEIP2", int(remote_ip[1]))
    soc.add_constant("REMOTEIP3", int(remote_ip[2]))
    soc.add_constant("REMOTEIP4", int(remote_ip[3]))

#######################################################

def configureBoot(soc):
    soc.add_constant("NETBOOT_LINUX_VEXRISCV", None)

#######################################################
board_name="testsoc"
#######################################################

def SocBase(BaseClass,addargs=None):
    class _impl(BaseClass):
        BaseClass.mem_map["rom"] = 0x00000000
        BaseClass.mem_map["sram"] = 0x10000000
        BaseClass.mem_map["emulator_ram"] = 0x20000000
        BaseClass.mem_map["ethmac"] = 0x30000000
        BaseClass.mem_map["main_ram"] = 0xc0000000
        # BaseClass.mem_map["vexriscv_debug"] = 0xe0000000
        BaseClass.mem_map["csr"] = 0xf0000000
        #######################################################
        BaseClass.interrupt_map["pulsor"] = 4 # dynamically assign?

        def __init__(self,**kwargs):
            super(_impl,self).__init__( **kwargs )

    return _impl

#######################################################

def GenSoc( BaseClass,
            PlatformExtender):

    soc_base = SocBase(BaseClass)
    #######################################################
    soc = soc_base(
        cpu_type="vexriscv",
        cpu_variant="linux+debug",
        ident="TestSoc",
        ident_version="0.1",
        csr_address_width=16,
        uart_baudrate=115200,
    )
    ######################################################
    PlatformExtender(soc)
    ######################################################
    # UART/Wishbone debug bridge (for VexRiscV debug port)
    ######################################################

    print(soc.clk_freq)

    soc.submodules.bridge  = uart.UARTWishboneBridge( soc.platform.request("dbgserial"),
                                                      soc.clk_freq,
                                                      baudrate=3000000)

    soc.add_wb_master(soc.bridge.wishbone)

    #################################################
    # disabled - because SOC is DOA when enabled
    #################################################
    #soc.register_mem( "vexriscv_debug",
    #                  soc.mem_map["vexriscv_debug"],
    #                  soc.cpu.debug_bus,
    #                  0x10)
    #################################################


    ###################################
    # VexRiscV Machine Mode Emulator SRAM
    ###################################

    soc.submodules.emulator_ram = wishbone.SRAM(0x4000)
    soc.register_mem( "emulator_ram",
                      soc.mem_map["emulator_ram"],
                      soc.emulator_ram.bus, 0x4000)

    ###################################
    # RGB Leds
    ###################################

    soc.submodules.rgbledA = RGBLed(soc,"rgb_led",0)
    soc.submodules.rgbledB = RGBLed(soc,"rgb_led",1)
    soc.submodules.rgbledC = RGBLed(soc,"rgb_led",2)
    soc.submodules.rgbledD = RGBLed(soc,"rgb_led",3)

    soc.add_csr("rgbledA")
    soc.add_csr("rgbledB")
    soc.add_csr("rgbledC")
    soc.add_csr("rgbledD")

    ###################################
    # GPIO's
    ###################################

    soc.submodules.pmodA = PMODGPOUT(soc,"pmodA")
    soc.submodules.pmodC = PMODGPINP(soc,"pmodC")
    soc.add_csr("pmodA")
    soc.add_csr("pmodC")

    ###################################
    # IRQ test
    ###################################

    soc.submodules.irqtest = IRQTest(soc)
    soc.add_csr("irqtest")

    ###################################
    # FIFO test
    ###################################

    soc.submodules.fifotest = FIFOTest(soc)
    soc.add_csr("fifotest")

    ###################################

    soc_ip = os.environ["SOCIPADDR"]
    tftp_ip = os.environ["DEVHOSTIP"]

    configureEthernet( soc,
                       local_ip=soc_ip,
                       remote_ip=tftp_ip )
    configureBoot(soc)

    return soc
