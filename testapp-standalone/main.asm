
./main.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_ftext>:
       0:	0b00006f          	j	b0 <crt_init>
       4:	00000013          	nop
       8:	00000013          	nop
       c:	00000013          	nop
      10:	00000013          	nop
      14:	00000013          	nop
      18:	00000013          	nop
      1c:	00000013          	nop

00000020 <trap_entry>:
      20:	fe112e23          	sw	ra,-4(sp)
      24:	fe512c23          	sw	t0,-8(sp)
      28:	fe612a23          	sw	t1,-12(sp)
      2c:	fe712823          	sw	t2,-16(sp)
      30:	fea12623          	sw	a0,-20(sp)
      34:	feb12423          	sw	a1,-24(sp)
      38:	fec12223          	sw	a2,-28(sp)
      3c:	fed12023          	sw	a3,-32(sp)
      40:	fce12e23          	sw	a4,-36(sp)
      44:	fcf12c23          	sw	a5,-40(sp)
      48:	fd012a23          	sw	a6,-44(sp)
      4c:	fd112823          	sw	a7,-48(sp)
      50:	fdc12623          	sw	t3,-52(sp)
      54:	fdd12423          	sw	t4,-56(sp)
      58:	fde12223          	sw	t5,-60(sp)
      5c:	fdf12023          	sw	t6,-64(sp)
      60:	fc010113          	addi	sp,sp,-64
      64:	634000ef          	jal	ra,698 <isr>
      68:	03c12083          	lw	ra,60(sp)
      6c:	03812283          	lw	t0,56(sp)
      70:	03412303          	lw	t1,52(sp)
      74:	03012383          	lw	t2,48(sp)
      78:	02c12503          	lw	a0,44(sp)
      7c:	02812583          	lw	a1,40(sp)
      80:	02412603          	lw	a2,36(sp)
      84:	02012683          	lw	a3,32(sp)
      88:	01c12703          	lw	a4,28(sp)
      8c:	01812783          	lw	a5,24(sp)
      90:	01412803          	lw	a6,20(sp)
      94:	01012883          	lw	a7,16(sp)
      98:	00c12e03          	lw	t3,12(sp)
      9c:	00812e83          	lw	t4,8(sp)
      a0:	00412f03          	lw	t5,4(sp)
      a4:	00012f83          	lw	t6,0(sp)
      a8:	04010113          	addi	sp,sp,64
      ac:	30200073          	mret

000000b0 <crt_init>:
      b0:	10008117          	auipc	sp,0x10008
      b4:	f4c10113          	addi	sp,sp,-180 # 10007ffc <_fstack+0x4>
      b8:	00000517          	auipc	a0,0x0
      bc:	f6850513          	addi	a0,a0,-152 # 20 <trap_entry>
      c0:	30551073          	csrw	mtvec,a0

000000c4 <bss_init>:
      c4:	10000517          	auipc	a0,0x10000
      c8:	f3c50513          	addi	a0,a0,-196 # 10000000 <_fbss>
      cc:	10000597          	auipc	a1,0x10000
      d0:	06458593          	addi	a1,a1,100 # 10000130 <_ebss>

000000d4 <bss_loop>:
      d4:	00b50863          	beq	a0,a1,e4 <bss_done>
      d8:	00052023          	sw	zero,0(a0)
      dc:	00450513          	addi	a0,a0,4
      e0:	ff5ff06f          	j	d4 <bss_loop>

000000e4 <bss_done>:
      e4:	00001537          	lui	a0,0x1
      e8:	88050513          	addi	a0,a0,-1920 # 880 <main+0x194>
      ec:	30451073          	csrw	mie,a0
      f0:	5fc000ef          	jal	ra,6ec <main>

000000f4 <infinit_loop>:
      f4:	0000006f          	j	f4 <infinit_loop>

000000f8 <csr_writel>:
      f8:	fe010113          	addi	sp,sp,-32
      fc:	00812e23          	sw	s0,28(sp)
     100:	02010413          	addi	s0,sp,32
     104:	fea42623          	sw	a0,-20(s0)
     108:	feb42423          	sw	a1,-24(s0)
     10c:	fe842783          	lw	a5,-24(s0)
     110:	fec42703          	lw	a4,-20(s0)
     114:	00e7a023          	sw	a4,0(a5)
     118:	00000013          	nop
     11c:	01c12403          	lw	s0,28(sp)
     120:	02010113          	addi	sp,sp,32
     124:	00008067          	ret

00000128 <csr_readl>:
     128:	fe010113          	addi	sp,sp,-32
     12c:	00812e23          	sw	s0,28(sp)
     130:	02010413          	addi	s0,sp,32
     134:	fea42623          	sw	a0,-20(s0)
     138:	fec42783          	lw	a5,-20(s0)
     13c:	0007a783          	lw	a5,0(a5)
     140:	00078513          	mv	a0,a5
     144:	01c12403          	lw	s0,28(sp)
     148:	02010113          	addi	sp,sp,32
     14c:	00008067          	ret

00000150 <fifotest_out_datareg_write>:
     150:	fe010113          	addi	sp,sp,-32
     154:	00112e23          	sw	ra,28(sp)
     158:	00812c23          	sw	s0,24(sp)
     15c:	02010413          	addi	s0,sp,32
     160:	fea42623          	sw	a0,-20(s0)
     164:	fec42783          	lw	a5,-20(s0)
     168:	0187d793          	srli	a5,a5,0x18
     16c:	f00065b7          	lui	a1,0xf0006
     170:	00078513          	mv	a0,a5
     174:	f85ff0ef          	jal	ra,f8 <csr_writel>
     178:	fec42783          	lw	a5,-20(s0)
     17c:	0107d713          	srli	a4,a5,0x10
     180:	f00067b7          	lui	a5,0xf0006
     184:	00478593          	addi	a1,a5,4 # f0006004 <_fstack+0xdfffe00c>
     188:	00070513          	mv	a0,a4
     18c:	f6dff0ef          	jal	ra,f8 <csr_writel>
     190:	fec42783          	lw	a5,-20(s0)
     194:	0087d713          	srli	a4,a5,0x8
     198:	f00067b7          	lui	a5,0xf0006
     19c:	00878593          	addi	a1,a5,8 # f0006008 <_fstack+0xdfffe010>
     1a0:	00070513          	mv	a0,a4
     1a4:	f55ff0ef          	jal	ra,f8 <csr_writel>
     1a8:	f00067b7          	lui	a5,0xf0006
     1ac:	00c78593          	addi	a1,a5,12 # f000600c <_fstack+0xdfffe014>
     1b0:	fec42503          	lw	a0,-20(s0)
     1b4:	f45ff0ef          	jal	ra,f8 <csr_writel>
     1b8:	00000013          	nop
     1bc:	01c12083          	lw	ra,28(sp)
     1c0:	01812403          	lw	s0,24(sp)
     1c4:	02010113          	addi	sp,sp,32
     1c8:	00008067          	ret

000001cc <fifotest_out_ready_read>:
     1cc:	fe010113          	addi	sp,sp,-32
     1d0:	00112e23          	sw	ra,28(sp)
     1d4:	00812c23          	sw	s0,24(sp)
     1d8:	02010413          	addi	s0,sp,32
     1dc:	f00067b7          	lui	a5,0xf0006
     1e0:	01078513          	addi	a0,a5,16 # f0006010 <_fstack+0xdfffe018>
     1e4:	f45ff0ef          	jal	ra,128 <csr_readl>
     1e8:	00050793          	mv	a5,a0
     1ec:	fef407a3          	sb	a5,-17(s0)
     1f0:	fef44783          	lbu	a5,-17(s0)
     1f4:	00078513          	mv	a0,a5
     1f8:	01c12083          	lw	ra,28(sp)
     1fc:	01812403          	lw	s0,24(sp)
     200:	02010113          	addi	sp,sp,32
     204:	00008067          	ret

00000208 <fifotest_out_level_read>:
     208:	fe010113          	addi	sp,sp,-32
     20c:	00112e23          	sw	ra,28(sp)
     210:	00812c23          	sw	s0,24(sp)
     214:	02010413          	addi	s0,sp,32
     218:	f00067b7          	lui	a5,0xf0006
     21c:	01478513          	addi	a0,a5,20 # f0006014 <_fstack+0xdfffe01c>
     220:	f09ff0ef          	jal	ra,128 <csr_readl>
     224:	00050793          	mv	a5,a0
     228:	fef407a3          	sb	a5,-17(s0)
     22c:	fef44783          	lbu	a5,-17(s0)
     230:	00078513          	mv	a0,a5
     234:	01c12083          	lw	ra,28(sp)
     238:	01812403          	lw	s0,24(sp)
     23c:	02010113          	addi	sp,sp,32
     240:	00008067          	ret

00000244 <fifotest_inp_datareg_read>:
     244:	fe010113          	addi	sp,sp,-32
     248:	00112e23          	sw	ra,28(sp)
     24c:	00812c23          	sw	s0,24(sp)
     250:	02010413          	addi	s0,sp,32
     254:	f00067b7          	lui	a5,0xf0006
     258:	01878513          	addi	a0,a5,24 # f0006018 <_fstack+0xdfffe020>
     25c:	ecdff0ef          	jal	ra,128 <csr_readl>
     260:	fea42623          	sw	a0,-20(s0)
     264:	fec42783          	lw	a5,-20(s0)
     268:	00879793          	slli	a5,a5,0x8
     26c:	fef42623          	sw	a5,-20(s0)
     270:	f00067b7          	lui	a5,0xf0006
     274:	01c78513          	addi	a0,a5,28 # f000601c <_fstack+0xdfffe024>
     278:	eb1ff0ef          	jal	ra,128 <csr_readl>
     27c:	00050713          	mv	a4,a0
     280:	fec42783          	lw	a5,-20(s0)
     284:	00e7e7b3          	or	a5,a5,a4
     288:	fef42623          	sw	a5,-20(s0)
     28c:	fec42783          	lw	a5,-20(s0)
     290:	00879793          	slli	a5,a5,0x8
     294:	fef42623          	sw	a5,-20(s0)
     298:	f00067b7          	lui	a5,0xf0006
     29c:	02078513          	addi	a0,a5,32 # f0006020 <_fstack+0xdfffe028>
     2a0:	e89ff0ef          	jal	ra,128 <csr_readl>
     2a4:	00050713          	mv	a4,a0
     2a8:	fec42783          	lw	a5,-20(s0)
     2ac:	00e7e7b3          	or	a5,a5,a4
     2b0:	fef42623          	sw	a5,-20(s0)
     2b4:	fec42783          	lw	a5,-20(s0)
     2b8:	00879793          	slli	a5,a5,0x8
     2bc:	fef42623          	sw	a5,-20(s0)
     2c0:	f00067b7          	lui	a5,0xf0006
     2c4:	02478513          	addi	a0,a5,36 # f0006024 <_fstack+0xdfffe02c>
     2c8:	e61ff0ef          	jal	ra,128 <csr_readl>
     2cc:	00050713          	mv	a4,a0
     2d0:	fec42783          	lw	a5,-20(s0)
     2d4:	00e7e7b3          	or	a5,a5,a4
     2d8:	fef42623          	sw	a5,-20(s0)
     2dc:	fec42783          	lw	a5,-20(s0)
     2e0:	00078513          	mv	a0,a5
     2e4:	01c12083          	lw	ra,28(sp)
     2e8:	01812403          	lw	s0,24(sp)
     2ec:	02010113          	addi	sp,sp,32
     2f0:	00008067          	ret

000002f4 <fifotest_inp_dataavail_read>:
     2f4:	fe010113          	addi	sp,sp,-32
     2f8:	00112e23          	sw	ra,28(sp)
     2fc:	00812c23          	sw	s0,24(sp)
     300:	02010413          	addi	s0,sp,32
     304:	f00067b7          	lui	a5,0xf0006
     308:	02878513          	addi	a0,a5,40 # f0006028 <_fstack+0xdfffe030>
     30c:	e1dff0ef          	jal	ra,128 <csr_readl>
     310:	00050793          	mv	a5,a0
     314:	fef407a3          	sb	a5,-17(s0)
     318:	fef44783          	lbu	a5,-17(s0)
     31c:	00078513          	mv	a0,a5
     320:	01c12083          	lw	ra,28(sp)
     324:	01812403          	lw	s0,24(sp)
     328:	02010113          	addi	sp,sp,32
     32c:	00008067          	ret

00000330 <fifotest_inp_level_read>:
     330:	fe010113          	addi	sp,sp,-32
     334:	00112e23          	sw	ra,28(sp)
     338:	00812c23          	sw	s0,24(sp)
     33c:	02010413          	addi	s0,sp,32
     340:	f00067b7          	lui	a5,0xf0006
     344:	02c78513          	addi	a0,a5,44 # f000602c <_fstack+0xdfffe034>
     348:	de1ff0ef          	jal	ra,128 <csr_readl>
     34c:	00050793          	mv	a5,a0
     350:	fef407a3          	sb	a5,-17(s0)
     354:	fef44783          	lbu	a5,-17(s0)
     358:	00078513          	mv	a0,a5
     35c:	01c12083          	lw	ra,28(sp)
     360:	01812403          	lw	s0,24(sp)
     364:	02010113          	addi	sp,sp,32
     368:	00008067          	ret

0000036c <rgbledA_g_enable_write>:
     36c:	fe010113          	addi	sp,sp,-32
     370:	00112e23          	sw	ra,28(sp)
     374:	00812c23          	sw	s0,24(sp)
     378:	02010413          	addi	s0,sp,32
     37c:	00050793          	mv	a5,a0
     380:	fef407a3          	sb	a5,-17(s0)
     384:	fef44703          	lbu	a4,-17(s0)
     388:	f00037b7          	lui	a5,0xf0003
     38c:	82478593          	addi	a1,a5,-2012 # f0002824 <_fstack+0xdfffa82c>
     390:	00070513          	mv	a0,a4
     394:	d65ff0ef          	jal	ra,f8 <csr_writel>
     398:	00000013          	nop
     39c:	01c12083          	lw	ra,28(sp)
     3a0:	01812403          	lw	s0,24(sp)
     3a4:	02010113          	addi	sp,sp,32
     3a8:	00008067          	ret

