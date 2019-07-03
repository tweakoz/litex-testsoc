## Output run of testapp (main.cpp) on testsoc

```pagesize<4096>
page_base<0xf0000000>
page_offset<0>
mapping addr<f0000000> len<00010000> to<0x35ce3000x>
what up yo mem<0x35be2010>
cputype<VEXRISCV>
registers<0x35ce3000>
c<0.000000 0.000000 -1.000000>

outfifo-level<1>    <--- outfifo starts getting data from cpu here:
outfifo-level<2>
outfifo-level<3>
outfifo-level<4>
entering runloop
outfifo-level<5>
outfifo-level<6>
outfifo-level<7>
outfifo-level<8>
outfifo-level<9>
outfifo-level<10>
outfifo-level<11>
outfifo-level<12>
outfifo-level<13>
outfifo-level<14>
outfifo-level<15>
outfifo-level<16>
outfifo-level<17>
                     <--- inital delay in thr_fifo_recv complete.
inpfifo-level<0>     <--- inpfifo-level should be > 0
inpfifo-level<0>          since outfifo is feeding it..
inpfifo-level<0>
inpfifo-level<0>
inpfifo-level<0>
inpfifo-level<0>
```
