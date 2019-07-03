#!/usr/bin/env python3

import os, sys
from pathlib import Path

###############################
# paramterize toochain deps
###############################

ixtoolchain = "riscv64-unknown-elf-gcc-8.1.0-2019.01.0-x86_64-linux-ubuntu14"
ixtoolchain_hash = "eb03b15c7c470455f85ac5ccc5c6163c"

openocd = "riscv-openocd-0.10.0-2018.12.0-x86_64-linux-ubuntu14"
openocd_hash = "f22aa7eb72045c741d18bc19c2f94434"

buildroot_rev = "1db7890e0a"

###############################

this_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = (this_dir/"..").resolve()
stage_dir = (project_root/".stage").resolve()
obt_dir = (project_root/"ork.build").resolve()
soc_dir = (project_root/"soc").resolve()
obt_bin_dir = (obt_dir/"bin").resolve()
obt_init_env = (obt_bin_dir/"init_env.py").resolve()
pyenv_dir = (stage_dir/"python-env").resolve()

os.chdir(this_dir)

os.environ["PROJECT_ROOT"] = str(project_root)

###############################
# bootstrap ork.build
###############################

if not os.path.exists(obt_init_env):
    print( "Initializing child repos for you...")
    os.system("git submodule init")
    os.system("git submodule update")

new_venv = False

if not os.path.exists(stage_dir):
    os.system("%s --create %s --command 'echo nop'"%(obt_init_env,stage_dir))
    os.system("virtualenv -p /usr/bin/python3 %s"%pyenv_dir)
    new_venv = True

sys.path.append(str(obt_dir/"scripts"))
os.environ["OBT_STAGE"] = str(stage_dir)
os.environ["ORK_PROJECT_NAME"] = "testsoc"
os.environ["OBT_ROOT"] = str(obt_dir)

from ork.wget import wget
from ork.command import run
from ork import path as obtpath
import ork.env
import ork.deco
import ork.git
import ork.path
import ork.config

deco = ork.deco.Deco()

###############################
# activate virtual env
###############################

print(deco.white("Activating Python Virtual Enviroment @ <%s>"%deco.path(pyenv_dir)))

activate_venv = pyenv_dir/"bin"/"activate_this.py"

import importlib.util
spec = importlib.util.spec_from_file_location("activate", activate_venv )
foo = importlib.util.module_from_spec(spec)
spec.loader.exec_module(foo)

###############################
# install some basics into the virtual env
###############################

if new_venv:
    run(["pip3","install","pyudev"])
    run(["pip3","install","twisted"])
    run(["pip3","install","yarl"])

###############################
# basic directories
###############################

dldir = obtpath.downloads()
builddir = obtpath.builds()
rvtoolchain_ix_dir = builddir/ixtoolchain
openocd_dir = builddir/openocd
buildroot_dir = ork.path.builds()/"buildroot"

###############################
# fetch external dependencies
#  todo : integrate into ork.build
###############################

wget( urls=["https://static.dev.sifive.com/dev-tools/%s.tar.gz"%ixtoolchain],
      output_name="%s.tar.gz" % ixtoolchain,
      md5val = ixtoolchain_hash )
wget( urls=["https://static.dev.sifive.com/dev-tools/%s.tar.gz"%openocd],
      output_name="%s.tar.gz"%openocd,
      md5val = openocd_hash )

if not os.path.exists(buildroot_dir):
    ork.git.Clone( "https://github.com/buildroot/buildroot",
                   buildroot_dir,
                   rev=buildroot_rev,
                   recursive=True )

os.chdir(builddir)

if not os.path.exists(rvtoolchain_ix_dir):
    run([ "tar",
          "-xvf",
          dldir/("%s.tar.gz"%ixtoolchain)])

if not os.path.exists(openocd_dir):
    run([ "tar",
          "-xvf",
          dldir/("%s.tar.gz"%openocd)])

###############################
# load persistent configuration
###############################

config_defaults = {
    "SOCPASSWORD": "yo",
    "SOCIPADDR": "192.168.1.1",
    "SOCGATEWAY": "192.168.1.254",
    "DEVHOSTIP": "192.168.1.2",
    "NFSHOSTIP": "192.168.1.2",
    "TFTPPORT": "6069",
    "DEVTTY": "/dev/ttyUSBx"
}

soc_config_path = stage_dir/"soc-config.json"
my_config = ork.config.merge( soc_config_path,
                              config_defaults )
import json
print(deco.white("###############################"))
print(deco.white("## soc configuration file<%s>"%deco.path(soc_config_path)))
print(deco.white("###############################"))
print(deco.yellow(json.dumps(my_config, sort_keys=True, indent=4)))
print(deco.white("###############################"))

###############################
# set up some env vars
###############################


ork.env.prepend("PATH",rvtoolchain_ix_dir/"bin")
ork.env.prepend("PATH",openocd_dir/"bin")
ork.env.prepend("PATH",buildroot_dir/"output"/"host"/"bin")
ork.env.prepend("PATH",this_dir)
ork.env.prepend("PATH",soc_dir/"bin")

ork.env.set("SOC_DIR",soc_dir)
ork.env.set("OUTPUT_DIR",builddir/"soc")
ork.env.set("SOC_BUILD_DIR",builddir/"soc"/"arty")
ork.env.set("BUILDROOT_DIR",buildroot_dir)

# vars from config
for item in my_config:
    ork.env.set(item,my_config[item])

###############################
# install litex
###############################

try:
    import litex
except:
    os.chdir(builddir)
    os.system("wget https://raw.githubusercontent.com/tweakoz/litex/tweakoz/diagnose_csr/litex_setup.py")
    os.system("python3 ./litex_setup.py init install")
    os.system("python3 ./litex_setup.py update")

ork.env.set("LITEX_ROOT",builddir/"litex"/"litex")

###############################
# lets always boot up the env in project_root
###############################

os.chdir(project_root)

run([obt_init_env,"--launch",stage_dir])