000003ac <rgbledA_g_width_write>:
     3ac:	fe010113          	addi	sp,sp,-32
     3b0:	00112e23          	sw	ra,28(sp)
     3b4:	00812c23          	sw	s0,24(sp)
     3b8:	02010413          	addi	s0,sp,32
     3bc:	fea42623          	sw	a0,-20(s0)
     3c0:	fec42783          	lw	a5,-20(s0)
     3c4:	0187d713          	srli	a4,a5,0x18
     3c8:	f00037b7          	lui	a5,0xf0003
     3cc:	82878593          	addi	a1,a5,-2008 # f0002828 <_fstack+0xdfffa830>
     3d0:	00070513          	mv	a0,a4
     3d4:	d25ff0ef          	jal	ra,f8 <csr_writel>
     3d8:	fec42783          	lw	a5,-20(s0)
     3dc:	0107d713          	srli	a4,a5,0x10
     3e0:	f00037b7          	lui	a5,0xf0003
     3e4:	82c78593          	addi	a1,a5,-2004 # f000282c <_fstack+0xdfffa834>
     3e8:	00070513          	mv	a0,a4
     3ec:	d0dff0ef          	jal	ra,f8 <csr_writel>
     3f0:	fec42783          	lw	a5,-20(s0)
     3f4:	0087d713          	srli	a4,a5,0x8
     3f8:	f00037b7          	lui	a5,0xf0003
     3fc:	83078593          	addi	a1,a5,-2000 # f0002830 <_fstack+0xdfffa838>
     400:	00070513          	mv	a0,a4
     404:	cf5ff0ef          	jal	ra,f8 <csr_writel>
     408:	f00037b7          	lui	a5,0xf0003
     40c:	83478593          	addi	a1,a5,-1996 # f0002834 <_fstack+0xdfffa83c>
     410:	fec42503          	lw	a0,-20(s0)
     414:	ce5ff0ef          	jal	ra,f8 <csr_writel>
     418:	00000013          	nop
     41c:	01c12083          	lw	ra,28(sp)
     420:	01812403          	lw	s0,24(sp)
     424:	02010113          	addi	sp,sp,32
     428:	00008067          	ret

0000042c <rgbledA_g_period_write>:
     42c:	fe010113          	addi	sp,sp,-32
     430:	00112e23          	sw	ra,28(sp)
     434:	00812c23          	sw	s0,24(sp)
     438:	02010413          	addi	s0,sp,32
     43c:	fea42623          	sw	a0,-20(s0)
     440:	fec42783          	lw	a5,-20(s0)
     444:	0187d713          	srli	a4,a5,0x18
     448:	f00037b7          	lui	a5,0xf0003
     44c:	83878593          	addi	a1,a5,-1992 # f0002838 <_fstack+0xdfffa840>
     450:	00070513          	mv	a0,a4
     454:	ca5ff0ef          	jal	ra,f8 <csr_writel>
     458:	fec42783          	lw	a5,-20(s0)
     45c:	0107d713          	srli	a4,a5,0x10
     460:	f00037b7          	lui	a5,0xf0003
     464:	83c78593          	addi	a1,a5,-1988 # f000283c <_fstack+0xdfffa844>
     468:	00070513          	mv	a0,a4
     46c:	c8dff0ef          	jal	ra,f8 <csr_writel>
     470:	fec42783          	lw	a5,-20(s0)
     474:	0087d713          	srli	a4,a5,0x8
     478:	f00037b7          	lui	a5,0xf0003
     47c:	84078593          	addi	a1,a5,-1984 # f0002840 <_fstack+0xdfffa848>
     480:	00070513          	mv	a0,a4
     484:	c75ff0ef          	jal	ra,f8 <csr_writel>
     488:	f00037b7          	lui	a5,0xf0003
     48c:	84478593          	addi	a1,a5,-1980 # f0002844 <_fstack+0xdfffa84c>
     490:	fec42503          	lw	a0,-20(s0)
     494:	c65ff0ef          	jal	ra,f8 <csr_writel>
     498:	00000013          	nop
     49c:	01c12083          	lw	ra,28(sp)
     4a0:	01812403          	lw	s0,24(sp)
     4a4:	02010113          	addi	sp,sp,32
     4a8:	00008067          	ret

000004ac <rgbledA_b_enable_write>:
     4ac:	fe010113          	addi	sp,sp,-32
     4b0:	00112e23          	sw	ra,28(sp)
     4b4:	00812c23          	sw	s0,24(sp)
     4b8:	02010413          	addi	s0,sp,32
     4bc:	00050793          	mv	a5,a0
     4c0:	fef407a3          	sb	a5,-17(s0)
     4c4:	fef44703          	lbu	a4,-17(s0)
     4c8:	f00037b7          	lui	a5,0xf0003
     4cc:	84878593          	addi	a1,a5,-1976 # f0002848 <_fstack+0xdfffa850>
     4d0:	00070513          	mv	a0,a4
     4d4:	c25ff0ef          	jal	ra,f8 <csr_writel>
     4d8:	00000013          	nop
     4dc:	01c12083          	lw	ra,28(sp)
     4e0:	01812403          	lw	s0,24(sp)
     4e4:	02010113          	addi	sp,sp,32
     4e8:	00008067          	ret

000004ec <rgbledA_b_width_write>:
     4ec:	fe010113          	addi	sp,sp,-32
     4f0:	00112e23          	sw	ra,28(sp)
     4f4:	00812c23          	sw	s0,24(sp)
     4f8:	02010413          	addi	s0,sp,32
     4fc:	fea42623          	sw	a0,-20(s0)
     500:	fec42783          	lw	a5,-20(s0)
     504:	0187d713          	srli	a4,a5,0x18
     508:	f00037b7          	lui	a5,0xf0003
     50c:	84c78593          	addi	a1,a5,-1972 # f000284c <_fstack+0xdfffa854>
     510:	00070513          	mv	a0,a4
     514:	be5ff0ef          	jal	ra,f8 <csr_writel>
     518:	fec42783          	lw	a5,-20(s0)
     51c:	0107d713          	srli	a4,a5,0x10
     520:	f00037b7          	lui	a5,0xf0003
     524:	85078593          	addi	a1,a5,-1968 # f0002850 <_fstack+0xdfffa858>
     528:	00070513          	mv	a0,a4
     52c:	bcdff0ef          	jal	ra,f8 <csr_writel>
     530:	fec42783          	lw	a5,-20(s0)
     534:	0087d713          	srli	a4,a5,0x8
     538:	f00037b7          	lui	a5,0xf0003
     53c:	85478593          	addi	a1,a5,-1964 # f0002854 <_fstack+0xdfffa85c>
     540:	00070513          	mv	a0,a4
     544:	bb5ff0ef          	jal	ra,f8 <csr_writel>
     548:	f00037b7          	lui	a5,0xf0003
     54c:	85878593          	addi	a1,a5,-1960 # f0002858 <_fstack+0xdfffa860>
     550:	fec42503          	lw	a0,-20(s0)
     554:	ba5ff0ef          	jal	ra,f8 <csr_writel>
     558:	00000013          	nop
     55c:	01c12083          	lw	ra,28(sp)
     560:	01812403          	lw	s0,24(sp)
     564:	02010113          	addi	sp,sp,32
     568:	00008067          	ret

0000056c <rgbledA_b_period_write>:
     56c:	fe010113          	addi	sp,sp,-32
     570:	00112e23          	sw	ra,28(sp)
     574:	00812c23          	sw	s0,24(sp)
     578:	02010413          	addi	s0,sp,32
     57c:	fea42623          	sw	a0,-20(s0)
     580:	fec42783          	lw	a5,-20(s0)
     584:	0187d713          	srli	a4,a5,0x18
     588:	f00037b7          	lui	a5,0xf0003
     58c:	85c78593          	addi	a1,a5,-1956 # f000285c <_fstack+0xdfffa864>
     590:	00070513          	mv	a0,a4
     594:	b65ff0ef          	jal	ra,f8 <csr_writel>
     598:	fec42783          	lw	a5,-20(s0)
     59c:	0107d713          	srli	a4,a5,0x10
     5a0:	f00037b7          	lui	a5,0xf0003
     5a4:	86078593          	addi	a1,a5,-1952 # f0002860 <_fstack+0xdfffa868>
     5a8:	00070513          	mv	a0,a4
     5ac:	b4dff0ef          	jal	ra,f8 <csr_writel>
     5b0:	fec42783          	lw	a5,-20(s0)
     5b4:	0087d713          	srli	a4,a5,0x8
     5b8:	f00037b7          	lui	a5,0xf0003
     5bc:	86478593          	addi	a1,a5,-1948 # f0002864 <_fstack+0xdfffa86c>
     5c0:	00070513          	mv	a0,a4
     5c4:	b35ff0ef          	jal	ra,f8 <csr_writel>
     5c8:	f00037b7          	lui	a5,0xf0003
     5cc:	86878593          	addi	a1,a5,-1944 # f0002868 <_fstack+0xdfffa870>
     5d0:	fec42503          	lw	a0,-20(s0)
     5d4:	b25ff0ef          	jal	ra,f8 <csr_writel>
     5d8:	00000013          	nop
     5dc:	01c12083          	lw	ra,28(sp)
     5e0:	01812403          	lw	s0,24(sp)
     5e4:	02010113          	addi	sp,sp,32
     5e8:	00008067          	ret

000005ec <irq_setie>:
     5ec:	fe010113          	addi	sp,sp,-32
     5f0:	00812e23          	sw	s0,28(sp)
     5f4:	02010413          	addi	s0,sp,32
     5f8:	fea42623          	sw	a0,-20(s0)
     5fc:	fec42783          	lw	a5,-20(s0)
     600:	00078663          	beqz	a5,60c <irq_setie+0x20>
     604:	30046073          	csrsi	mstatus,8
     608:	0080006f          	j	610 <irq_setie+0x24>
     60c:	30047073          	csrci	mstatus,8
     610:	00000013          	nop
     614:	01c12403          	lw	s0,28(sp)
     618:	02010113          	addi	sp,sp,32
     61c:	00008067          	ret

00000620 <irq_getmask>:
     620:	fe010113          	addi	sp,sp,-32
     624:	00812e23          	sw	s0,28(sp)
     628:	02010413          	addi	s0,sp,32
     62c:	bc0027f3          	csrr	a5,0xbc0
     630:	fef42623          	sw	a5,-20(s0)
     634:	fec42783          	lw	a5,-20(s0)
     638:	00078513          	mv	a0,a5
     63c:	01c12403          	lw	s0,28(sp)
     640:	02010113          	addi	sp,sp,32
     644:	00008067          	ret

00000648 <irq_setmask>:
     648:	fe010113          	addi	sp,sp,-32
     64c:	00812e23          	sw	s0,28(sp)
     650:	02010413          	addi	s0,sp,32
     654:	fea42623          	sw	a0,-20(s0)
     658:	fec42783          	lw	a5,-20(s0)
     65c:	bc079073          	csrw	0xbc0,a5
     660:	00000013          	nop
     664:	01c12403          	lw	s0,28(sp)
     668:	02010113          	addi	sp,sp,32
     66c:	00008067          	ret

00000670 <irq_pending>:
     670:	fe010113          	addi	sp,sp,-32
     674:	00812e23          	sw	s0,28(sp)
     678:	02010413          	addi	s0,sp,32
     67c:	fc0027f3          	csrr	a5,0xfc0
     680:	fef42623          	sw	a5,-20(s0)
     684:	fec42783          	lw	a5,-20(s0)
     688:	00078513          	mv	a0,a5
     68c:	01c12403          	lw	s0,28(sp)
     690:	02010113          	addi	sp,sp,32
     694:	00008067          	ret

00000698 <isr>:
     698:	fe010113          	addi	sp,sp,-32
     69c:	00112e23          	sw	ra,28(sp)
     6a0:	00812c23          	sw	s0,24(sp)
     6a4:	00912a23          	sw	s1,20(sp)
     6a8:	02010413          	addi	s0,sp,32
     6ac:	fc5ff0ef          	jal	ra,670 <irq_pending>
     6b0:	00050493          	mv	s1,a0
     6b4:	f6dff0ef          	jal	ra,620 <irq_getmask>
     6b8:	00050793          	mv	a5,a0
     6bc:	00f4f7b3          	and	a5,s1,a5
     6c0:	fef42623          	sw	a5,-20(s0)
     6c4:	fec42783          	lw	a5,-20(s0)
     6c8:	0027f793          	andi	a5,a5,2
     6cc:	00078463          	beqz	a5,6d4 <isr+0x3c>
     6d0:	6b1000ef          	jal	ra,1580 <uart_isr>
     6d4:	00000013          	nop
     6d8:	01c12083          	lw	ra,28(sp)
     6dc:	01812403          	lw	s0,24(sp)
     6e0:	01412483          	lw	s1,20(sp)
     6e4:	02010113          	addi	sp,sp,32
     6e8:	00008067          	ret

