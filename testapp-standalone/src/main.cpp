
#include <crc.h>
#include <id.h>
#include <irq.h>
#include <stdio.h>
#include <stdlib.h>
#include <system.h>
#include <uart.h>

#include <generated/csr.h>
#include <generated/mem.h>

//#include <unistd.h>

extern "C" {
    void delay(int count){
        for(int i=0;i<count;i++){

        }
    }
}

uint32_t count = 0;

extern "C" void isr(void) {
  unsigned int irqs;

  irqs = irq_pending() & irq_getmask();

  if (irqs & (1 << UART_INTERRUPT)) uart_isr();
  else
    printf("other irq<%08x>\n", irqs);
}

int main(int c, char** argv) {
  int rval = 0;
  irq_setmask(0);
  irq_setie(1);
  uart_init();

  printf("what up yo..\n");
  uart_sync();

  constexpr uint64_t clock_rate = SYSTEM_CLOCK_FREQUENCY;

  rgbledA_b_enable_write(1);
  rgbledA_b_period_write(0xffff);
  rgbledA_g_enable_write(1);
  rgbledA_g_period_write(0xffff);

  int readcount = 0;
  int writecount = 0;

  uint32_t iterperprint = 0x3ffff;
  #if defined(SIM)
  iterperprint=2;
  #endif

  while (true) {
    uint64_t phase = uint64_t(count) & uint64_t(0xffff);
    uint64_t phasi = (phase >= 0x8000) ? uint64_t(0xffff) - phase : phase;

    rgbledA_b_width_write(((phasi >> 11) & 0xf) << 4);
    rgbledA_g_width_write(((phasi >> 11) & 0xf) << 4);

    int x = rand()&0xff;
    //printf("x<%02x>\n",x);
    if ((x<0x81) and fifotest_out_ready_read()) {
      uint32_t x = uint32_t(rand() & 0xffff);
      x |= uint32_t(rand() & 0xff) << 16;
      int out_level = fifotest_out_level_read();
      if(0==(writecount&iterperprint))
        printf("writecount<%d> write <%08x> lev<%d>\n", writecount, x, out_level);
      fifotest_out_datareg_write(x);
      writecount++;
    }
    else if((x>=0x81) and fifotest_inp_dataavail_read()) {
      uint32_t r = fifotest_inp_datareg_read();
      int inp_level = fifotest_inp_level_read();
      if(0==(readcount&iterperprint))
        printf("readcount<%d> read <%08x> lev<%d>..\n", readcount, r,inp_level);
      fifotest_inp_ack_write(1);
      readcount++;
    }

  }
  return rval;
}
