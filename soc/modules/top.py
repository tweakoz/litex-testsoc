from migen import *

from litex.build.generic_platform import *

from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *

from litex.soc.interconnect.stream import *
from litex.soc.interconnect.csr import *
from litex.soc.interconnect import wishbone

from litex.soc.cores import gpio, uart

######################################################

from squaregen import SQUGEN
import pwm
import os
from irqtest import IRQTest
from fifotest import FIFOTest

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