000006ec <main>:
     6ec:	f8010113          	addi	sp,sp,-128
     6f0:	06112e23          	sw	ra,124(sp)
     6f4:	06812c23          	sw	s0,120(sp)
     6f8:	07212a23          	sw	s2,116(sp)
     6fc:	07312823          	sw	s3,112(sp)
     700:	07412623          	sw	s4,108(sp)
     704:	07512423          	sw	s5,104(sp)
     708:	08010413          	addi	s0,sp,128
     70c:	f8a42623          	sw	a0,-116(s0)
     710:	f8b42423          	sw	a1,-120(s0)
     714:	fc042423          	sw	zero,-56(s0)
     718:	00000513          	li	a0,0
     71c:	f2dff0ef          	jal	ra,648 <irq_setmask>
     720:	00100513          	li	a0,1
     724:	ec9ff0ef          	jal	ra,5ec <irq_setie>
     728:	014010ef          	jal	ra,173c <uart_init>
     72c:	000027b7          	lui	a5,0x2
     730:	ca878513          	addi	a0,a5,-856 # 1ca8 <_frodata>
     734:	551000ef          	jal	ra,1484 <puts>
     738:	04c010ef          	jal	ra,1784 <uart_sync>
     73c:	05f5e7b7          	lui	a5,0x5f5e
     740:	10078793          	addi	a5,a5,256 # 5f5e100 <_erodata+0x5f5c298>
     744:	00000813          	li	a6,0
     748:	fcf42023          	sw	a5,-64(s0)
     74c:	fd042223          	sw	a6,-60(s0)
     750:	00000793          	li	a5,0
     754:	00000813          	li	a6,0
     758:	fcf42c23          	sw	a5,-40(s0)
     75c:	fd042e23          	sw	a6,-36(s0)
     760:	00100513          	li	a0,1
     764:	d49ff0ef          	jal	ra,4ac <rgbledA_b_enable_write>
     768:	000107b7          	lui	a5,0x10
     76c:	fff78513          	addi	a0,a5,-1 # ffff <_erodata+0xe197>
     770:	dfdff0ef          	jal	ra,56c <rgbledA_b_period_write>
     774:	00100513          	li	a0,1
     778:	bf5ff0ef          	jal	ra,36c <rgbledA_g_enable_write>
     77c:	000107b7          	lui	a5,0x10
     780:	fff78513          	addi	a0,a5,-1 # ffff <_erodata+0xe197>
     784:	ca9ff0ef          	jal	ra,42c <rgbledA_g_period_write>
     788:	fd842703          	lw	a4,-40(s0)
     78c:	000107b7          	lui	a5,0x10
     790:	fff78793          	addi	a5,a5,-1 # ffff <_erodata+0xe197>
     794:	00f777b3          	and	a5,a4,a5
     798:	faf42c23          	sw	a5,-72(s0)
     79c:	fdc42783          	lw	a5,-36(s0)
     7a0:	0007f793          	andi	a5,a5,0
     7a4:	faf42e23          	sw	a5,-68(s0)
     7a8:	fbc42783          	lw	a5,-68(s0)
     7ac:	00079c63          	bnez	a5,7c4 <main+0xd8>
     7b0:	fbc42783          	lw	a5,-68(s0)
     7b4:	04079463          	bnez	a5,7fc <main+0x110>
     7b8:	fb842703          	lw	a4,-72(s0)
     7bc:	000087b7          	lui	a5,0x8
     7c0:	02f76e63          	bltu	a4,a5,7fc <main+0x110>
     7c4:	000107b7          	lui	a5,0x10
     7c8:	fff78793          	addi	a5,a5,-1 # ffff <_erodata+0xe197>
     7cc:	00000813          	li	a6,0
     7d0:	fb842583          	lw	a1,-72(s0)
     7d4:	fbc42603          	lw	a2,-68(s0)
     7d8:	40b786b3          	sub	a3,a5,a1
     7dc:	00068513          	mv	a0,a3
     7e0:	00a7b533          	sltu	a0,a5,a0
     7e4:	40c80733          	sub	a4,a6,a2
     7e8:	40a707b3          	sub	a5,a4,a0
     7ec:	00078713          	mv	a4,a5
     7f0:	00068793          	mv	a5,a3
     7f4:	00070813          	mv	a6,a4
     7f8:	00c0006f          	j	804 <main+0x118>
     7fc:	fb842783          	lw	a5,-72(s0)
     800:	fbc42803          	lw	a6,-68(s0)
     804:	faf42823          	sw	a5,-80(s0)
     808:	fb042a23          	sw	a6,-76(s0)
     80c:	fb442783          	lw	a5,-76(s0)
     810:	01579793          	slli	a5,a5,0x15
     814:	fb042703          	lw	a4,-80(s0)
     818:	00b75913          	srli	s2,a4,0xb
     81c:	0127e933          	or	s2,a5,s2
     820:	fb442783          	lw	a5,-76(s0)
     824:	00b7d993          	srli	s3,a5,0xb
     828:	00090793          	mv	a5,s2
     82c:	00479793          	slli	a5,a5,0x4
     830:	0ff7f793          	andi	a5,a5,255
     834:	00078513          	mv	a0,a5
     838:	cb5ff0ef          	jal	ra,4ec <rgbledA_b_width_write>
     83c:	fb442783          	lw	a5,-76(s0)
     840:	01579793          	slli	a5,a5,0x15
     844:	fb042703          	lw	a4,-80(s0)
     848:	00b75a13          	srli	s4,a4,0xb
     84c:	0147ea33          	or	s4,a5,s4
     850:	fb442783          	lw	a5,-76(s0)
     854:	00b7da93          	srli	s5,a5,0xb
     858:	000a0793          	mv	a5,s4
     85c:	00479793          	slli	a5,a5,0x4
     860:	0ff7f793          	andi	a5,a5,255
     864:	00078513          	mv	a0,a5
     868:	b45ff0ef          	jal	ra,3ac <rgbledA_g_width_write>
     86c:	99dff0ef          	jal	ra,208 <fifotest_out_level_read>
     870:	00050793          	mv	a5,a0
     874:	faf42623          	sw	a5,-84(s0)
     878:	fac42583          	lw	a1,-84(s0)
     87c:	000027b7          	lui	a5,0x2
     880:	cb878513          	addi	a0,a5,-840 # 1cb8 <_frodata+0x10>
     884:	4c1000ef          	jal	ra,1544 <printf>
     888:	945ff0ef          	jal	ra,1cc <fifotest_out_ready_read>
     88c:	00050793          	mv	a5,a0
     890:	00f037b3          	snez	a5,a5
     894:	0ff7f793          	andi	a5,a5,255
     898:	04078663          	beqz	a5,8e4 <main+0x1f8>
     89c:	215000ef          	jal	ra,12b0 <rand>
     8a0:	00050713          	mv	a4,a0
     8a4:	000107b7          	lui	a5,0x10
     8a8:	fff78793          	addi	a5,a5,-1 # ffff <_erodata+0xe197>
     8ac:	00f777b3          	and	a5,a4,a5
     8b0:	faf42423          	sw	a5,-88(s0)
     8b4:	1fd000ef          	jal	ra,12b0 <rand>
     8b8:	00050793          	mv	a5,a0
     8bc:	01079793          	slli	a5,a5,0x10
     8c0:	fa842703          	lw	a4,-88(s0)
     8c4:	00f767b3          	or	a5,a4,a5
     8c8:	faf42423          	sw	a5,-88(s0)
     8cc:	fa842583          	lw	a1,-88(s0)
     8d0:	000027b7          	lui	a5,0x2
     8d4:	cc878513          	addi	a0,a5,-824 # 1cc8 <_frodata+0x20>
     8d8:	46d000ef          	jal	ra,1544 <printf>
     8dc:	fa842503          	lw	a0,-88(s0)
     8e0:	871ff0ef          	jal	ra,150 <fifotest_out_datareg_write>
     8e4:	00100793          	li	a5,1
     8e8:	fcf42a23          	sw	a5,-44(s0)
     8ec:	fd442703          	lw	a4,-44(s0)
     8f0:	00200793          	li	a5,2
     8f4:	00e7ca63          	blt	a5,a4,908 <main+0x21c>
     8f8:	fd442783          	lw	a5,-44(s0)
     8fc:	00178793          	addi	a5,a5,1
     900:	fcf42a23          	sw	a5,-44(s0)
     904:	fe9ff06f          	j	8ec <main+0x200>
     908:	fc0409a3          	sb	zero,-45(s0)
     90c:	fd344783          	lbu	a5,-45(s0)
     910:	06079463          	bnez	a5,978 <main+0x28c>
     914:	a1dff0ef          	jal	ra,330 <fifotest_inp_level_read>
     918:	00050793          	mv	a5,a0
     91c:	faf42223          	sw	a5,-92(s0)
     920:	9d5ff0ef          	jal	ra,2f4 <fifotest_inp_dataavail_read>
     924:	00050793          	mv	a5,a0
     928:	faf401a3          	sb	a5,-93(s0)
     92c:	fa442583          	lw	a1,-92(s0)
     930:	000027b7          	lui	a5,0x2
     934:	cd878513          	addi	a0,a5,-808 # 1cd8 <_frodata+0x30>
     938:	40d000ef          	jal	ra,1544 <printf>
     93c:	fa344783          	lbu	a5,-93(s0)
     940:	00078593          	mv	a1,a5
     944:	000027b7          	lui	a5,0x2
     948:	ce878513          	addi	a0,a5,-792 # 1ce8 <_frodata+0x40>
     94c:	3f9000ef          	jal	ra,1544 <printf>
     950:	fa344783          	lbu	a5,-93(s0)
     954:	fa078ce3          	beqz	a5,90c <main+0x220>
     958:	000027b7          	lui	a5,0x2
     95c:	cf878513          	addi	a0,a5,-776 # 1cf8 <_frodata+0x50>
     960:	325000ef          	jal	ra,1484 <puts>
     964:	8e1ff0ef          	jal	ra,244 <fifotest_inp_datareg_read>
     968:	f8a42e23          	sw	a0,-100(s0)
     96c:	00100793          	li	a5,1
     970:	fcf409a3          	sb	a5,-45(s0)
     974:	f99ff06f          	j	90c <main+0x220>
     978:	00100793          	li	a5,1
     97c:	fcf42623          	sw	a5,-52(s0)
     980:	fcc42703          	lw	a4,-52(s0)
     984:	009897b7          	lui	a5,0x989
     988:	67f78793          	addi	a5,a5,1663 # 98967f <_erodata+0x987817>
     98c:	00e7ca63          	blt	a5,a4,9a0 <main+0x2b4>
     990:	fcc42783          	lw	a5,-52(s0)
     994:	00178793          	addi	a5,a5,1
     998:	fcf42623          	sw	a5,-52(s0)
     99c:	fe5ff06f          	j	980 <main+0x294>
     9a0:	fd842683          	lw	a3,-40(s0)
     9a4:	fdc42703          	lw	a4,-36(s0)
     9a8:	00100593          	li	a1,1
     9ac:	00000613          	li	a2,0
     9b0:	00b687b3          	add	a5,a3,a1
     9b4:	00078513          	mv	a0,a5
     9b8:	00d53533          	sltu	a0,a0,a3
     9bc:	00c70833          	add	a6,a4,a2
     9c0:	01050733          	add	a4,a0,a6
     9c4:	00070813          	mv	a6,a4
     9c8:	fcf42c23          	sw	a5,-40(s0)
     9cc:	fd042e23          	sw	a6,-36(s0)
     9d0:	db9ff06f          	j	788 <main+0x9c>

000009d4 <strchr>:
     9d4:	0ff5f593          	andi	a1,a1,255
     9d8:	00054783          	lbu	a5,0(a0)
     9dc:	00b79463          	bne	a5,a1,9e4 <strchr+0x10>
     9e0:	00008067          	ret
     9e4:	00078663          	beqz	a5,9f0 <strchr+0x1c>
     9e8:	00150513          	addi	a0,a0,1
     9ec:	fedff06f          	j	9d8 <strchr+0x4>
     9f0:	00000513          	li	a0,0
     9f4:	00008067          	ret

000009f8 <strpbrk>:
     9f8:	00054703          	lbu	a4,0(a0)
     9fc:	02071263          	bnez	a4,a20 <strpbrk+0x28>
     a00:	00000513          	li	a0,0
     a04:	00008067          	ret
     a08:	fee68ee3          	beq	a3,a4,a04 <strpbrk+0xc>
     a0c:	00178793          	addi	a5,a5,1
     a10:	0007c683          	lbu	a3,0(a5)
     a14:	fe069ae3          	bnez	a3,a08 <strpbrk+0x10>
     a18:	00150513          	addi	a0,a0,1
     a1c:	fddff06f          	j	9f8 <strpbrk>
     a20:	00058793          	mv	a5,a1
     a24:	fedff06f          	j	a10 <strpbrk+0x18>

00000a28 <strnchr>:
     a28:	00b505b3          	add	a1,a0,a1
     a2c:	0ff67613          	andi	a2,a2,255
     a30:	00b50663          	beq	a0,a1,a3c <strnchr+0x14>
     a34:	00054783          	lbu	a5,0(a0)
     a38:	00079663          	bnez	a5,a44 <strnchr+0x1c>
     a3c:	00000513          	li	a0,0
     a40:	00008067          	ret
     a44:	fef60ee3          	beq	a2,a5,a40 <strnchr+0x18>
     a48:	00150513          	addi	a0,a0,1
     a4c:	fe5ff06f          	j	a30 <strnchr+0x8>

00000a50 <strcpy>:
     a50:	00050793          	mv	a5,a0
     a54:	00158593          	addi	a1,a1,1 # f0006001 <_fstack+0xdfffe009>
     a58:	fff5c703          	lbu	a4,-1(a1)
     a5c:	00178793          	addi	a5,a5,1
     a60:	fee78fa3          	sb	a4,-1(a5)
     a64:	fe0718e3          	bnez	a4,a54 <strcpy+0x4>
     a68:	00008067          	ret

00000a6c <strncpy>:
     a6c:	00c50633          	add	a2,a0,a2
     a70:	00050793          	mv	a5,a0
     a74:	00c79463          	bne	a5,a2,a7c <strncpy+0x10>
     a78:	00008067          	ret
     a7c:	0005c703          	lbu	a4,0(a1)
     a80:	00e78023          	sb	a4,0(a5)
     a84:	00070463          	beqz	a4,a8c <strncpy+0x20>
     a88:	00158593          	addi	a1,a1,1
     a8c:	00178793          	addi	a5,a5,1
     a90:	fe5ff06f          	j	a74 <strncpy+0x8>

00000a94 <strcmp>:
     a94:	00158593          	addi	a1,a1,1
     a98:	00054703          	lbu	a4,0(a0)
     a9c:	fff5c783          	lbu	a5,-1(a1)
     aa0:	40f707b3          	sub	a5,a4,a5
     aa4:	01879793          	slli	a5,a5,0x18
     aa8:	4187d793          	srai	a5,a5,0x18
     aac:	00079663          	bnez	a5,ab8 <strcmp+0x24>
     ab0:	00150513          	addi	a0,a0,1
     ab4:	fe0710e3          	bnez	a4,a94 <strcmp>
     ab8:	00078513          	mv	a0,a5
     abc:	00008067          	ret

