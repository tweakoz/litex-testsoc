#!/usr/bin/env python3
import argparse, os, sys
from pathlib import Path
from ork.command import run

localip = os.environ["SOCIPADDR"].replace(".",",")
remoteip = os.environ["DEVHOSTIP"].replace(".",",")
port = os.environ["TFTPPORT"]

print(localip,remoteip,port)

os.environ["SOC_TFTP_CLIENT_IP"] = localip
os.environ["SOC_TFTP_SERVER_IP"] = remoteip
os.environ["SOC_TFTP_SERVER_PORT"] = port

prjroot = Path(os.environ["PROJECT_ROOT"])
socbldir = Path(os.environ["SOC_BUILD_DIR"])/os.environ["FPGAPLAT"]
os.chdir(prjroot/"litex-chainloader")
run(["make","clean"])
run(["make"])
run(["cp",
     socbldir/"software"/"chainloader"/"chainloader.bin",
     prjroot/"tftp_root"/os.environ["FPGAPLAT"]/"chainloader.bin" ])
