#!/usr/bin/env python3
import argparse, os, sys
from pathlib import Path
from ork.command import run
from ork.template import template_file

parser = argparse.ArgumentParser(description='linux build')
args = vars(parser.parse_args())
prjroot = Path(os.environ["PROJECT_ROOT"])
bldroot = Path(os.environ["BUILDROOT_DIR"])
socbuild = Path(os.environ["SOC_BUILD_DIR"])

###############################################################################
# Apply Templates
###############################################################################

bldroot_ext_src = prjroot/"buildroot-ext"
bldroot_ext_dst = socbuild/"buildroot-ext"

##############
# first a blind copy
##############

run(["rm","-rf",bldroot_ext_dst])
run(["cp","-r",bldroot_ext_src,bldroot_ext_dst])

#########################
# now apply the templates
#########################

def do_template(on_path,replacement_list):
    replacement_dict = dict()
    for item in replacement_list:
        replacement_dict[item]=os.environ[item]
    template_file(on_path,replacement_dict)

rootfs_overlay_etc = bldroot_ext_dst/"board"/"testsoc"/"rootfs_overlay"/"etc"

do_template( bldroot_ext_dst/"configs"/"testsoc_defconfig",
             ["SOCPASSWORD"] )

do_template( rootfs_overlay_etc/"network"/"interfaces",
             ["SOCIPADDR","SOCGATEWAY"] )


do_template( rootfs_overlay_etc/"hosts",
             ["DEVHOSTIP","NFSHOSTIP"] )

###############################################################################

os.chdir(bldroot)
os.environ["BR2_EXTERNAL"]=str(bldroot_ext_dst)

run(["make","testsoc_defconfig"])
run(["make"])

copy_src = bldroot/"output"/"images"
copy_dst = prjroot/"tftp_root"/"arty"

cpio_src = copy_src/"rootfs.cpio"
cpio_dst = copy_dst/"rootfs.cpio"
imag_src = copy_src/"Image"
imag_dst = copy_dst/"Image"

run(["cp",cpio_src,cpio_dst])
run(["cp",imag_src,imag_dst])