00000ac0 <strncmp>:
     ac0:	00000713          	li	a4,0
     ac4:	00c71863          	bne	a4,a2,ad4 <strncmp+0x14>
     ac8:	00000793          	li	a5,0
     acc:	00078513          	mv	a0,a5
     ad0:	00008067          	ret
     ad4:	00e507b3          	add	a5,a0,a4
     ad8:	0007c683          	lbu	a3,0(a5)
     adc:	00e587b3          	add	a5,a1,a4
     ae0:	0007c783          	lbu	a5,0(a5)
     ae4:	40f687b3          	sub	a5,a3,a5
     ae8:	01879793          	slli	a5,a5,0x18
     aec:	4187d793          	srai	a5,a5,0x18
     af0:	fc079ee3          	bnez	a5,acc <strncmp+0xc>
     af4:	fc068ce3          	beqz	a3,acc <strncmp+0xc>
     af8:	00170713          	addi	a4,a4,1
     afc:	fc9ff06f          	j	ac4 <strncmp+0x4>

00000b00 <strcat>:
     b00:	00050793          	mv	a5,a0
     b04:	0007c703          	lbu	a4,0(a5)
     b08:	00178693          	addi	a3,a5,1
     b0c:	00071e63          	bnez	a4,b28 <strcat+0x28>
     b10:	00158593          	addi	a1,a1,1
     b14:	fff5c703          	lbu	a4,-1(a1)
     b18:	00178793          	addi	a5,a5,1
     b1c:	fee78fa3          	sb	a4,-1(a5)
     b20:	fe0718e3          	bnez	a4,b10 <strcat+0x10>
     b24:	00008067          	ret
     b28:	00068793          	mv	a5,a3
     b2c:	fd9ff06f          	j	b04 <strcat+0x4>

00000b30 <strncat>:
     b30:	00050793          	mv	a5,a0
     b34:	00061663          	bnez	a2,b40 <strncat+0x10>
     b38:	00008067          	ret
     b3c:	00068793          	mv	a5,a3
     b40:	0007c703          	lbu	a4,0(a5)
     b44:	00178693          	addi	a3,a5,1
     b48:	fe071ae3          	bnez	a4,b3c <strncat+0xc>
     b4c:	00c78633          	add	a2,a5,a2
     b50:	00158593          	addi	a1,a1,1
     b54:	fff5c703          	lbu	a4,-1(a1)
     b58:	00178793          	addi	a5,a5,1
     b5c:	fee78fa3          	sb	a4,-1(a5)
     b60:	fc070ce3          	beqz	a4,b38 <strncat+0x8>
     b64:	fec796e3          	bne	a5,a2,b50 <strncat+0x20>
     b68:	00078023          	sb	zero,0(a5)
     b6c:	00008067          	ret

00000b70 <strlen>:
     b70:	00050793          	mv	a5,a0
     b74:	0007c703          	lbu	a4,0(a5)
     b78:	00071663          	bnez	a4,b84 <strlen+0x14>
     b7c:	40a78533          	sub	a0,a5,a0
     b80:	00008067          	ret
     b84:	00178793          	addi	a5,a5,1
     b88:	fedff06f          	j	b74 <strlen+0x4>

00000b8c <strrchr>:
     b8c:	fe010113          	addi	sp,sp,-32
     b90:	00812c23          	sw	s0,24(sp)
     b94:	00b12623          	sw	a1,12(sp)
     b98:	00050413          	mv	s0,a0
     b9c:	00112e23          	sw	ra,28(sp)
     ba0:	fd1ff0ef          	jal	ra,b70 <strlen>
     ba4:	00c12583          	lw	a1,12(sp)
     ba8:	00a40533          	add	a0,s0,a0
     bac:	0ff5f593          	andi	a1,a1,255
     bb0:	00054783          	lbu	a5,0(a0)
     bb4:	00b78863          	beq	a5,a1,bc4 <strrchr+0x38>
     bb8:	fff50513          	addi	a0,a0,-1
     bbc:	fe857ae3          	bleu	s0,a0,bb0 <strrchr+0x24>
     bc0:	00000513          	li	a0,0
     bc4:	01c12083          	lw	ra,28(sp)
     bc8:	01812403          	lw	s0,24(sp)
     bcc:	02010113          	addi	sp,sp,32
     bd0:	00008067          	ret

00000bd4 <strnlen>:
     bd4:	00b505b3          	add	a1,a0,a1
     bd8:	00050793          	mv	a5,a0
     bdc:	00b78663          	beq	a5,a1,be8 <strnlen+0x14>
     be0:	0007c703          	lbu	a4,0(a5)
     be4:	00071663          	bnez	a4,bf0 <strnlen+0x1c>
     be8:	40a78533          	sub	a0,a5,a0
     bec:	00008067          	ret
     bf0:	00178793          	addi	a5,a5,1
     bf4:	fe9ff06f          	j	bdc <strnlen+0x8>

00000bf8 <strspn>:
     bf8:	00000793          	li	a5,0
     bfc:	00f50733          	add	a4,a0,a5
     c00:	00074683          	lbu	a3,0(a4)
     c04:	00068e63          	beqz	a3,c20 <strspn+0x28>
     c08:	00058713          	mv	a4,a1
     c0c:	00c0006f          	j	c18 <strspn+0x20>
     c10:	00d60c63          	beq	a2,a3,c28 <strspn+0x30>
     c14:	00170713          	addi	a4,a4,1
     c18:	00074603          	lbu	a2,0(a4)
     c1c:	fe061ae3          	bnez	a2,c10 <strspn+0x18>
     c20:	00078513          	mv	a0,a5
     c24:	00008067          	ret
     c28:	00178793          	addi	a5,a5,1
     c2c:	fd1ff06f          	j	bfc <strspn+0x4>

00000c30 <memcmp>:
     c30:	00000713          	li	a4,0
     c34:	00e61663          	bne	a2,a4,c40 <memcmp+0x10>
     c38:	00000793          	li	a5,0
     c3c:	0200006f          	j	c5c <memcmp+0x2c>
     c40:	00e507b3          	add	a5,a0,a4
     c44:	00e586b3          	add	a3,a1,a4
     c48:	0007c783          	lbu	a5,0(a5)
     c4c:	0006c683          	lbu	a3,0(a3)
     c50:	00170713          	addi	a4,a4,1
     c54:	40d787b3          	sub	a5,a5,a3
     c58:	fc078ee3          	beqz	a5,c34 <memcmp+0x4>
     c5c:	00078513          	mv	a0,a5
     c60:	00008067          	ret

00000c64 <memset>:
     c64:	00c50633          	add	a2,a0,a2
     c68:	00050793          	mv	a5,a0
     c6c:	00c79463          	bne	a5,a2,c74 <memset+0x10>
     c70:	00008067          	ret
     c74:	00178793          	addi	a5,a5,1
     c78:	feb78fa3          	sb	a1,-1(a5)
     c7c:	ff1ff06f          	j	c6c <memset+0x8>

00000c80 <memcpy>:
     c80:	00000793          	li	a5,0
     c84:	00f61463          	bne	a2,a5,c8c <memcpy+0xc>
     c88:	00008067          	ret
     c8c:	00f58733          	add	a4,a1,a5
     c90:	00074683          	lbu	a3,0(a4)
     c94:	00f50733          	add	a4,a0,a5
     c98:	00178793          	addi	a5,a5,1
     c9c:	00d70023          	sb	a3,0(a4)
     ca0:	fe5ff06f          	j	c84 <memcpy+0x4>

00000ca4 <memmove>:
     ca4:	02a5fa63          	bleu	a0,a1,cd8 <memmove+0x34>
     ca8:	fff64693          	not	a3,a2
     cac:	00000793          	li	a5,0
     cb0:	fff78793          	addi	a5,a5,-1
     cb4:	02f69663          	bne	a3,a5,ce0 <memmove+0x3c>
     cb8:	00008067          	ret
     cbc:	00f58733          	add	a4,a1,a5
     cc0:	00074683          	lbu	a3,0(a4)
     cc4:	00f50733          	add	a4,a0,a5
     cc8:	00178793          	addi	a5,a5,1
     ccc:	00d70023          	sb	a3,0(a4)
     cd0:	fef616e3          	bne	a2,a5,cbc <memmove+0x18>
     cd4:	00008067          	ret
     cd8:	00000793          	li	a5,0
     cdc:	ff5ff06f          	j	cd0 <memmove+0x2c>
     ce0:	00f60733          	add	a4,a2,a5
     ce4:	00e58833          	add	a6,a1,a4
     ce8:	00084803          	lbu	a6,0(a6)
     cec:	00e50733          	add	a4,a0,a4
     cf0:	01070023          	sb	a6,0(a4)
     cf4:	fbdff06f          	j	cb0 <memmove+0xc>

00000cf8 <strstr>:
     cf8:	fe010113          	addi	sp,sp,-32
     cfc:	00812c23          	sw	s0,24(sp)
     d00:	00050413          	mv	s0,a0
     d04:	00058513          	mv	a0,a1
     d08:	01312623          	sw	s3,12(sp)
     d0c:	00112e23          	sw	ra,28(sp)
     d10:	00912a23          	sw	s1,20(sp)
     d14:	01212823          	sw	s2,16(sp)
     d18:	01412423          	sw	s4,8(sp)
     d1c:	00058993          	mv	s3,a1
     d20:	e51ff0ef          	jal	ra,b70 <strlen>
     d24:	04050063          	beqz	a0,d64 <strstr+0x6c>
     d28:	00050913          	mv	s2,a0
     d2c:	00040513          	mv	a0,s0
     d30:	e41ff0ef          	jal	ra,b70 <strlen>
     d34:	00050493          	mv	s1,a0
     d38:	00a40a33          	add	s4,s0,a0
     d3c:	409a0433          	sub	s0,s4,s1
     d40:	0124f663          	bleu	s2,s1,d4c <strstr+0x54>
     d44:	00000413          	li	s0,0
     d48:	01c0006f          	j	d64 <strstr+0x6c>
     d4c:	00090613          	mv	a2,s2
     d50:	00098593          	mv	a1,s3
     d54:	00040513          	mv	a0,s0
     d58:	fff48493          	addi	s1,s1,-1
     d5c:	ed5ff0ef          	jal	ra,c30 <memcmp>
     d60:	fc051ee3          	bnez	a0,d3c <strstr+0x44>
     d64:	00040513          	mv	a0,s0
     d68:	01c12083          	lw	ra,28(sp)
     d6c:	01812403          	lw	s0,24(sp)
     d70:	01412483          	lw	s1,20(sp)
     d74:	01012903          	lw	s2,16(sp)
     d78:	00c12983          	lw	s3,12(sp)
     d7c:	00812a03          	lw	s4,8(sp)
     d80:	02010113          	addi	sp,sp,32
     d84:	00008067          	ret

00000d88 <memchr>:
     d88:	00c50633          	add	a2,a0,a2
     d8c:	0ff5f593          	andi	a1,a1,255
     d90:	00c51663          	bne	a0,a2,d9c <memchr+0x14>
     d94:	00000513          	li	a0,0
     d98:	00008067          	ret
     d9c:	00054703          	lbu	a4,0(a0)
     da0:	00150793          	addi	a5,a0,1
     da4:	feb70ae3          	beq	a4,a1,d98 <memchr+0x10>
     da8:	00078513          	mv	a0,a5
     dac:	fe5ff06f          	j	d90 <memchr+0x8>

00000db0 <strtoul>:
     db0:	000026b7          	lui	a3,0x2
     db4:	00050793          	mv	a5,a0
     db8:	00054703          	lbu	a4,0(a0)
     dbc:	d0468693          	addi	a3,a3,-764 # 1d04 <_ctype>
     dc0:	04061e63          	bnez	a2,e1c <strtoul+0x6c>
     dc4:	03000513          	li	a0,48
     dc8:	00a00613          	li	a2,10
     dcc:	04a71463          	bne	a4,a0,e14 <strtoul+0x64>
     dd0:	0017c703          	lbu	a4,1(a5)
     dd4:	00178513          	addi	a0,a5,1
     dd8:	00e68633          	add	a2,a3,a4
     ddc:	00064603          	lbu	a2,0(a2)
     de0:	00267613          	andi	a2,a2,2
     de4:	00060663          	beqz	a2,df0 <strtoul+0x40>
     de8:	fe070713          	addi	a4,a4,-32
     dec:	0ff77713          	andi	a4,a4,255
     df0:	05800613          	li	a2,88
     df4:	0ac71063          	bne	a4,a2,e94 <strtoul+0xe4>
     df8:	0027c703          	lbu	a4,2(a5)
     dfc:	00e68733          	add	a4,a3,a4
     e00:	00074703          	lbu	a4,0(a4)
     e04:	04477713          	andi	a4,a4,68
     e08:	08070663          	beqz	a4,e94 <strtoul+0xe4>
     e0c:	00278793          	addi	a5,a5,2
     e10:	01000613          	li	a2,16
     e14:	00000513          	li	a0,0
     e18:	04c0006f          	j	e64 <strtoul+0xb4>
     e1c:	01000513          	li	a0,16
     e20:	fea61ae3          	bne	a2,a0,e14 <strtoul+0x64>
     e24:	03000513          	li	a0,48
     e28:	fea716e3          	bne	a4,a0,e14 <strtoul+0x64>
     e2c:	0017c703          	lbu	a4,1(a5)
     e30:	00e68533          	add	a0,a3,a4
     e34:	00054503          	lbu	a0,0(a0)
     e38:	00257513          	andi	a0,a0,2
     e3c:	00050663          	beqz	a0,e48 <strtoul+0x98>
     e40:	fe070713          	addi	a4,a4,-32
     e44:	0ff77713          	andi	a4,a4,255
     e48:	05800513          	li	a0,88
     e4c:	fca714e3          	bne	a4,a0,e14 <strtoul+0x64>
     e50:	00278793          	addi	a5,a5,2
     e54:	fc1ff06f          	j	e14 <strtoul+0x64>
     e58:	02a60533          	mul	a0,a2,a0
     e5c:	00178793          	addi	a5,a5,1
     e60:	00e50533          	add	a0,a0,a4
     e64:	0007c703          	lbu	a4,0(a5)
     e68:	00e68833          	add	a6,a3,a4
     e6c:	00084803          	lbu	a6,0(a6)
     e70:	04487893          	andi	a7,a6,68
     e74:	00088a63          	beqz	a7,e88 <strtoul+0xd8>
     e78:	00487893          	andi	a7,a6,4
     e7c:	02088263          	beqz	a7,ea0 <strtoul+0xf0>
     e80:	fd070713          	addi	a4,a4,-48
     e84:	fcc76ae3          	bltu	a4,a2,e58 <strtoul+0xa8>
     e88:	00058463          	beqz	a1,e90 <strtoul+0xe0>
     e8c:	00f5a023          	sw	a5,0(a1)
     e90:	00008067          	ret
     e94:	00050793          	mv	a5,a0
     e98:	00800613          	li	a2,8
     e9c:	f79ff06f          	j	e14 <strtoul+0x64>
     ea0:	00287813          	andi	a6,a6,2
     ea4:	00080663          	beqz	a6,eb0 <strtoul+0x100>
     ea8:	fe070713          	addi	a4,a4,-32
     eac:	0ff77713          	andi	a4,a4,255
     eb0:	fc970713          	addi	a4,a4,-55
     eb4:	fd1ff06f          	j	e84 <strtoul+0xd4>

