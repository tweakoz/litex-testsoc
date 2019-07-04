#!/usr/bin/env python3

import argparse, os, sys
from pathlib import Path
from ork.command import run

parser = argparse.ArgumentParser(description='testsoc launcher')
parser.add_argument('--tty', metavar="tty", default=None, help='arty programming tty' )
parser.add_argument('--standalone', action="store_true", default=None, help='arty programming tty' )

args = vars(parser.parse_args())

tty = os.environ["DEVTTY"]

if len(sys.argv)==1 and tty=="/dev/ttyUSBx":
    print(parser.format_usage())
    sys.exit(1)

if args["tty"] != None:
    tty = args["tty"]

print(tty)

soc_dir = Path(os.environ["SOC_BUILD_DIR"])
prjroot = Path(os.environ["PROJECT_ROOT"])

chainloader = soc_dir/"software"/"chainloader"/"chainloader.bin"
standalone = prjroot/"testapp-standalone"/".build"/"main-device.bin"

assert(os.path.exists(tty))

run(["build.manifest.py"])

run([ "djtgcfg",
      "prog",
      "-d", "Arty",
      "-i", "0",
      "-f", soc_dir/"gateware"/"top.bit" ])

if args["standalone"]:
  assert(os.path.exists(standalone))
  run([ "litex_term",
      "--speed", "115200",
      tty,
      "--kernel",standalone,
      "--kernel-adr","c0000000"])

else:
  assert(os.path.exists(chainloader))
  run([ "litex_term",
      "--speed", "115200",
      tty,
      "--kernel",chainloader,
      "--kernel-adr","cff00000"])
