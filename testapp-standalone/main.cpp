
#include <stdio.h>
#include <stdlib.h>
#include <uart.h>
#include <system.h>
#include <id.h>
#include <irq.h>
#include <crc.h>

#include <generated/csr.h>
#include <generated/mem.h>

extern "C" void isr(void)
{
	unsigned int irqs;

	irqs = irq_pending() & irq_getmask();

	if(irqs & (1 << UART_INTERRUPT))
		uart_isr();

}

int main(int c, char** argv)
{
    int rval = 0;
    irq_setmask(0);
		irq_setie(1);
		uart_init();

    printf("what up yo..\n");
    uart_sync();

    constexpr uint64_t clock_rate = SYSTEM_CLOCK_FREQUENCY;

    uint64_t phi = 0;
    rgbledA_b_enable_write(1);
    rgbledA_b_period_write(0xffff);
    rgbledA_g_enable_write(1);
    rgbledA_g_period_write(0xffff);
    while(true){
        uint64_t phase = uint64_t(phi)&uint64_t(0xffff);
        uint64_t phasi = (phase>=0x8000)
                       ? uint64_t(0xffff)-phase
                       : phase;

        rgbledA_b_width_write(((phasi>>11)&0xf)<<4);
        rgbledA_g_width_write(((phasi>>11)&0xf)<<4);


        int out_level = fifotest_out_level_read();
        printf("out_level<%d>\n", out_level);

        if( fifotest_out_ready_read() ){
						uint32_t x = uint32_t(rand()&0xffff);
						         x |= uint32_t(rand()&0xffff)<<16;
  					printf("writing <%08x>\n",x);
            fifotest_out_datareg_write(x);
        }
				for(int j=1; j<3; j++ ){
        }

				bool did_read = false;
				while(false==did_read){

						int inp_level = fifotest_inp_level_read();
						uint8_t avail = fifotest_inp_dataavail_read();
	        	printf("inp_level<%d>\n", inp_level);
						printf( "avail<%02x>\n", int(avail));
		        if( avail!=0 ) {
		            printf("reading..\n");
		            auto r = fifotest_inp_datareg_read();
								//fifotest_inp_ack_write(0x33);
								did_read = true;
		        }

				}

        for(int j=1; j<10000000; j++ ){
        }
        phi++;
    }
	return rval;
}
