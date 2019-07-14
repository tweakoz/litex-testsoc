#
import arty, nexysvideo, os

FPGAPLAT="arty"
if "FPGAPLAT" in os.environ:
    FPGAPLAT=os.environ["FPGAPLAT"]

plats = {
    "arty": arty.platform(),
    "nexysvideo": nexysvideo.platform()
}
def get():
    return plats[FPGAPLAT]
