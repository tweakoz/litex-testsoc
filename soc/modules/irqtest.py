from migen import *
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *

################################################
# generate a 1 clock pulse on a recurring period
################################################

class Pulsor(Module):
    def __init__(self):
        self.output = output  = Signal()
        self.counter = counter = Signal(24)
        self.prevcounter = prvcnt = Signal(24)

        self.sync += [
            prvcnt.eq(counter),
            counter.eq(counter + 1),
        ]
        self.comb += [
            # should trigger when:
            # counter=0x800000, prvcnt==0x7fffff
            # and
            # counter=0x000000, prvcnt==0xffffff
            # @ 100mhz - should fire about 12 times a second..
            output.eq(counter[23]!=prvcnt[23])
        ]

###################################
# Simple IRQ generator test
#  should fire an IRQ 12 times a second
#   (when pulsor fires)
###################################

class IRQTest(Module, AutoCSR):
  def __init__(self, soc):

    self.submodules.pulsor = pulsor = Pulsor()

    ####################
    # create IRQ event(s)
    ####################

    self.submodules.ev = EventManager()
    self.ev.pulsor = EventSourcePulse() # one shot

    ####################

    soc.comb += [
        self.ev.pulsor.trigger.eq(pulsor.output),
    ]
