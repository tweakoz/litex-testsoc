#!/usr/bin/env python3

import argparse, os, sys
from pathlib import Path

###################################

this_dir = Path(os.path.dirname(os.path.abspath(__file__)))
prjroot = Path(os.environ["PROJECT_ROOT"])
output_dir = Path(os.environ["SOC_BUILD_DIR"])

###################################

sys.path.append(str(this_dir/".."/"modules"))

import top
the_top = top.get()

from litex.soc.integration.builder import *

builder = Builder( the_top,
                   output_dir=output_dir,
                   csr_csv=str(output_dir/"mysoc_csr.csv"))

builder.build() # finalize here
