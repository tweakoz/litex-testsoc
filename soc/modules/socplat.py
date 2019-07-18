#
import arty, nexysvideo, cmoda7, os

FPGAPLAT="arty"
if "FPGAPLAT" in os.environ:
    FPGAPLAT=os.environ["FPGAPLAT"]

plats = {
    "arty": arty.platform(),
    "nexysvideo": nexysvideo.platform(),
    "cmoda7": cmoda7.platform()
}
def get():
    return plats[FPGAPLAT]
