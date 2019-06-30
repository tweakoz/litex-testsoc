#!/usr/bin/env python3

import argparse, os, sys
from pathlib import Path
from ork.command import run

parser = argparse.ArgumentParser(description='testsoc launcher')
parser.add_argument('--tty', metavar="tty", default=None, help='arty programming tty' )

args = vars(parser.parse_args())

tty = os.environ["DEVTTY"]

if len(sys.argv)==1 and tty=="/dev/ttyUSBx":
    print(parser.format_usage())
    sys.exit(1)

if args["tty"] != None:
    tty = args["tty"]

print(tty)

soc_dir = Path(os.environ["SOC_BUILD_DIR"])
loader = soc_dir/"software"/"chainloader"/"chainloader.bin"

assert(os.path.exists(loader))
assert(os.path.exists(tty))

run(["build.manifest.py"])

run([ "djtgcfg",
      "prog",
      "-d", "Arty",
      "-i", "0",
      "-f", soc_dir/"gateware"/"top.bit" ])

run([ "litex_term",
      "--speed", "115200",
      tty,
      "--kernel",loader,
      "--kernel-adr","cff00000"])
