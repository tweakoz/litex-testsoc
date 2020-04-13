#!/usr/bin/env python3

import os
from pathlib import Path

prj_root = Path(os.environ["PROJECT_ROOT"])

dest_dir = (prj_root/"tftp_root"/"arty").resolve()

items = [
    ("emulator.bin", "0x20000000"),
    ("rv32.dtb", "0x40ff0000"),
    ("Image", "0x40000000"),
    ("rootfs.cpio", "0x41000000")
]

with open(dest_dir/"boot.manifest","w") as f:
    for item in items:
        name = item[0]
        addr = item[1]
        size = os.stat(dest_dir/name).st_size
        f.write("download %s %s %d\n"%(name,addr,size))
    f.write("boot 0x20000000\n")
    f.write("end\n\n")

os.system("cat %s" % (dest_dir/"boot.manifest"))
