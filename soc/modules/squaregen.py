###########################################
# a simple module to test verilog wrapping
#  just a basic square wave generator
#   with variable frequency
###########################################

from migen import *
from migen.fhdl.specials import Instance
from litex.soc.cores.clock import *
import os

from litex.soc.interconnect.csr import *

class SQUGEN(Module, AutoCSR):

  def __init__(self, soc, outpin):
    super(SQUGEN, self).__init__()
    self.platform = soc.platform
    self.outpin = outpin
    self.period = CSRStorage(32,reset=0xffffffff)
    params = dict(
        p_clk_freq_hz="100e6",
    )
    self.specials += Instance("squaregen",
        **params,
        i_clk=ClockSignal(),
        i_period=self.period.storage,
        o_pps_o=outpin)

    self.add_sources(self.platform)

  @staticmethod
  def add_sources(platform):
      vdir = os.path.join(
        os.path.abspath(os.path.dirname(__file__)), "verilog")
      platform.add_source(os.path.join(vdir, "squaregen.v"))
