#!/usr/bin/env python3

import argparse, os, sys
from pathlib import Path
from migen import *
from litex.soc.interconnect.csr import *
from litex.soc.integration.builder import *
from litex.soc.integration.soc_core import *
from litex.build.generic_platform import *

from litex.build.sim import SimPlatform
from litex.build.sim.config import SimConfig

from migen.genlib.io import CRG
from migen.genlib.misc import timeline
from litex.soc.interconnect import stream
from litex.soc.interconnect import wishbone
from litex.soc.cores import uart

from liteeth.common import convert_ip
from liteeth.phy.model import LiteEthPHYModel
from liteeth.core.mac import LiteEthMAC
import struct

###################################

this_dir = Path(os.path.dirname(os.path.abspath(__file__)))
prjroot = Path(os.environ["PROJECT_ROOT"])
output_dir = Path(os.environ["SOC_BUILD_DIR"])/"simulation"
sys.path.append(str(prjroot/"soc"/"modules"))
import top

###################################

def extensions(soc):
    pass

class SimPins(Pins):
    def __init__(self, n=1):
        Pins.__init__(self, "s "*n)


_io = [
    ("sys_clk", 0, SimPins(1)),
    ("sys_rst", 0, SimPins(1)),
    ("rgb_led", 0,
        Subsignal("r", SimPins(1)),
        Subsignal("g", SimPins(1)),
        Subsignal("b", SimPins(1)),
    ),
    ("rgb_led", 1,
        Subsignal("r", SimPins(1)),
        Subsignal("g", SimPins(1)),
        Subsignal("b", SimPins(1)),
    ),
    ("rgb_led", 2,
        Subsignal("r", SimPins(1)),
        Subsignal("g", SimPins(1)),
        Subsignal("b", SimPins(1)),
    ),
    ("rgb_led", 3,
        Subsignal("r", SimPins(1)),
        Subsignal("g", SimPins(1)),
        Subsignal("b", SimPins(1)),
    ),
    ("serial", 0,
        Subsignal("source_valid", SimPins()),
        Subsignal("source_ready", SimPins()),
        Subsignal("source_data", SimPins(8)),

        Subsignal("sink_valid", SimPins()),
        Subsignal("sink_ready", SimPins()),
        Subsignal("sink_data", SimPins(8)),
    ),
    ("dbgserial", 0,
        Subsignal("tx", SimPins(1)),
        Subsignal("rx", SimPins(1)),
    ),
    ("pmodA", 0,
       Subsignal("io1",  SimPins(1)), # p1
       Subsignal("io2",  SimPins(1)), # p2
       Subsignal("io3",  SimPins(1)), # p3
       Subsignal("io4",  SimPins(1)), # p4
       Subsignal("io5",  SimPins(1)), # p7
       Subsignal("io6",  SimPins(1)), # p8
       Subsignal("io7",  SimPins(1)), # p9
       Subsignal("io8",  SimPins(1)),  # p10
    ),
    ("pmodC", 0,
       Subsignal("io1",  SimPins(1)), # p1
       Subsignal("io2",  SimPins(1)), # p2
       Subsignal("io3",  SimPins(1)), # p3
       Subsignal("io4",  SimPins(1)), # p4
       Subsignal("io5",  SimPins(1)), # p7
       Subsignal("io6",  SimPins(1)), # p8
       Subsignal("io7",  SimPins(1)), # p9
       Subsignal("io8",  SimPins(1)), # p10
    )
]

###################################

class Platform(SimPlatform):
    default_clk_name = "sys_clk"
    default_clk_period = 10 # ~ 100MHz

    def __init__(self):
        SimPlatform.__init__(self, "SIM", _io)

    def do_finalize(self, fragment):
        pass

###################################

class Supervisor(Module, AutoCSR):
    def __init__(self):
        self._finish  = CSR()  # controlled from CPU
        self.finish = Signal() # controlled from logic
        self.sync += If(self._finish.re | self.finish, Finish())
        # supervisor
        self.submodules.supervisor = Supervisor()
        self.add_csr("supervisor")

###################################

class SimCore(SoCCore):
    def __init__(self,**kwargs):
      FIRMWARE = []
      print("##################################")
      print("# Embedding Firmware")
      print("##################################")
      with open(str(prjroot/"testapp-standalone"/".build"/"main-sim.bin"), "rb") as boot_file:
        while True:
            w = boot_file.read(4)
            if not w:
                break
            FIRMWARE.append(struct.unpack("<I", w)[0]) # Little Endian
            #FIRMWARE.append(struct.unpack(">I", w)[0]) # Big Endian

        print(FIRMWARE)
        _platform = Platform()
        super(SimCore,self).__init__( platform=_platform,
                                      with_uart=False,
                                      clk_freq=int(100e6),
                                      integrated_rom_size=0x8000,
                                      integrated_sram_size=0x8000,
                                      integrated_main_ram_size=0x10000000, # 256MB
                                      integrated_rom_init=FIRMWARE,
                                      **kwargs )
        self.submodules.crg = CRG(_platform.request("sys_clk"))
        # serial
        self.submodules.uart_phy = uart.RS232PHYModel(_platform.request("serial"))
        self.submodules.uart = uart.UART(self.uart_phy)
        self.add_csr("uart", allow_user_defined=True)
        self.add_interrupt("uart", allow_user_defined=True)


###################################

plat = Platform()
the_top = top.GenSoc(SimCore,extensions)

###################################

sim_config = SimConfig(default_clk="sys_clk")
sim_config.add_module("serial2console", "serial")

builder = Builder( the_top,
                   output_dir=output_dir,
                   csr_csv=str(output_dir/"mysoc_csr.csv"))

builder.build( sim_config=sim_config,
               opt_level="O0",
               trace=True,
               trace_start=0,
               trace_end=-1)

#builder.build() # finalize here