00000eb8 <strtol>:
     eb8:	00054683          	lbu	a3,0(a0)
     ebc:	02d00713          	li	a4,45
     ec0:	00e68463          	beq	a3,a4,ec8 <strtol+0x10>
     ec4:	eedff06f          	j	db0 <strtoul>
     ec8:	ff010113          	addi	sp,sp,-16
     ecc:	00150513          	addi	a0,a0,1
     ed0:	00112623          	sw	ra,12(sp)
     ed4:	eddff0ef          	jal	ra,db0 <strtoul>
     ed8:	00c12083          	lw	ra,12(sp)
     edc:	40a00533          	neg	a0,a0
     ee0:	01010113          	addi	sp,sp,16
     ee4:	00008067          	ret

00000ee8 <skip_atoi>:
     ee8:	000026b7          	lui	a3,0x2
     eec:	00000793          	li	a5,0
     ef0:	d0468693          	addi	a3,a3,-764 # 1d04 <_ctype>
     ef4:	00a00593          	li	a1,10
     ef8:	00052603          	lw	a2,0(a0)
     efc:	00064703          	lbu	a4,0(a2)
     f00:	00e68733          	add	a4,a3,a4
     f04:	00074703          	lbu	a4,0(a4)
     f08:	00477713          	andi	a4,a4,4
     f0c:	00071663          	bnez	a4,f18 <skip_atoi+0x30>
     f10:	00078513          	mv	a0,a5
     f14:	00008067          	ret
     f18:	02b787b3          	mul	a5,a5,a1
     f1c:	00160713          	addi	a4,a2,1
     f20:	00e52023          	sw	a4,0(a0)
     f24:	00064703          	lbu	a4,0(a2)
     f28:	00e787b3          	add	a5,a5,a4
     f2c:	fd078793          	addi	a5,a5,-48
     f30:	fc9ff06f          	j	ef8 <skip_atoi+0x10>

00000f34 <number>:
     f34:	000028b7          	lui	a7,0x2
     f38:	d0488893          	addi	a7,a7,-764 # 1d04 <_ctype>
     f3c:	04087313          	andi	t1,a6,64
     f40:	12888e13          	addi	t3,a7,296
     f44:	00030463          	beqz	t1,f4c <number+0x18>
     f48:	10088e13          	addi	t3,a7,256
     f4c:	01087893          	andi	a7,a6,16
     f50:	00088463          	beqz	a7,f58 <number+0x24>
     f54:	ffe87813          	andi	a6,a6,-2
     f58:	ffe68313          	addi	t1,a3,-2
     f5c:	02200e93          	li	t4,34
     f60:	00000893          	li	a7,0
     f64:	246ee263          	bltu	t4,t1,11a8 <number+0x274>
     f68:	00187893          	andi	a7,a6,1
     f6c:	fb010113          	addi	sp,sp,-80
     f70:	03000f93          	li	t6,48
     f74:	00089463          	bnez	a7,f7c <number+0x48>
     f78:	02000f93          	li	t6,32
     f7c:	00287893          	andi	a7,a6,2
     f80:	00000313          	li	t1,0
     f84:	00088a63          	beqz	a7,f98 <number+0x64>
     f88:	08065663          	bgez	a2,1014 <number+0xe0>
     f8c:	40c00633          	neg	a2,a2
     f90:	fff70713          	addi	a4,a4,-1
     f94:	02d00313          	li	t1,45
     f98:	02087293          	andi	t0,a6,32
     f9c:	00028863          	beqz	t0,fac <number+0x78>
     fa0:	01000893          	li	a7,16
     fa4:	09169c63          	bne	a3,a7,103c <number+0x108>
     fa8:	ffe70713          	addi	a4,a4,-2
     fac:	0a061063          	bnez	a2,104c <number+0x118>
     fb0:	03000613          	li	a2,48
     fb4:	00c10623          	sb	a2,12(sp)
     fb8:	00100893          	li	a7,1
     fbc:	00088613          	mv	a2,a7
     fc0:	00f8d463          	ble	a5,a7,fc8 <number+0x94>
     fc4:	00078613          	mv	a2,a5
     fc8:	01187793          	andi	a5,a6,17
     fcc:	40c70733          	sub	a4,a4,a2
     fd0:	0c078e63          	beqz	a5,10ac <number+0x178>
     fd4:	00030863          	beqz	t1,fe4 <number+0xb0>
     fd8:	00b57463          	bleu	a1,a0,fe0 <number+0xac>
     fdc:	00650023          	sb	t1,0(a0)
     fe0:	00150513          	addi	a0,a0,1
     fe4:	00028e63          	beqz	t0,1000 <number+0xcc>
     fe8:	00800793          	li	a5,8
     fec:	0cf69863          	bne	a3,a5,10bc <number+0x188>
     ff0:	00b57663          	bleu	a1,a0,ffc <number+0xc8>
     ff4:	03000793          	li	a5,48
     ff8:	00f50023          	sb	a5,0(a0)
     ffc:	00150513          	addi	a0,a0,1
    1000:	01087813          	andi	a6,a6,16
    1004:	10080a63          	beqz	a6,1118 <number+0x1e4>
    1008:	00c50633          	add	a2,a0,a2
    100c:	03000693          	li	a3,48
    1010:	1200006f          	j	1130 <number+0x1fc>
    1014:	00487893          	andi	a7,a6,4
    1018:	00088863          	beqz	a7,1028 <number+0xf4>
    101c:	fff70713          	addi	a4,a4,-1
    1020:	02b00313          	li	t1,43
    1024:	f75ff06f          	j	f98 <number+0x64>
    1028:	00887893          	andi	a7,a6,8
    102c:	f60886e3          	beqz	a7,f98 <number+0x64>
    1030:	fff70713          	addi	a4,a4,-1
    1034:	02000313          	li	t1,32
    1038:	f61ff06f          	j	f98 <number+0x64>
    103c:	00800893          	li	a7,8
    1040:	f71696e3          	bne	a3,a7,fac <number+0x78>
    1044:	fff70713          	addi	a4,a4,-1
    1048:	f65ff06f          	j	fac <number+0x78>
    104c:	00c10e93          	addi	t4,sp,12
    1050:	00000893          	li	a7,0
    1054:	02d67f33          	remu	t5,a2,a3
    1058:	00188893          	addi	a7,a7,1
    105c:	001e8e93          	addi	t4,t4,1
    1060:	01ee0f33          	add	t5,t3,t5
    1064:	000f4f03          	lbu	t5,0(t5)
    1068:	ffee8fa3          	sb	t5,-1(t4)
    106c:	02d65f33          	divu	t5,a2,a3
    1070:	f4d666e3          	bltu	a2,a3,fbc <number+0x88>
    1074:	000f0613          	mv	a2,t5
    1078:	fddff06f          	j	1054 <number+0x120>
    107c:	00b7f463          	bleu	a1,a5,1084 <number+0x150>
    1080:	00778023          	sb	t2,0(a5)
    1084:	00178793          	addi	a5,a5,1
    1088:	40ff0eb3          	sub	t4,t5,a5
    108c:	ffd048e3          	bgtz	t4,107c <number+0x148>
    1090:	00070793          	mv	a5,a4
    1094:	00075463          	bgez	a4,109c <number+0x168>
    1098:	00000793          	li	a5,0
    109c:	fff70713          	addi	a4,a4,-1
    10a0:	00f50533          	add	a0,a0,a5
    10a4:	40f70733          	sub	a4,a4,a5
    10a8:	f2dff06f          	j	fd4 <number+0xa0>
    10ac:	00050793          	mv	a5,a0
    10b0:	00e50f33          	add	t5,a0,a4
    10b4:	02000393          	li	t2,32
    10b8:	fd1ff06f          	j	1088 <number+0x154>
    10bc:	01000793          	li	a5,16
    10c0:	f4f690e3          	bne	a3,a5,1000 <number+0xcc>
    10c4:	00b57663          	bleu	a1,a0,10d0 <number+0x19c>
    10c8:	03000793          	li	a5,48
    10cc:	00f50023          	sb	a5,0(a0)
    10d0:	00150793          	addi	a5,a0,1
    10d4:	00b7f663          	bleu	a1,a5,10e0 <number+0x1ac>
    10d8:	021e4783          	lbu	a5,33(t3)
    10dc:	00f500a3          	sb	a5,1(a0)
    10e0:	00250513          	addi	a0,a0,2
    10e4:	f1dff06f          	j	1000 <number+0xcc>
    10e8:	00b7f463          	bleu	a1,a5,10f0 <number+0x1bc>
    10ec:	01f78023          	sb	t6,0(a5)
    10f0:	00178793          	addi	a5,a5,1
    10f4:	40f806b3          	sub	a3,a6,a5
    10f8:	fed048e3          	bgtz	a3,10e8 <number+0x1b4>
    10fc:	00070793          	mv	a5,a4
    1100:	00075463          	bgez	a4,1108 <number+0x1d4>
    1104:	00000793          	li	a5,0
    1108:	fff70713          	addi	a4,a4,-1
    110c:	00f50533          	add	a0,a0,a5
    1110:	40f70733          	sub	a4,a4,a5
    1114:	ef5ff06f          	j	1008 <number+0xd4>
    1118:	00050793          	mv	a5,a0
    111c:	00e50833          	add	a6,a0,a4
    1120:	fd5ff06f          	j	10f4 <number+0x1c0>
    1124:	00b57463          	bleu	a1,a0,112c <number+0x1f8>
    1128:	00d50023          	sb	a3,0(a0)
    112c:	00150513          	addi	a0,a0,1
    1130:	40a607b3          	sub	a5,a2,a0
    1134:	fef8c8e3          	blt	a7,a5,1124 <number+0x1f0>
    1138:	00088793          	mv	a5,a7
    113c:	00050693          	mv	a3,a0
    1140:	fff00613          	li	a2,-1
    1144:	fff78793          	addi	a5,a5,-1
    1148:	02c79a63          	bne	a5,a2,117c <number+0x248>
    114c:	01150533          	add	a0,a0,a7
    1150:	00050793          	mv	a5,a0
    1154:	00e50633          	add	a2,a0,a4
    1158:	02000813          	li	a6,32
    115c:	40f606b3          	sub	a3,a2,a5
    1160:	02d04c63          	bgtz	a3,1198 <number+0x264>
    1164:	00075463          	bgez	a4,116c <number+0x238>
    1168:	00000713          	li	a4,0
    116c:	00e508b3          	add	a7,a0,a4
    1170:	00088513          	mv	a0,a7
    1174:	05010113          	addi	sp,sp,80
    1178:	00008067          	ret
    117c:	00b6fa63          	bleu	a1,a3,1190 <number+0x25c>
    1180:	00c10813          	addi	a6,sp,12
    1184:	00f80833          	add	a6,a6,a5
    1188:	00084803          	lbu	a6,0(a6)
    118c:	01068023          	sb	a6,0(a3)
    1190:	00168693          	addi	a3,a3,1
    1194:	fb1ff06f          	j	1144 <number+0x210>
    1198:	00b7f463          	bleu	a1,a5,11a0 <number+0x26c>
    119c:	01078023          	sb	a6,0(a5)
    11a0:	00178793          	addi	a5,a5,1
    11a4:	fb9ff06f          	j	115c <number+0x228>
    11a8:	00088513          	mv	a0,a7
    11ac:	00008067          	ret

000011b0 <vscnprintf>:
    11b0:	ff010113          	addi	sp,sp,-16
    11b4:	00812423          	sw	s0,8(sp)
    11b8:	00112623          	sw	ra,12(sp)
    11bc:	00058413          	mv	s0,a1
    11c0:	5dc000ef          	jal	ra,179c <vsnprintf>
    11c4:	00856463          	bltu	a0,s0,11cc <vscnprintf+0x1c>
    11c8:	fff40513          	addi	a0,s0,-1
    11cc:	00c12083          	lw	ra,12(sp)
    11d0:	00812403          	lw	s0,8(sp)
    11d4:	01010113          	addi	sp,sp,16
    11d8:	00008067          	ret

000011dc <snprintf>:
    11dc:	fc010113          	addi	sp,sp,-64
    11e0:	02d12623          	sw	a3,44(sp)
    11e4:	02c10693          	addi	a3,sp,44
    11e8:	00112e23          	sw	ra,28(sp)
    11ec:	02e12823          	sw	a4,48(sp)
    11f0:	02f12a23          	sw	a5,52(sp)
    11f4:	03012c23          	sw	a6,56(sp)
    11f8:	03112e23          	sw	a7,60(sp)
    11fc:	00d12623          	sw	a3,12(sp)
    1200:	59c000ef          	jal	ra,179c <vsnprintf>
    1204:	01c12083          	lw	ra,28(sp)
    1208:	04010113          	addi	sp,sp,64
    120c:	00008067          	ret

00001210 <scnprintf>:
    1210:	fc010113          	addi	sp,sp,-64
    1214:	02d12623          	sw	a3,44(sp)
    1218:	02c10693          	addi	a3,sp,44
    121c:	00812c23          	sw	s0,24(sp)
    1220:	00112e23          	sw	ra,28(sp)
    1224:	00058413          	mv	s0,a1
    1228:	02e12823          	sw	a4,48(sp)
    122c:	02f12a23          	sw	a5,52(sp)
    1230:	03012c23          	sw	a6,56(sp)
    1234:	03112e23          	sw	a7,60(sp)
    1238:	00d12623          	sw	a3,12(sp)
    123c:	560000ef          	jal	ra,179c <vsnprintf>
    1240:	00856463          	bltu	a0,s0,1248 <scnprintf+0x38>
    1244:	fff40513          	addi	a0,s0,-1
    1248:	01c12083          	lw	ra,28(sp)
    124c:	01812403          	lw	s0,24(sp)
    1250:	04010113          	addi	sp,sp,64
    1254:	00008067          	ret

