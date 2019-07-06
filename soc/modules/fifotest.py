from migen import *
from migen.genlib.fifo import SyncFIFO as SynchronousFifo
from litex.soc.interconnect.csr import *

#######################################################
# Simple CPU->HW and HW->CPU FIFO test
#######################################################

class FIFOTest(Module, AutoCSR):

  def __init__(self, soc):

    fifo_width = 32 # 32 bits wide
    fifo_depth = 16 # 16 items in fifo

    #####################################################
    # out fifo (CPU->FIFO)
    #####################################################

    out_fifo_raw = SynchronousFifo(fifo_width, fifo_depth)
    out_fifo = ResetInserter()(out_fifo_raw)

    self.submodules += out_fifo

    self.out_datareg = CSRStorage(fifo_width, reset=0)
    self.out_ready = CSRStatus()
    self.out_level = CSRStatus(log2_int(fifo_depth)+1)
    self.out_reset = CSRStorage(reset=0)
    self.out_writeoccured = Signal()
    self.out_writecounter = CSRStatus(32,reset=0)

    self.sync += [

        ####################
        # CPU->OUTFIFO
        ####################

        out_fifo.din[0:fifo_width].eq(self.out_datareg.storage[0:fifo_width]),
        out_fifo.we.eq(self.out_datareg.re),
        out_fifo.reset.eq(self.out_reset.re),
        out_fifo.replace.eq(0),
        self.out_writeoccured.eq(out_fifo.we),

        If( self.out_reset.re,
            out_fifo.level.eq(0),
            self.out_datareg.storage.eq(0) ),

        If( self.out_reset.re,
            self.out_writecounter.status.eq(0) ).
        Elif( self.out_datareg.re,
            self.out_writecounter.status.eq(self.out_writecounter.status+1)),

        ####################
        # control / status
        ####################

        self.out_ready.status.eq(out_fifo.writable),
        self.out_level.status.eq(out_fifo.level),
    ]

    #####################################################
    # useless machinery
    # inp fifo (FIFO->CPU) just mirrors what went into out_fifo
    #####################################################

    # cant use a CSR for inp_datareg, CSRs dont work correctly with 32 bit words
    #  mainly because bus widths
    # so use a CSRStatus which can break up fifo_width(32) into bus_width(8) chunks

    self.inp_datareg = CSRStatus(fifo_width)
    self.inp_dataavail = CSRStatus()
    self.inp_level = CSRStatus(8)
    self.inp_ack = CSR()
    self.inp_reset = CSRStorage(reset=0)
    self.inp_writable = CSRStatus()
    self.inp_writeoccured = Signal()
    self.inp_readcounter = CSRStatus(32,reset=0)

    inp_fifo_raw = SynchronousFifo(fifo_width, fifo_depth)
    inp_fifo = ResetInserter()(inp_fifo_raw)

    self.submodules += inp_fifo

    ################################################
    # readstate fsm
    ################################################

    out2inpfsm = genlib.fsm.FSM(reset_state="IDLE")
    self.submodules += out2inpfsm
    out2inpfsm.act("IDLE",
        NextState("WAIT")
    )
    out2inpfsm.act("WAIT",
        If(out_fifo.readable & inp_fifo.writable,
            NextState("READ1")
        )
    )
    out2inpfsm.act("READ1",
        NextState("READ2")
    )
    out2inpfsm.act("READ2",
        NextState("READ3")
    )
    out2inpfsm.act("READ3",
        NextState("READ4")
    )
    out2inpfsm.act("READ4",
        NextState("WAIT")
    )

    ################################################

    self.sync += [

        ####################
        # OUTFIFO->INPFIFO
        ####################


        inp_fifo.we.eq(out2inpfsm.ongoing("READ1")), # inp_fifo read transaction
        self.inp_writeoccured.eq(inp_fifo.we),
        out_fifo.re.eq(self.inp_writeoccured), # out_fifo read ack (above delayed by one cycle)

        inp_fifo.din[0:fifo_width].eq(out_fifo.dout[0:fifo_width]), # outfifo feeds inpfifo
        inp_fifo.replace.eq(0),

        ####################
        # INPFIFO->CPU
        ####################

        inp_fifo.re.eq( self.inp_ack.re ), # read ack from CPU

        If( self.inp_reset.re,
            inp_fifo.level.eq(0),
            self.inp_datareg.status.eq(0) ),

        If( self.inp_reset.re,
            self.inp_readcounter.status.eq(0) ).
        Elif( self.inp_ack.re,
            self.inp_readcounter.status.eq(self.inp_readcounter.status+1)),

        self.inp_datareg.status[0:fifo_width].eq(inp_fifo.dout[0:fifo_width]),
        self.inp_dataavail.status.eq(inp_fifo.readable),
        self.inp_level.status.eq(inp_fifo.level),
        self.inp_writable.status.eq(inp_fifo.writable),
        inp_fifo_raw.reset.eq(self.inp_reset.re),
    ]

    self.comb += [
    ]
