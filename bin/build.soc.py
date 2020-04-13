#!/usr/bin/env python3

import argparse, os, sys
from pathlib import Path
from litex.soc.integration.builder import *

###################################

this_dir = Path(os.path.dirname(os.path.abspath(__file__)))
prjroot = Path(os.environ["PROJECT_ROOT"])
output_dir = Path(os.environ["SOC_BUILD_DIR"])/os.environ["FPGAPLAT"]
sys.path.append(str(prjroot/"soc"/"modules"))

import socplat

###################################

p = socplat.get()

builder = Builder( p.gen(),
                   output_dir=output_dir,
                   compile_gateware=True,
                   compile_software=True,
                   csr_csv=str(output_dir/"mysoc_csr.csv"))

builder.build() # finalize here