00001258 <vsprintf>:
    1258:	00060693          	mv	a3,a2
    125c:	00058613          	mv	a2,a1
    1260:	800005b7          	lui	a1,0x80000
    1264:	fff5c593          	not	a1,a1
    1268:	5340006f          	j	179c <vsnprintf>

0000126c <sprintf>:
    126c:	fc010113          	addi	sp,sp,-64
    1270:	02c12423          	sw	a2,40(sp)
    1274:	00058613          	mv	a2,a1
    1278:	800005b7          	lui	a1,0x80000
    127c:	02d12623          	sw	a3,44(sp)
    1280:	fff5c593          	not	a1,a1
    1284:	02810693          	addi	a3,sp,40
    1288:	00112e23          	sw	ra,28(sp)
    128c:	02e12823          	sw	a4,48(sp)
    1290:	02f12a23          	sw	a5,52(sp)
    1294:	03012c23          	sw	a6,56(sp)
    1298:	03112e23          	sw	a7,60(sp)
    129c:	00d12623          	sw	a3,12(sp)
    12a0:	4fc000ef          	jal	ra,179c <vsnprintf>
    12a4:	01c12083          	lw	ra,28(sp)
    12a8:	04010113          	addi	sp,sp,64
    12ac:	00008067          	ret

000012b0 <rand>:
    12b0:	10000737          	lui	a4,0x10000
    12b4:	00072783          	lw	a5,0(a4) # 10000000 <_fbss>
    12b8:	08100513          	li	a0,129
    12bc:	02f50533          	mul	a0,a0,a5
    12c0:	361967b7          	lui	a5,0x36196
    12c4:	2e978793          	addi	a5,a5,745 # 361962e9 <_fstack+0x2618e2f1>
    12c8:	00f50533          	add	a0,a0,a5
    12cc:	00a72023          	sw	a0,0(a4)
    12d0:	00008067          	ret

000012d4 <srand>:
    12d4:	100007b7          	lui	a5,0x10000
    12d8:	00a7a023          	sw	a0,0(a5) # 10000000 <_fbss>
    12dc:	00008067          	ret

000012e0 <abort>:
    12e0:	00002537          	lui	a0,0x2
    12e4:	ff010113          	addi	sp,sp,-16
    12e8:	e5450513          	addi	a0,a0,-428 # 1e54 <small_digits.1430+0x28>
    12ec:	00112623          	sw	ra,12(sp)
    12f0:	254000ef          	jal	ra,1544 <printf>
    12f4:	0000006f          	j	12f4 <abort+0x14>

000012f8 <htonl>:
    12f8:	01851713          	slli	a4,a0,0x18
    12fc:	01855793          	srli	a5,a0,0x18
    1300:	000106b7          	lui	a3,0x10
    1304:	00e7e7b3          	or	a5,a5,a4
    1308:	f0068693          	addi	a3,a3,-256 # ff00 <_erodata+0xe098>
    130c:	00855713          	srli	a4,a0,0x8
    1310:	00d77733          	and	a4,a4,a3
    1314:	00e7e7b3          	or	a5,a5,a4
    1318:	00851513          	slli	a0,a0,0x8
    131c:	00ff0737          	lui	a4,0xff0
    1320:	00e57533          	and	a0,a0,a4
    1324:	00a7e533          	or	a0,a5,a0
    1328:	00008067          	ret

0000132c <htons>:
    132c:	00851793          	slli	a5,a0,0x8
    1330:	00855513          	srli	a0,a0,0x8
    1334:	00a7e533          	or	a0,a5,a0
    1338:	01051513          	slli	a0,a0,0x10
    133c:	01055513          	srli	a0,a0,0x10
    1340:	00008067          	ret

00001344 <ntohl>:
    1344:	01851713          	slli	a4,a0,0x18
    1348:	01855793          	srli	a5,a0,0x18
    134c:	000106b7          	lui	a3,0x10
    1350:	00e7e7b3          	or	a5,a5,a4
    1354:	f0068693          	addi	a3,a3,-256 # ff00 <_erodata+0xe098>
    1358:	00855713          	srli	a4,a0,0x8
    135c:	00d77733          	and	a4,a4,a3
    1360:	00e7e7b3          	or	a5,a5,a4
    1364:	00851513          	slli	a0,a0,0x8
    1368:	00ff0737          	lui	a4,0xff0
    136c:	00e57533          	and	a0,a0,a4
    1370:	00a7e533          	or	a0,a5,a0
    1374:	00008067          	ret

00001378 <ntohs>:
    1378:	00851793          	slli	a5,a0,0x8
    137c:	00855513          	srli	a0,a0,0x8
    1380:	00a7e533          	or	a0,a5,a0
    1384:	01051513          	slli	a0,a0,0x10
    1388:	01055513          	srli	a0,a0,0x10
    138c:	00008067          	ret

00001390 <console_set_write_hook>:
    1390:	100007b7          	lui	a5,0x10000
    1394:	00a7a623          	sw	a0,12(a5) # 1000000c <write_hook>
    1398:	00008067          	ret

0000139c <console_set_read_hook>:
    139c:	100007b7          	lui	a5,0x10000
    13a0:	00a7a423          	sw	a0,8(a5) # 10000008 <read_hook>
    13a4:	100007b7          	lui	a5,0x10000
    13a8:	00b7a223          	sw	a1,4(a5) # 10000004 <read_nonblock_hook>
    13ac:	00008067          	ret

000013b0 <putchar>:
    13b0:	ff010113          	addi	sp,sp,-16
    13b4:	00912223          	sw	s1,4(sp)
    13b8:	0ff57493          	andi	s1,a0,255
    13bc:	00812423          	sw	s0,8(sp)
    13c0:	00050413          	mv	s0,a0
    13c4:	00048513          	mv	a0,s1
    13c8:	00112623          	sw	ra,12(sp)
    13cc:	2f4000ef          	jal	ra,16c0 <uart_write>
    13d0:	100007b7          	lui	a5,0x10000
    13d4:	00c7a783          	lw	a5,12(a5) # 1000000c <write_hook>
    13d8:	00078663          	beqz	a5,13e4 <putchar+0x34>
    13dc:	00048513          	mv	a0,s1
    13e0:	000780e7          	jalr	a5
    13e4:	00040513          	mv	a0,s0
    13e8:	00c12083          	lw	ra,12(sp)
    13ec:	00812403          	lw	s0,8(sp)
    13f0:	00412483          	lw	s1,4(sp)
    13f4:	01010113          	addi	sp,sp,16
    13f8:	00008067          	ret

000013fc <readchar>:
    13fc:	ff010113          	addi	sp,sp,-16
    1400:	00812423          	sw	s0,8(sp)
    1404:	00112623          	sw	ra,12(sp)
    1408:	10000437          	lui	s0,0x10000
    140c:	298000ef          	jal	ra,16a4 <uart_read_nonblock>
    1410:	00050a63          	beqz	a0,1424 <readchar+0x28>
    1414:	00812403          	lw	s0,8(sp)
    1418:	00c12083          	lw	ra,12(sp)
    141c:	01010113          	addi	sp,sp,16
    1420:	2300006f          	j	1650 <uart_read>
    1424:	00442783          	lw	a5,4(s0) # 10000004 <read_nonblock_hook>
    1428:	fe0782e3          	beqz	a5,140c <readchar+0x10>
    142c:	000780e7          	jalr	a5
    1430:	fc050ee3          	beqz	a0,140c <readchar+0x10>
    1434:	00812403          	lw	s0,8(sp)
    1438:	100007b7          	lui	a5,0x10000
    143c:	00c12083          	lw	ra,12(sp)
    1440:	0087a303          	lw	t1,8(a5) # 10000008 <read_hook>
    1444:	01010113          	addi	sp,sp,16
    1448:	00030067          	jr	t1

0000144c <readchar_nonblock>:
    144c:	ff010113          	addi	sp,sp,-16
    1450:	00112623          	sw	ra,12(sp)
    1454:	250000ef          	jal	ra,16a4 <uart_read_nonblock>
    1458:	02051263          	bnez	a0,147c <readchar_nonblock+0x30>
    145c:	100007b7          	lui	a5,0x10000
    1460:	0047a783          	lw	a5,4(a5) # 10000004 <read_nonblock_hook>
    1464:	00078663          	beqz	a5,1470 <readchar_nonblock+0x24>
    1468:	000780e7          	jalr	a5
    146c:	00a03533          	snez	a0,a0
    1470:	00c12083          	lw	ra,12(sp)
    1474:	01010113          	addi	sp,sp,16
    1478:	00008067          	ret
    147c:	00100513          	li	a0,1
    1480:	ff1ff06f          	j	1470 <readchar_nonblock+0x24>

00001484 <puts>:
    1484:	ff010113          	addi	sp,sp,-16
    1488:	00812423          	sw	s0,8(sp)
    148c:	00112623          	sw	ra,12(sp)
    1490:	00050413          	mv	s0,a0
    1494:	00044503          	lbu	a0,0(s0)
    1498:	02051063          	bnez	a0,14b8 <puts+0x34>
    149c:	00a00513          	li	a0,10
    14a0:	f11ff0ef          	jal	ra,13b0 <putchar>
    14a4:	00c12083          	lw	ra,12(sp)
    14a8:	00812403          	lw	s0,8(sp)
    14ac:	00100513          	li	a0,1
    14b0:	01010113          	addi	sp,sp,16
    14b4:	00008067          	ret
    14b8:	ef9ff0ef          	jal	ra,13b0 <putchar>
    14bc:	00140413          	addi	s0,s0,1
    14c0:	fd5ff06f          	j	1494 <puts+0x10>

000014c4 <putsnonl>:
    14c4:	ff010113          	addi	sp,sp,-16
    14c8:	00812423          	sw	s0,8(sp)
    14cc:	00112623          	sw	ra,12(sp)
    14d0:	00050413          	mv	s0,a0
    14d4:	00044503          	lbu	a0,0(s0)
    14d8:	00051a63          	bnez	a0,14ec <putsnonl+0x28>
    14dc:	00c12083          	lw	ra,12(sp)
    14e0:	00812403          	lw	s0,8(sp)
    14e4:	01010113          	addi	sp,sp,16
    14e8:	00008067          	ret
    14ec:	ec5ff0ef          	jal	ra,13b0 <putchar>
    14f0:	00140413          	addi	s0,s0,1
    14f4:	fe1ff06f          	j	14d4 <putsnonl+0x10>

000014f8 <vprintf>:
    14f8:	ef010113          	addi	sp,sp,-272
    14fc:	00058693          	mv	a3,a1
    1500:	00050613          	mv	a2,a0
    1504:	10000593          	li	a1,256
    1508:	00010513          	mv	a0,sp
    150c:	10112623          	sw	ra,268(sp)
    1510:	10812423          	sw	s0,264(sp)
    1514:	c9dff0ef          	jal	ra,11b0 <vscnprintf>
    1518:	10010793          	addi	a5,sp,256
    151c:	00050413          	mv	s0,a0
    1520:	00a787b3          	add	a5,a5,a0
    1524:	00010513          	mv	a0,sp
    1528:	f0078023          	sb	zero,-256(a5)
    152c:	f99ff0ef          	jal	ra,14c4 <putsnonl>
    1530:	00040513          	mv	a0,s0
    1534:	10c12083          	lw	ra,268(sp)
    1538:	10812403          	lw	s0,264(sp)
    153c:	11010113          	addi	sp,sp,272
    1540:	00008067          	ret

00001544 <printf>:
    1544:	fc010113          	addi	sp,sp,-64
    1548:	02b12223          	sw	a1,36(sp)
    154c:	02410593          	addi	a1,sp,36
    1550:	00112e23          	sw	ra,28(sp)
    1554:	02c12423          	sw	a2,40(sp)
    1558:	02d12623          	sw	a3,44(sp)
    155c:	02e12823          	sw	a4,48(sp)
    1560:	02f12a23          	sw	a5,52(sp)
    1564:	03012c23          	sw	a6,56(sp)
    1568:	03112e23          	sw	a7,60(sp)
    156c:	00b12623          	sw	a1,12(sp)
    1570:	f89ff0ef          	jal	ra,14f8 <vprintf>
    1574:	01c12083          	lw	ra,28(sp)
    1578:	04010113          	addi	sp,sp,64
    157c:	00008067          	ret

