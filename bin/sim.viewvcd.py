#!/usr/bin/env python3

from ork.command import run
import ork.path

builds = ork.path.prefix()/"builds"
simdir = builds/"soc"/"arty"/"simulation"
vcd = simdir/"gateware"/"dut.vcd"

run(["gtkwave",
     vcd])
