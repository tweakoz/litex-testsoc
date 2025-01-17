#include <generated/csr.h>
#include <irq.h>
#include <uart.h>
#include <stdint.h>
#include <stdio.h>

extern void periodic_isr(void);

void isr(void);

void isr(void)
{
	unsigned int irqs;

	irqs = irq_pending() & irq_getmask();

	if(irqs & (1 << UART_INTERRUPT)){
		uart_isr();
    }

}
