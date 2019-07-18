#!/usr/bin/env python3

from ork.command import run
import ork.path, os

builds = ork.path.prefix()/"builds"
simdir = builds/"soc"/os.environ["FPGAPLAT"]/"simulation"
vcd = simdir/"gateware"/"dut.vcd"
gtkw = simdir/"gateware"/"dut.gtkw"

run(["gtkwave",
     vcd,gtkw])
