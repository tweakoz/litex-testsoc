
#include <crc.h>
#include <id.h>
#include <irq.h>
#include <stdio.h>
#include <stdlib.h>
#include <system.h>
#include <uart.h>

#include <generated/csr.h>
#include <generated/mem.h>
#include "static_queue.inl"
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

size_t rounduppow2(size_t inp){
    inp--;
    inp |= inp >> 1;
    inp |= inp >> 2;
    inp |= inp >> 4;
    inp |= inp >> 8;
    inp |= inp >> 16;
    inp++;
    return inp;
}

void* allocate(size_t amount){
    static size_t location = 0xc0010000;
    size_t rval = location;
    location += rounduppow2(amount);
    return (void*) rval;
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
  iterperprint=1;
  #endif

  typedef static_queue<1024,uint32_t> intqueue_t;

  auto _queue = (intqueue_t*) allocate(sizeof(intqueue_t));
  _queue->initialize();

  printf( "queue @ addr<%p>\n", _queue );

  fifotest_out_reset_write(1);
  fifotest_out_reset_write(0);
  fifotest_inp_reset_write(1);
  fifotest_inp_reset_write(0);

  while (true) {
    uint64_t phase = uint64_t(count) & uint64_t(0xffff);
    uint64_t phasi = (phase >= 0x8000) ? uint64_t(0xffff) - phase : phase;

    rgbledA_b_width_write(((phasi >> 11) & 0xf) << 4);
    rgbledA_g_width_write(((phasi >> 11) & 0xf) << 4);

    int x = rand()&0xff;
    int out_ready = fifotest_out_ready_read();
    int out_level = fifotest_out_level_read();
    int inp_avail = fifotest_inp_dataavail_read();
    int inp_level = fifotest_inp_level_read();
    int inp_nfull = fifotest_inp_writable_read();

    printf("        x<%02x> out_ready<%d> out_level<%d> inp_nfull<%d> inp_avail<%d> inp_level<%d>\n",x,out_ready,out_level,inp_nfull,inp_avail,inp_level);

    constexpr int kthresh = 0xc0;

    if ((x<kthresh) and out_ready) {
      uint32_t x = uint32_t(rand() & 0xffff);
      x |= uint32_t(rand() & 0xff) << 16;
      //if(0==(writecount%iterperprint))
        printf("writecount<%d> write <%08x> lev<%d>\n", writecount, x, out_level);
      fifotest_out_datareg_write(x);
      _queue->enqueue(x);
      writecount++;
    }
    else if((x>=kthresh) and inp_avail) {
      uint32_t r = fifotest_inp_datareg_read();
      uint32_t chk = 0;
      while(false==_queue->try_dequeue(chk));
      if(r!=chk)
        printf("   ERROR r<0x%08x> chk<0x%08x>\n", r,chk);
      //if(0==(readcount%iterperprint))
        printf("   readcount<%d> read <%08x> lev<%d>..\n", readcount, r,inp_level);
      fifotest_inp_ack_write(1);
      readcount++;
    }

  }
  return rval;
}
