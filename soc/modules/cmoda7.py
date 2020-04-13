import top
import argparse, os, sys
from pathlib import Path

from migen import *
from litex.soc.interconnect.csr import *
from litex.soc.integration.builder import *
from litex.soc.integration.soc_core import *
from litex.build.generic_platform import *
import litex.boards.targets.nexys_video

def extensions(soc):
    #######################################################
    soc.platform.add_extension([
        ("dbgserial", 0,
           Subsignal("tx", Pins("Y9")), # pmodB pin8 ft232r-rxd dbg-tx
           Subsignal("rx", Pins("Y8")), # pmodB pin9 ft232r-txd dbg-rx
           IOStandard("LVCMOS33"),
        ),
        ("outer_digital_header", 0, # FMC
           Subsignal("io1",  Pins("M18")), # FMC LA02p
           Subsignal("io2",  Pins("L18")), # FMC LA02n
           Subsignal("io3",  Pins("N18")),
           Subsignal("io4",  Pins("N19")),
           Subsignal("io5",  Pins("N20")),
           Subsignal("io6",  Pins("M20")),
           Subsignal("io7",  Pins("L21")),
           Subsignal("io8",  Pins("M21")),
           IOStandard("LVCMOS33")
        ),
        ("inner_digital_header", 0, # FMC
           Subsignal("io1",  Pins("M13")), # FMC LA07p
           Subsignal("io2",  Pins("L13")), # FMC LA07n
           Subsignal("io3",  Pins("K17")),
           Subsignal("io4",  Pins("J17")),
           Subsignal("io5",  Pins("L14")),
           Subsignal("io6",  Pins("L15")),
           Subsignal("io7",  Pins("L16")),
           Subsignal("io8",  Pins("K16")),
           IOStandard("LVCMOS33")
        ),
        ("pmodA", 0,
           Subsignal("io1",  Pins("AB22")), # p1
           Subsignal("io2",  Pins("AB21")), # p2
           Subsignal("io3",  Pins("AB20")), # p3
           Subsignal("io4",  Pins("AB18")), # p4
           Subsignal("io5",  Pins("Y21")), # p7
           Subsignal("io6",  Pins("AA21")), # p8
           Subsignal("io7",  Pins("AA20")), # p9
           Subsignal("io8",  Pins("AA18")),  # p10
           IOStandard("LVCMOS33")
        ),
        ("pmodC", 0,
           Subsignal("io1",  Pins("Y6")), # p1
           Subsignal("io2",  Pins("AA6")), # p2
           Subsignal("io3",  Pins("AA8")), # p3
           Subsignal("io4",  Pins("AB8")), # p4
           Subsignal("io5",  Pins("R6")), # p7
           Subsignal("io6",  Pins("T6")), # p8
           Subsignal("io7",  Pins("AB7")), # p9
           Subsignal("io8",  Pins("AB6")), # p10
           IOStandard("LVCMOS33")
        )
    ])

###################################

class platform:
  def __init__(self):
    self.name = "cmoda7"
    self.baseclass = litex.boards.targets.nexys_video.BaseSoC
    self.extend = extensions
    self.enable_rgbleds = False
    self.djtgname = "CmodA7"
    self.enable_ethernet = False

  def gen(self):
      return top.GenSoc( self )

###################################