00001580 <uart_isr>:
    1580:	f00027b7          	lui	a5,0xf0002
    1584:	0107a703          	lw	a4,16(a5) # f0002010 <_fstack+0xdfffa018>
    1588:	00277793          	andi	a5,a4,2
    158c:	02078463          	beqz	a5,15b4 <uart_isr+0x34>
    1590:	100005b7          	lui	a1,0x10000
    1594:	f00026b7          	lui	a3,0xf0002
    1598:	10000637          	lui	a2,0x10000
    159c:	10000837          	lui	a6,0x10000
    15a0:	02058593          	addi	a1,a1,32 # 10000020 <rx_buf>
    15a4:	00200893          	li	a7,2
    15a8:	0086a783          	lw	a5,8(a3) # f0002008 <_fstack+0xdfffa010>
    15ac:	0ff7f793          	andi	a5,a5,255
    15b0:	00078863          	beqz	a5,15c0 <uart_isr+0x40>
    15b4:	00177713          	andi	a4,a4,1
    15b8:	02071c63          	bnez	a4,15f0 <uart_isr+0x70>
    15bc:	00008067          	ret
    15c0:	01c62783          	lw	a5,28(a2) # 1000001c <rx_produce>
    15c4:	01882503          	lw	a0,24(a6) # 10000018 <rx_consume>
    15c8:	00178793          	addi	a5,a5,1
    15cc:	07f7f793          	andi	a5,a5,127
    15d0:	00f50c63          	beq	a0,a5,15e8 <uart_isr+0x68>
    15d4:	01c62503          	lw	a0,28(a2)
    15d8:	0006a303          	lw	t1,0(a3)
    15dc:	00f62e23          	sw	a5,28(a2)
    15e0:	00a58533          	add	a0,a1,a0
    15e4:	00650023          	sb	t1,0(a0)
    15e8:	0116a823          	sw	a7,16(a3)
    15ec:	fbdff06f          	j	15a8 <uart_isr+0x28>
    15f0:	00100713          	li	a4,1
    15f4:	f00027b7          	lui	a5,0xf0002
    15f8:	100006b7          	lui	a3,0x10000
    15fc:	00e7a823          	sw	a4,16(a5) # f0002010 <_fstack+0xdfffa018>
    1600:	100005b7          	lui	a1,0x10000
    1604:	10000737          	lui	a4,0x10000
    1608:	f0002637          	lui	a2,0xf0002
    160c:	02068693          	addi	a3,a3,32 # 10000020 <rx_buf>
    1610:	01072503          	lw	a0,16(a4) # 10000010 <tx_consume>
    1614:	0145a783          	lw	a5,20(a1) # 10000014 <tx_produce>
    1618:	00f50863          	beq	a0,a5,1628 <uart_isr+0xa8>
    161c:	00462783          	lw	a5,4(a2) # f0002004 <_fstack+0xdfffa00c>
    1620:	0ff7f793          	andi	a5,a5,255
    1624:	00078463          	beqz	a5,162c <uart_isr+0xac>
    1628:	00008067          	ret
    162c:	01072783          	lw	a5,16(a4)
    1630:	00f687b3          	add	a5,a3,a5
    1634:	0807c783          	lbu	a5,128(a5)
    1638:	00f62023          	sw	a5,0(a2)
    163c:	01072783          	lw	a5,16(a4)
    1640:	00178793          	addi	a5,a5,1
    1644:	07f7f793          	andi	a5,a5,127
    1648:	00f72823          	sw	a5,16(a4)
    164c:	fc5ff06f          	j	1610 <uart_isr+0x90>

00001650 <uart_read>:
    1650:	30002673          	csrr	a2,mstatus
    1654:	10000737          	lui	a4,0x10000
    1658:	00867613          	andi	a2,a2,8
    165c:	01872783          	lw	a5,24(a4) # 10000018 <rx_consume>
    1660:	00070693          	mv	a3,a4
    1664:	10000737          	lui	a4,0x10000
    1668:	02060663          	beqz	a2,1694 <uart_read+0x44>
    166c:	01c72603          	lw	a2,28(a4) # 1000001c <rx_produce>
    1670:	fef60ee3          	beq	a2,a5,166c <uart_read+0x1c>
    1674:	10000737          	lui	a4,0x10000
    1678:	02070713          	addi	a4,a4,32 # 10000020 <rx_buf>
    167c:	00f70733          	add	a4,a4,a5
    1680:	00178793          	addi	a5,a5,1
    1684:	07f7f793          	andi	a5,a5,127
    1688:	00074503          	lbu	a0,0(a4)
    168c:	00f6ac23          	sw	a5,24(a3)
    1690:	0100006f          	j	16a0 <uart_read+0x50>
    1694:	01c72703          	lw	a4,28(a4)
    1698:	00000513          	li	a0,0
    169c:	fcf71ce3          	bne	a4,a5,1674 <uart_read+0x24>
    16a0:	00008067          	ret

000016a4 <uart_read_nonblock>:
    16a4:	10000737          	lui	a4,0x10000
    16a8:	100007b7          	lui	a5,0x10000
    16ac:	01c7a783          	lw	a5,28(a5) # 1000001c <rx_produce>
    16b0:	01872503          	lw	a0,24(a4) # 10000018 <rx_consume>
    16b4:	40f50533          	sub	a0,a0,a5
    16b8:	00a03533          	snez	a0,a0
    16bc:	00008067          	ret

000016c0 <uart_write>:
    16c0:	100006b7          	lui	a3,0x10000
    16c4:	0146a603          	lw	a2,20(a3) # 10000014 <tx_produce>
    16c8:	00160793          	addi	a5,a2,1
    16cc:	07f7f793          	andi	a5,a5,127
    16d0:	300025f3          	csrr	a1,mstatus
    16d4:	0085f593          	andi	a1,a1,8
    16d8:	10000737          	lui	a4,0x10000
    16dc:	04058663          	beqz	a1,1728 <uart_write+0x68>
    16e0:	01072583          	lw	a1,16(a4) # 10000010 <tx_consume>
    16e4:	fef58ee3          	beq	a1,a5,16e0 <uart_write+0x20>
    16e8:	bc0025f3          	csrr	a1,0xbc0
    16ec:	ffd5f813          	andi	a6,a1,-3
    16f0:	bc081073          	csrw	0xbc0,a6
    16f4:	01072703          	lw	a4,16(a4)
    16f8:	00e61a63          	bne	a2,a4,170c <uart_write+0x4c>
    16fc:	f0002837          	lui	a6,0xf0002
    1700:	00482703          	lw	a4,4(a6) # f0002004 <_fstack+0xdfffa00c>
    1704:	0ff77713          	andi	a4,a4,255
    1708:	02070663          	beqz	a4,1734 <uart_write+0x74>
    170c:	10000737          	lui	a4,0x10000
    1710:	02070713          	addi	a4,a4,32 # 10000020 <rx_buf>
    1714:	00c70733          	add	a4,a4,a2
    1718:	08a70023          	sb	a0,128(a4)
    171c:	00f6aa23          	sw	a5,20(a3)
    1720:	bc059073          	csrw	0xbc0,a1
    1724:	00c0006f          	j	1730 <uart_write+0x70>
    1728:	01072583          	lw	a1,16(a4)
    172c:	faf59ee3          	bne	a1,a5,16e8 <uart_write+0x28>
    1730:	00008067          	ret
    1734:	00a82023          	sw	a0,0(a6)
    1738:	fe9ff06f          	j	1720 <uart_write+0x60>

0000173c <uart_init>:
    173c:	100007b7          	lui	a5,0x10000
    1740:	0007ae23          	sw	zero,28(a5) # 1000001c <rx_produce>
    1744:	100007b7          	lui	a5,0x10000
    1748:	0007ac23          	sw	zero,24(a5) # 10000018 <rx_consume>
    174c:	100007b7          	lui	a5,0x10000
    1750:	0007aa23          	sw	zero,20(a5) # 10000014 <tx_produce>
    1754:	100007b7          	lui	a5,0x10000
    1758:	0007a823          	sw	zero,16(a5) # 10000010 <tx_consume>
    175c:	f00027b7          	lui	a5,0xf0002
    1760:	0107a703          	lw	a4,16(a5) # f0002010 <_fstack+0xdfffa018>
    1764:	0ff77713          	andi	a4,a4,255
    1768:	00e7a823          	sw	a4,16(a5)
    176c:	00300713          	li	a4,3
    1770:	00e7aa23          	sw	a4,20(a5)
    1774:	bc0027f3          	csrr	a5,0xbc0
    1778:	0027e793          	ori	a5,a5,2
    177c:	bc079073          	csrw	0xbc0,a5
    1780:	00008067          	ret

00001784 <uart_sync>:
    1784:	100007b7          	lui	a5,0x10000
    1788:	0147a783          	lw	a5,20(a5) # 10000014 <tx_produce>
    178c:	100006b7          	lui	a3,0x10000
    1790:	0106a703          	lw	a4,16(a3) # 10000010 <tx_consume>
    1794:	fef71ee3          	bne	a4,a5,1790 <uart_sync+0xc>
    1798:	00008067          	ret

