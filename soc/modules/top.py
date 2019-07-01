from migen import *

import litex.boards.targets.arty
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

from migen.genlib.fifo import SyncFIFOBuffered as SynchronousFifo

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

    soc.submodules += out_fifo

    self.out_datareg = CSRStorage(fifo_width, reset=0)
    self.out_ready = CSRStatus()
    self.out_level = CSRStatus(log2_int(fifo_depth)+1)

    soc.comb += [

        ####################
        # (CPU->OUTFIFO)
        ####################

        out_fifo.din[0:fifo_width].eq(self.out_datareg.storage[0:fifo_width]),
        out_fifo.we.eq(self.out_datareg.re),

        ####################
        # control / status
        ####################

        self.out_ready.status.eq(out_fifo.writable),
        self.out_level.status.eq(out_fifo.level),
    ]

    #####################################################
    # inp fifo (FIFO->CPU) just mirrors what went into out_fifo
    #####################################################

    self.inp_datareg = CSRStatus(fifo_width)
    self.inp_dataavail = CSRStatus()
    self.inp_level = CSRStatus(log2_int(fifo_depth)+1)
    self.inp_ack = CSR()

    inp_fifo_raw = SynchronousFifo(fifo_width, fifo_depth)
    inp_fifo = ResetInserter()(inp_fifo_raw)

    soc.submodules += inp_fifo

    soc.sync += [

        # (OUTFIFO->INPFIFO)

        inp_fifo.we.eq(out_fifo.readable & inp_fifo.writable), # inp_fifo read transaction
        out_fifo.re.eq(inp_fifo.we), # out_fifo read ack (above delayed by one cycle)

    ]
    soc.comb += [

        # (OUTFIFO->INPFIFO)


        inp_fifo.din[0:fifo_width].eq(out_fifo.dout[0:fifo_width]), # outfifo feeds inpfifo

        # (INPFIFO->CPU)

        self.inp_datareg.status[0:fifo_width].eq(inp_fifo.dout[0:fifo_width]),

        inp_fifo.re.eq( self.inp_ack.re ), # ??? how do I ack a read from the CPU ???
                                #   uart uses self.ev.rx.clear
                                #   I don't think Linux Supervisor mode has interrupts yet...
                                # And even then it useful to know how to do it with programmed IO
                                # Is it possible to do a CPU->WBBUS->CSR read transaction ack here?

        # control / status

        self.inp_dataavail.status.eq(inp_fifo.readable),
        self.inp_level.status.eq(inp_fifo.level),

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
EtherSoc = litex.boards.targets.arty.EthernetSoC
EtherSoc.mem_map["rom"] = 0x00000000
EtherSoc.mem_map["sram"] = 0x10000000
EtherSoc.mem_map["emulator_ram"] = 0x20000000
EtherSoc.mem_map["ethmac"] = 0x30000000
EtherSoc.mem_map["main_ram"] = 0xc0000000
# EtherSoc.mem_map["vexriscv_debug"] = 0xe0000000
EtherSoc.mem_map["csr"] = 0xf0000000
#######################################################
EtherSoc.interrupt_map["pulsor"] = 4 # dynamically assign?
#######################################################
soc = EtherSoc(
    cpu_type="vexriscv",
    cpu_variant="linux+debug",
    ident="TestSoc",
    ident_version="0.1",
    csr_address_width=16,
    uart_baudrate=115200
)
#######################################################
soc.platform.add_extension([
    ("dbgserial", 0,
       Subsignal("tx", Pins("J18")), # pmodB pin8 ft232r-rxd dbg-tx
       Subsignal("rx", Pins("K15")), # pmodB pin9 ft232r-txd dbg-rx
       IOStandard("LVCMOS33"),
    ),
    ("outer_digital_header", 0,
       Subsignal("io1",  Pins("V15")),
       Subsignal("io2",  Pins("U16")),
       Subsignal("io3",  Pins("P14")),
       Subsignal("io4",  Pins("T11")),
       Subsignal("io5",  Pins("R12")),
       Subsignal("io6",  Pins("T14")),
       Subsignal("io7",  Pins("T15")),
       Subsignal("io8",  Pins("T16")),
       IOStandard("LVTTL")
    ),
    ("inner_digital_header", 0,
       Subsignal("io1",  Pins("U11")), # io26
       Subsignal("io2",  Pins("V16")), # io27
       Subsignal("io3",  Pins("M13")), # io28
       Subsignal("io4",  Pins("R10")), # io29
       Subsignal("io5",  Pins("R11")), # io30
       Subsignal("io6",  Pins("R13")), # io31
       Subsignal("io7",  Pins("R15")), # io32
       Subsignal("io8",  Pins("P15")), # io33
       IOStandard("LVTTL")
    ),
    ("pmodA", 0,
       Subsignal("io1",  Pins("G13")), # p1
       Subsignal("io2",  Pins("B11")), # p2
       Subsignal("io3",  Pins("A11")), # p3
       Subsignal("io4",  Pins("D12")), # p4
       Subsignal("io5",  Pins("D13")), # p7
       Subsignal("io6",  Pins("B18")), # p8
       Subsignal("io7",  Pins("A18")), # p9
       Subsignal("io8",  Pins("K16")),  # p10
       IOStandard("LVCMOS33")
    ),
    ("pmodC", 0,
       Subsignal("io1",  Pins("U12")), # p1
       Subsignal("io2",  Pins("V12")), # p2
       Subsignal("io3",  Pins("V10")), # p3
       Subsignal("io4",  Pins("V11")), # p4
       Subsignal("io5",  Pins("U14")), # p7
       Subsignal("io6",  Pins("V14")), # p8
       Subsignal("io7",  Pins("T13")), # p9
       Subsignal("io8",  Pins("U13")), # p10
       IOStandard("LVCMOS33")
    )
])

######################################################
# UART/Wishbone debug bridge (for VexRiscV debug port)
######################################################

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

###################################
# return SOC to caller
###################################

def get():
    return soc
