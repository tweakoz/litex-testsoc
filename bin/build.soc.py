#!/usr/bin/env python3

import argparse, os, sys
from pathlib import Path

from migen import *
from litex.soc.interconnect.csr import *
from litex.soc.integration.builder import *
from litex.soc.integration.soc_core import *
from litex.build.generic_platform import *
import litex.boards.targets.arty

###################################

this_dir = Path(os.path.dirname(os.path.abspath(__file__)))
prjroot = Path(os.environ["PROJECT_ROOT"])
output_dir = Path(os.environ["SOC_BUILD_DIR"])
sys.path.append(str(prjroot/"soc"/"modules"))
import top

###################################

def extensions(soc):
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
    #######################################################


###################################

the_top = top.GenSoc( litex.boards.targets.arty.EthernetSoC,
                      extensions )

builder = Builder( the_top,
                   output_dir=output_dir,
                   csr_csv=str(output_dir/"mysoc_csr.csv"))

builder.build() # finalize here