0000179c <vsnprintf>:
    179c:	fc010113          	addi	sp,sp,-64
    17a0:	02112e23          	sw	ra,60(sp)
    17a4:	02812c23          	sw	s0,56(sp)
    17a8:	02912a23          	sw	s1,52(sp)
    17ac:	03212823          	sw	s2,48(sp)
    17b0:	03312623          	sw	s3,44(sp)
    17b4:	03412423          	sw	s4,40(sp)
    17b8:	03512223          	sw	s5,36(sp)
    17bc:	03612023          	sw	s6,32(sp)
    17c0:	01712e23          	sw	s7,28(sp)
    17c4:	01812c23          	sw	s8,24(sp)
    17c8:	01912a23          	sw	s9,20(sp)
    17cc:	01a12823          	sw	s10,16(sp)
    17d0:	00c12623          	sw	a2,12(sp)
    17d4:	4c05c463          	bltz	a1,1c9c <vsnprintf+0x500>
    17d8:	00b509b3          	add	s3,a0,a1
    17dc:	00050a13          	mv	s4,a0
    17e0:	00058a93          	mv	s5,a1
    17e4:	00068493          	mv	s1,a3
    17e8:	00a9f663          	bleu	a0,s3,17f4 <vsnprintf+0x58>
    17ec:	fff54a93          	not	s5,a0
    17f0:	fff00993          	li	s3,-1
    17f4:	00002b37          	lui	s6,0x2
    17f8:	00002cb7          	lui	s9,0x2
    17fc:	000a0413          	mv	s0,s4
    1800:	02500c13          	li	s8,37
    1804:	d04b0b13          	addi	s6,s6,-764 # 1d04 <_ctype>
    1808:	02000b93          	li	s7,32
    180c:	e60c8c93          	addi	s9,s9,-416 # 1e60 <small_digits.1430+0x34>
    1810:	2bc0006f          	j	1acc <vsnprintf+0x330>
    1814:	01878a63          	beq	a5,s8,1828 <vsnprintf+0x8c>
    1818:	01347463          	bleu	s3,s0,1820 <vsnprintf+0x84>
    181c:	00f40023          	sb	a5,0(s0)
    1820:	00140413          	addi	s0,s0,1
    1824:	29c0006f          	j	1ac0 <vsnprintf+0x324>
    1828:	00000913          	li	s2,0
    182c:	02b00713          	li	a4,43
    1830:	02d00613          	li	a2,45
    1834:	03000593          	li	a1,48
    1838:	02000513          	li	a0,32
    183c:	02300813          	li	a6,35
    1840:	00c12683          	lw	a3,12(sp)
    1844:	00168793          	addi	a5,a3,1
    1848:	00f12623          	sw	a5,12(sp)
    184c:	0016c783          	lbu	a5,1(a3)
    1850:	14e78063          	beq	a5,a4,1990 <vsnprintf+0x1f4>
    1854:	12f76263          	bltu	a4,a5,1978 <vsnprintf+0x1dc>
    1858:	14a78063          	beq	a5,a0,1998 <vsnprintf+0x1fc>
    185c:	15078263          	beq	a5,a6,19a0 <vsnprintf+0x204>
    1860:	01678733          	add	a4,a5,s6
    1864:	00074703          	lbu	a4,0(a4)
    1868:	00477713          	andi	a4,a4,4
    186c:	12070e63          	beqz	a4,19a8 <vsnprintf+0x20c>
    1870:	00c10513          	addi	a0,sp,12
    1874:	e74ff0ef          	jal	ra,ee8 <skip_atoi>
    1878:	00050713          	mv	a4,a0
    187c:	00c12683          	lw	a3,12(sp)
    1880:	02e00613          	li	a2,46
    1884:	fff00793          	li	a5,-1
    1888:	0006c583          	lbu	a1,0(a3)
    188c:	02c59e63          	bne	a1,a2,18c8 <vsnprintf+0x12c>
    1890:	00168793          	addi	a5,a3,1
    1894:	00f12623          	sw	a5,12(sp)
    1898:	0016c603          	lbu	a2,1(a3)
    189c:	00cb07b3          	add	a5,s6,a2
    18a0:	0007c783          	lbu	a5,0(a5)
    18a4:	0047f793          	andi	a5,a5,4
    18a8:	12078663          	beqz	a5,19d4 <vsnprintf+0x238>
    18ac:	00c10513          	addi	a0,sp,12
    18b0:	00e12423          	sw	a4,8(sp)
    18b4:	e34ff0ef          	jal	ra,ee8 <skip_atoi>
    18b8:	00812703          	lw	a4,8(sp)
    18bc:	00050793          	mv	a5,a0
    18c0:	00055463          	bgez	a0,18c8 <vsnprintf+0x12c>
    18c4:	00000793          	li	a5,0
    18c8:	00c12683          	lw	a3,12(sp)
    18cc:	06800593          	li	a1,104
    18d0:	0006c603          	lbu	a2,0(a3)
    18d4:	02b60263          	beq	a2,a1,18f8 <vsnprintf+0x15c>
    18d8:	0df67593          	andi	a1,a2,223
    18dc:	04c00513          	li	a0,76
    18e0:	00a58c63          	beq	a1,a0,18f8 <vsnprintf+0x15c>
    18e4:	05a00513          	li	a0,90
    18e8:	00a58863          	beq	a1,a0,18f8 <vsnprintf+0x15c>
    18ec:	07400593          	li	a1,116
    18f0:	fff00813          	li	a6,-1
    18f4:	02b61663          	bne	a2,a1,1920 <vsnprintf+0x184>
    18f8:	00060813          	mv	a6,a2
    18fc:	00168613          	addi	a2,a3,1
    1900:	00c12623          	sw	a2,12(sp)
    1904:	06c00613          	li	a2,108
    1908:	00c81c63          	bne	a6,a2,1920 <vsnprintf+0x184>
    190c:	0016c603          	lbu	a2,1(a3)
    1910:	01061863          	bne	a2,a6,1920 <vsnprintf+0x184>
    1914:	00268693          	addi	a3,a3,2
    1918:	00d12623          	sw	a3,12(sp)
    191c:	04c00813          	li	a6,76
    1920:	00c12683          	lw	a3,12(sp)
    1924:	0006c603          	lbu	a2,0(a3)
    1928:	06e00693          	li	a3,110
    192c:	2cd60c63          	beq	a2,a3,1c04 <vsnprintf+0x468>
    1930:	0ec6e063          	bltu	a3,a2,1a10 <vsnprintf+0x274>
    1934:	06300693          	li	a3,99
    1938:	14d60c63          	beq	a2,a3,1a90 <vsnprintf+0x2f4>
    193c:	0ac6ec63          	bltu	a3,a2,19f4 <vsnprintf+0x258>
    1940:	2d860c63          	beq	a2,s8,1c18 <vsnprintf+0x47c>
    1944:	05800693          	li	a3,88
    1948:	2cd60e63          	beq	a2,a3,1c24 <vsnprintf+0x488>
    194c:	01347663          	bleu	s3,s0,1958 <vsnprintf+0x1bc>
    1950:	02500793          	li	a5,37
    1954:	00f40023          	sb	a5,0(s0)
    1958:	00c12783          	lw	a5,12(sp)
    195c:	00140713          	addi	a4,s0,1
    1960:	0007c683          	lbu	a3,0(a5)
    1964:	2c068663          	beqz	a3,1c30 <vsnprintf+0x494>
    1968:	01377463          	bleu	s3,a4,1970 <vsnprintf+0x1d4>
    196c:	00d400a3          	sb	a3,1(s0)
    1970:	00240413          	addi	s0,s0,2
    1974:	14c0006f          	j	1ac0 <vsnprintf+0x324>
    1978:	00c78863          	beq	a5,a2,1988 <vsnprintf+0x1ec>
    197c:	eeb792e3          	bne	a5,a1,1860 <vsnprintf+0xc4>
    1980:	00196913          	ori	s2,s2,1
    1984:	ebdff06f          	j	1840 <vsnprintf+0xa4>
    1988:	01096913          	ori	s2,s2,16
    198c:	eb5ff06f          	j	1840 <vsnprintf+0xa4>
    1990:	00496913          	ori	s2,s2,4
    1994:	eadff06f          	j	1840 <vsnprintf+0xa4>
    1998:	00896913          	ori	s2,s2,8
    199c:	ea5ff06f          	j	1840 <vsnprintf+0xa4>
    19a0:	02096913          	ori	s2,s2,32
    19a4:	e9dff06f          	j	1840 <vsnprintf+0xa4>
    19a8:	02a00613          	li	a2,42
    19ac:	fff00713          	li	a4,-1
    19b0:	ecc796e3          	bne	a5,a2,187c <vsnprintf+0xe0>
    19b4:	0004a703          	lw	a4,0(s1)
    19b8:	00268693          	addi	a3,a3,2
    19bc:	00d12623          	sw	a3,12(sp)
    19c0:	00448493          	addi	s1,s1,4
    19c4:	ea075ce3          	bgez	a4,187c <vsnprintf+0xe0>
    19c8:	40e00733          	neg	a4,a4
    19cc:	01096913          	ori	s2,s2,16
    19d0:	eadff06f          	j	187c <vsnprintf+0xe0>
    19d4:	02a00593          	li	a1,42
    19d8:	00000793          	li	a5,0
    19dc:	eeb616e3          	bne	a2,a1,18c8 <vsnprintf+0x12c>
    19e0:	00268693          	addi	a3,a3,2
    19e4:	0004a503          	lw	a0,0(s1)
    19e8:	00d12623          	sw	a3,12(sp)
    19ec:	00448493          	addi	s1,s1,4
    19f0:	ecdff06f          	j	18bc <vsnprintf+0x120>
    19f4:	06400693          	li	a3,100
    19f8:	00d60663          	beq	a2,a3,1a04 <vsnprintf+0x268>
    19fc:	06900693          	li	a3,105
    1a00:	f4d616e3          	bne	a2,a3,194c <vsnprintf+0x1b0>
    1a04:	00296913          	ori	s2,s2,2
    1a08:	00a00693          	li	a3,10
    1a0c:	0680006f          	j	1a74 <vsnprintf+0x2d8>
    1a10:	07300693          	li	a3,115
    1a14:	14d60863          	beq	a2,a3,1b64 <vsnprintf+0x3c8>
    1a18:	04c6e463          	bltu	a3,a2,1a60 <vsnprintf+0x2c4>
    1a1c:	06f00693          	li	a3,111
    1a20:	22d60063          	beq	a2,a3,1c40 <vsnprintf+0x4a4>
    1a24:	07000693          	li	a3,112
    1a28:	f2d612e3          	bne	a2,a3,194c <vsnprintf+0x1b0>
    1a2c:	fff00693          	li	a3,-1
    1a30:	00d71663          	bne	a4,a3,1a3c <vsnprintf+0x2a0>
    1a34:	00196913          	ori	s2,s2,1
    1a38:	00800713          	li	a4,8
    1a3c:	0004a603          	lw	a2,0(s1)
    1a40:	00448d13          	addi	s10,s1,4
    1a44:	00090813          	mv	a6,s2
    1a48:	01000693          	li	a3,16
    1a4c:	00040513          	mv	a0,s0
    1a50:	00098593          	mv	a1,s3
    1a54:	ce0ff0ef          	jal	ra,f34 <number>
    1a58:	00050413          	mv	s0,a0
    1a5c:	1640006f          	j	1bc0 <vsnprintf+0x424>
    1a60:	07500693          	li	a3,117
    1a64:	fad602e3          	beq	a2,a3,1a08 <vsnprintf+0x26c>
    1a68:	07800593          	li	a1,120
    1a6c:	01000693          	li	a3,16
    1a70:	ecb61ee3          	bne	a2,a1,194c <vsnprintf+0x1b0>
    1a74:	04c00613          	li	a2,76
    1a78:	1cc81863          	bne	a6,a2,1c48 <vsnprintf+0x4ac>
    1a7c:	00748493          	addi	s1,s1,7
    1a80:	ff84f493          	andi	s1,s1,-8
    1a84:	00848d13          	addi	s10,s1,8
    1a88:	0004a603          	lw	a2,0(s1)
    1a8c:	1f80006f          	j	1c84 <vsnprintf+0x4e8>
    1a90:	01097913          	andi	s2,s2,16
    1a94:	0a090c63          	beqz	s2,1b4c <vsnprintf+0x3b0>
    1a98:	00040793          	mv	a5,s0
    1a9c:	00448693          	addi	a3,s1,4
    1aa0:	01347663          	bleu	s3,s0,1aac <vsnprintf+0x310>
    1aa4:	0004a603          	lw	a2,0(s1)
    1aa8:	00c40023          	sb	a2,0(s0)
    1aac:	00140413          	addi	s0,s0,1
    1ab0:	00e78733          	add	a4,a5,a4
    1ab4:	408707b3          	sub	a5,a4,s0
    1ab8:	08f04e63          	bgtz	a5,1b54 <vsnprintf+0x3b8>
    1abc:	00068493          	mv	s1,a3
    1ac0:	00c12783          	lw	a5,12(sp)
    1ac4:	00178793          	addi	a5,a5,1
    1ac8:	00f12623          	sw	a5,12(sp)
    1acc:	00c12783          	lw	a5,12(sp)
    1ad0:	0007c783          	lbu	a5,0(a5)
    1ad4:	d40790e3          	bnez	a5,1814 <vsnprintf+0x78>
    1ad8:	000a8663          	beqz	s5,1ae4 <vsnprintf+0x348>
    1adc:	1b347c63          	bleu	s3,s0,1c94 <vsnprintf+0x4f8>
    1ae0:	00040023          	sb	zero,0(s0)
    1ae4:	41440533          	sub	a0,s0,s4
    1ae8:	03c12083          	lw	ra,60(sp)
    1aec:	03812403          	lw	s0,56(sp)
    1af0:	03412483          	lw	s1,52(sp)
    1af4:	03012903          	lw	s2,48(sp)
    1af8:	02c12983          	lw	s3,44(sp)
    1afc:	02812a03          	lw	s4,40(sp)
    1b00:	02412a83          	lw	s5,36(sp)
    1b04:	02012b03          	lw	s6,32(sp)
    1b08:	01c12b83          	lw	s7,28(sp)
    1b0c:	01812c03          	lw	s8,24(sp)
    1b10:	01412c83          	lw	s9,20(sp)
    1b14:	01012d03          	lw	s10,16(sp)
    1b18:	04010113          	addi	sp,sp,64
    1b1c:	00008067          	ret
    1b20:	01347463          	bleu	s3,s0,1b28 <vsnprintf+0x38c>
    1b24:	01740023          	sb	s7,0(s0)
    1b28:	00140413          	addi	s0,s0,1
    1b2c:	fff78793          	addi	a5,a5,-1
    1b30:	fef048e3          	bgtz	a5,1b20 <vsnprintf+0x384>
    1b34:	fff70793          	addi	a5,a4,-1
    1b38:	00e04463          	bgtz	a4,1b40 <vsnprintf+0x3a4>
    1b3c:	00100713          	li	a4,1
    1b40:	40e78733          	sub	a4,a5,a4
    1b44:	00170713          	addi	a4,a4,1
    1b48:	f51ff06f          	j	1a98 <vsnprintf+0x2fc>
    1b4c:	00070793          	mv	a5,a4
    1b50:	fddff06f          	j	1b2c <vsnprintf+0x390>
    1b54:	01347463          	bleu	s3,s0,1b5c <vsnprintf+0x3c0>
    1b58:	01740023          	sb	s7,0(s0)
    1b5c:	00140413          	addi	s0,s0,1
    1b60:	f55ff06f          	j	1ab4 <vsnprintf+0x318>
    1b64:	00448d13          	addi	s10,s1,4
    1b68:	0004a483          	lw	s1,0(s1)
    1b6c:	00049463          	bnez	s1,1b74 <vsnprintf+0x3d8>
    1b70:	000c8493          	mv	s1,s9
    1b74:	00078593          	mv	a1,a5
    1b78:	00048513          	mv	a0,s1
    1b7c:	00e12423          	sw	a4,8(sp)
    1b80:	01097913          	andi	s2,s2,16
    1b84:	850ff0ef          	jal	ra,bd4 <strnlen>
    1b88:	00812703          	lw	a4,8(sp)
    1b8c:	00091863          	bnez	s2,1b9c <vsnprintf+0x400>
    1b90:	00070793          	mv	a5,a4
    1b94:	fff70713          	addi	a4,a4,-1
    1b98:	02f54863          	blt	a0,a5,1bc8 <vsnprintf+0x42c>
    1b9c:	00000793          	li	a5,0
    1ba0:	02a7cc63          	blt	a5,a0,1bd8 <vsnprintf+0x43c>
    1ba4:	00050793          	mv	a5,a0
    1ba8:	00055463          	bgez	a0,1bb0 <vsnprintf+0x414>
    1bac:	00000793          	li	a5,0
    1bb0:	00f40433          	add	s0,s0,a5
    1bb4:	00e40733          	add	a4,s0,a4
    1bb8:	408707b3          	sub	a5,a4,s0
    1bbc:	02f54c63          	blt	a0,a5,1bf4 <vsnprintf+0x458>
    1bc0:	000d0493          	mv	s1,s10
    1bc4:	efdff06f          	j	1ac0 <vsnprintf+0x324>
    1bc8:	01347463          	bleu	s3,s0,1bd0 <vsnprintf+0x434>
    1bcc:	01740023          	sb	s7,0(s0)
    1bd0:	00140413          	addi	s0,s0,1
    1bd4:	fbdff06f          	j	1b90 <vsnprintf+0x3f4>
    1bd8:	00f406b3          	add	a3,s0,a5
    1bdc:	0136f863          	bleu	s3,a3,1bec <vsnprintf+0x450>
    1be0:	00f48633          	add	a2,s1,a5
    1be4:	00064603          	lbu	a2,0(a2)
    1be8:	00c68023          	sb	a2,0(a3)
    1bec:	00178793          	addi	a5,a5,1
    1bf0:	fb1ff06f          	j	1ba0 <vsnprintf+0x404>
    1bf4:	01347463          	bleu	s3,s0,1bfc <vsnprintf+0x460>
    1bf8:	01740023          	sb	s7,0(s0)
    1bfc:	00140413          	addi	s0,s0,1
    1c00:	fb9ff06f          	j	1bb8 <vsnprintf+0x41c>
    1c04:	0004a783          	lw	a5,0(s1)
    1c08:	41440733          	sub	a4,s0,s4
    1c0c:	00448493          	addi	s1,s1,4
    1c10:	00e7a023          	sw	a4,0(a5)
    1c14:	eadff06f          	j	1ac0 <vsnprintf+0x324>
    1c18:	c13474e3          	bleu	s3,s0,1820 <vsnprintf+0x84>
    1c1c:	01840023          	sb	s8,0(s0)
    1c20:	c01ff06f          	j	1820 <vsnprintf+0x84>
    1c24:	04096913          	ori	s2,s2,64
    1c28:	01000693          	li	a3,16
    1c2c:	e49ff06f          	j	1a74 <vsnprintf+0x2d8>
    1c30:	fff78793          	addi	a5,a5,-1
    1c34:	00f12623          	sw	a5,12(sp)
    1c38:	00070413          	mv	s0,a4
    1c3c:	e85ff06f          	j	1ac0 <vsnprintf+0x324>
    1c40:	00800693          	li	a3,8
    1c44:	e31ff06f          	j	1a74 <vsnprintf+0x2d8>
    1c48:	06c00613          	li	a2,108
    1c4c:	00448d13          	addi	s10,s1,4
    1c50:	e2c80ce3          	beq	a6,a2,1a88 <vsnprintf+0x2ec>
    1c54:	fdf87613          	andi	a2,a6,-33
    1c58:	05a00593          	li	a1,90
    1c5c:	e2b606e3          	beq	a2,a1,1a88 <vsnprintf+0x2ec>
    1c60:	07400613          	li	a2,116
    1c64:	e2c802e3          	beq	a6,a2,1a88 <vsnprintf+0x2ec>
    1c68:	06800613          	li	a2,104
    1c6c:	00297593          	andi	a1,s2,2
    1c70:	e0c81ce3          	bne	a6,a2,1a88 <vsnprintf+0x2ec>
    1c74:	0004a603          	lw	a2,0(s1)
    1c78:	01061613          	slli	a2,a2,0x10
    1c7c:	00059863          	bnez	a1,1c8c <vsnprintf+0x4f0>
    1c80:	01065613          	srli	a2,a2,0x10
    1c84:	00090813          	mv	a6,s2
    1c88:	dc5ff06f          	j	1a4c <vsnprintf+0x2b0>
    1c8c:	41065613          	srai	a2,a2,0x10
    1c90:	ff5ff06f          	j	1c84 <vsnprintf+0x4e8>
    1c94:	fe098fa3          	sb	zero,-1(s3)
    1c98:	e4dff06f          	j	1ae4 <vsnprintf+0x348>
    1c9c:	00000513          	li	a0,0
    1ca0:	e49ff06f          	j	1ae8 <vsnprintf+0x34c>
