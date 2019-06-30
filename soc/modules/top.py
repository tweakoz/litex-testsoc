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

######################################################

class RGBLed(Module, AutoCSR):
  def __init__(self, soc, ioname, ioindex):
    super(RGBLed, self).__init__()
    io = soc.platform.request(ioname, ioindex)
    self.submodules.r = pwm.PWM(io.r, invert=False)
    self.submodules.g = pwm.PWM(io.g, invert=False)
    self.submodules.b = pwm.PWM(io.b, invert=False)


class PMOD(Module, AutoCSR):
  def __init__(self, soc, ioname):
    super(PMOD, self).__init__()
    ios = soc.platform.request(ioname, 0)
    self.submodules.io1 = SQUGEN(soc, ios.io1)
    self.submodules.io2 = gpio.GPIOOut(ios.io2)
    self.submodules.io3 = SQUGEN(soc, ios.io3)
    self.submodules.io4 = SQUGEN(soc, ios.io4)
    self.submodules.io5 = SQUGEN(soc, ios.io5)
    self.submodules.io6 = SQUGEN(soc, ios.io6)
    self.submodules.io7 = SQUGEN(soc, ios.io7)
    self.submodules.io8 = SQUGEN(soc, ios.io8)

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
soc = EtherSoc(
    cpu_type="vexriscv",
    cpu_variant="linux+debug",
    ident="TestSoc",
    ident_version="0.1",
    csr_address_width=16,
    uart_baudrate=115200
)
#soc.register_mem( "vexriscv_debug",
#                  soc.mem_map["vexriscv_debug"],
#                  soc.cpu.debug_bus,
#                  0x10)

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
       Subsignal("io8", Pins("K16")),  # p10
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
       Subsignal("io8", Pins("U13")), # p10
       IOStandard("LVCMOS33")
    )
])

######################################################
# add uart/wishbone debug bridge
######################################################

soc.submodules.bridge  = uart.UARTWishboneBridge( soc.platform.request("dbgserial"),
                                                  soc.clk_freq,
                                                  baudrate=3000000)

soc.add_wb_master(soc.bridge.wishbone)

###################################
# machine mode emulator ram
###################################

soc.submodules.emulator_ram = wishbone.SRAM(0x4000)
soc.register_mem( "emulator_ram",
                  soc.mem_map["emulator_ram"],
                  soc.emulator_ram.bus, 0x4000)

###################################
# RGB Led
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
# pmods
###################################

#soc.submodules.pmodC = PMOD(soc,"inner_digital_header")
#soc.add_csr("pmodC")

###################################

soc_ip = os.environ["SOCIPADDR"]
tftp_ip = os.environ["DEVHOSTIP"]

configureEthernet( soc,
                   local_ip=soc_ip,
                   remote_ip=tftp_ip )
configureBoot(soc)

def get():
    return soc
