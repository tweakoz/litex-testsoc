#pragma once

#include <stdio.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <assert.h>
#include <math.h>
#include <thread>
#include <zmq.hpp>
#include <ork/ringbuffer.hpp>
#include <ork/svariant.h>
#include <ork/thread.h>
#include <ork/cvector3.hpp>
#include <ork/quaternion.hpp>
#include <ork/timer.h>
#include <set>

extern "C" {
    #include <csr.h>
}

typedef ork::MpMcRingBuf<ork::svar32_t,16> queue_t;

////////////////////////////////////////////////////////////////

inline uint32_t roffset(uint32_t inpaddr){
    return inpaddr-0xf0000000;
}

////////////////////////////////////////////////////////////////

template <typename T> inline volatile T& reg(uint8_t* base,int offset){
  auto tptr = (volatile T*) (base+offset);
  //printf( "reg<%px>\n", base+offset );
  return *tptr;
}

////////////////////////////////////////////////////////////////

inline void csr_write8(uint8_t* baseaddr,uint8_t value){
    reg<uint8_t>(baseaddr,0x00)=value;
}
inline uint8_t csr_read8(uint8_t* baseaddr){
    uint8_t rval = reg<uint8_t>(baseaddr,0x00);
    return rval;
}
inline uint32_t csr_read32(uint8_t* baseaddr){
    uint32_t rvala = reg<uint8_t>(baseaddr,0x00);
    uint32_t rvalb = reg<uint8_t>(baseaddr,0x04);
    uint32_t rvalc = reg<uint8_t>(baseaddr,0x08);
    uint32_t rvald = reg<uint8_t>(baseaddr,0x0c);
    uint32_t rval = rvald|(rvalc<<8)|(rvalb<<16)|(rvala<<24);
    return rval;
}
inline uint64_t csr_read64(uint8_t* baseaddr){
    return reg<uint64_t>(baseaddr,0x00);
}

////////////////////////////////////////////////////////////////

void inline csr_write32(uint8_t* baseaddr,uint32_t value){
    reg<uint8_t>(baseaddr,0x00)=(value>>24)&0xff;
    reg<uint8_t>(baseaddr,0x04)=(value>>16)&0xff;
    reg<uint8_t>(baseaddr,0x08)=(value>>8)&0xff;
    reg<uint8_t>(baseaddr,0x0c)=(value>>0)&0xff;
}

void inline csr_write64(uint8_t* baseaddr,uint64_t value){
    reg<uint8_t>(baseaddr,0x00)=(value>>56)&0xff;
    reg<uint8_t>(baseaddr,0x04)=(value>>48)&0xff;
    reg<uint8_t>(baseaddr,0x08)=(value>>40)&0xff;
    reg<uint8_t>(baseaddr,0x0c)=(value>>32)&0xff;
    reg<uint8_t>(baseaddr,0x10)=(value>>24)&0xff;
    reg<uint8_t>(baseaddr,0x14)=(value>>16)&0xff;
    reg<uint8_t>(baseaddr,0x18)=(value>>8)&0xff;
    reg<uint8_t>(baseaddr,0x1c)=(value>>0)&0xff;
}

////////////////////////////////////////////////////////////////

inline uint8_t* mapregbank(uint32_t physaddr, uint32_t physlen){
  int fd = open("/dev/mem", O_RDWR|O_SYNC);
  size_t pagesize = sysconf(_SC_PAGE_SIZE);
  off_t page_base = (physaddr / pagesize) * pagesize;
  off_t page_offset = physaddr - page_base;
  auto mapped = (uint8_t*) mmap( NULL,
                                 page_offset + physlen,
                                 PROT_READ | PROT_WRITE,
                                 MAP_SHARED,
                                 fd,
                                 page_base);

  printf("pagesize<%zu>\n", pagesize);
  printf("page_base<0x%zx>\n", page_base);
  printf("page_offset<%zu>\n", page_offset);
  printf("mapping addr<%08x> len<%08x> to<%px>\n",physaddr,physlen,mapped);
  close(fd);
  return mapped;
}
