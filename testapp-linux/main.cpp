#include "common.inl"
#include <mutex>

using namespace ork;

regaddr_t registers = nullptr;

////////////////////////////////////////////////////////////////

void setled(regaddr_t baseaddr, bool enable, uint32_t period,
            uint32_t on_width) {
  csr_write32(baseaddr + 0x04, on_width);
  csr_write32(baseaddr + 0x14, period);
  csr_write8(baseaddr + 0x0, 0);
  csr_write8(baseaddr + 0x0, 255);
}

////////////////////////////////////////////////////////////////

void setledbri(regaddr_t baseaddr, float bri) {
  setled(baseaddr, true, 1 << 28, 255.0f*bri);
}

////////////////////////////////////////////////////////////////

struct rgbldriver {
  rgbldriver(regaddr_t addr)
    : _baseaddr(addr)
    , _updtim(1.0f)
    {
        _timer.Start();
    }

  void newsettings(){
      _axis.x = float((rand()&0xffff)-0x8000)/float(0x8000);
      _axis.y = float((rand()&0xffff)-0x8000)/float(0x8000);
      _axis.z = float((rand()&0xffff)-0x8000)/float(0x8000);
      _axis = _axis.Normal();
      _angvel = float((rand()&0xffff)-0x8000)/float(0x8000)/20.0f;
      _qincr.FromAxisAngle(fvec4(_axis,_angvel));
      _updtim = 0.1f+3.0f*float((rand()&0xffff)-0x8000)/float(0x8000);
      _timer.Start();
  }

  void update(float frq, fvec3 wgt) {

    if( _timer.SecsSinceStart()>_updtim){
        newsettings();

    }
    auto m = _qaccum.ToMatrix();
    fvec3 nx,ny,nz;
    m.NormalVectorsOut(nx,ny,nz);

    float fr = float((nx.x+1.0f) * 127.5f*0.1f);
    float fg = float(0.0f);//(nx.y+1.0f) * 127.5f*0.1f);
    float fb = float(0.0f);//(nx.z+1.0f) * 127.5f*0.1f);

    setledbri(_baseaddr + 0x00, fr);
    setledbri(_baseaddr + 0x24, fg);
    setledbri(_baseaddr + 0x48, fb);

    _qaccum = _qaccum.Multiply(_qincr);

  }

  float _updtim;
  regaddr_t _baseaddr;
  ork::Timer _timer;
  fquat _qincr;
  fquat _qaccum;
  fvec3 _axis;
  float _angvel;
};

////////////////////////////////////////////////////////////////

std::atomic<int> app_lifecycle_state;
std::set<std::thread*> _threads;

////////////////////////////////////////////////////////////////

void onExit() {
  printf("cleaning UP!\n");
  app_lifecycle_state.store(1);

  while (_threads.empty() == false) {
    auto it = _threads.begin();
    auto thr = *it;

    _threads.erase(it);

    printf("joining thread<%p>\n", thr);
    thr->join();
    printf("joined thread<%p>\n", thr);
    delete thr;
  }

  app_lifecycle_state.store(3);

  printf("cleaning UP! registers<%p>\n", registers);
  if (registers) {
    usleep(1000);

    auto disled = [](regaddr_t addr) {
      csr_write32(addr + 0x0, 0);
      csr_write32(addr + 0x24, 0);
      csr_write32(addr + 0x48, 0);
    };
    disled(registers + roffset(CSR_RGBLEDA_BASE));
    disled(registers + roffset(CSR_RGBLEDB_BASE));
    disled(registers + roffset(CSR_RGBLEDC_BASE));
    disled(registers + roffset(CSR_RGBLEDD_BASE));
  }
  usleep(1e6);
  abort();
}
void onSigInt(int x) { onExit(); }

////////////////////////////////////////////////////////////////

int main(int argc, const char** argv) {
  app_lifecycle_state.store(0);
  printf("cputype<%s>\n", config_cpu_type_read());

  auto mem = new uint8_t[1 << 20];
  printf("heap alloc addr<%p>\n", mem);

  registers = mapregbank(0xf0000000, 0x10000);  // 64K
  assert(registers);

  const int register_ok = std::atexit(onExit);
  assert(register_ok == 0);
  const int register_ok2 = std::at_quick_exit(onExit);
  assert(register_ok2 == 0);
  signal(SIGINT, onSigInt);

  printf("registers<%p>\n", registers);

  fvec3 a(1, 0, 0), b(0, 1, 0), c;

  c = a.Cross(b);

  printf("a<%f %f %f>\n", a.x, a.y, a.z);
  printf("b<%f %f %f>\n", b.x, b.y, b.z);
  printf("cross(a,b)<%f %f %f>\n", c.x, c.y, c.z);

  rgbldriver leda(registers + roffset(CSR_RGBLEDA_BASE));
  rgbldriver ledb(registers + roffset(CSR_RGBLEDB_BASE));
  rgbldriver ledc(registers + roffset(CSR_RGBLEDC_BASE));
  rgbldriver ledd(registers + roffset(CSR_RGBLEDD_BASE));

  queue_t theq;

  auto _queue = new ork::MpMcRingBuf<uint32_t,65536>();

  ///////////////////////////////////////////////////
  auto thra = new std::thread([&]() {
    svar32_t sv;
    while (0 == app_lifecycle_state.load()) {
      leda.update(0.1f, fvec3(1, 0, 0));
      usleep(16000);
      if (theq.try_pop(sv)) {
        printf("thra got one\r");
        fflush(stdout);
      }
    }
    printf("thra done..\n");
  });
  ///////////////////////////////////////////////////
  auto thrb = new std::thread([&]() {
    svar32_t sv;
    while (0 == app_lifecycle_state.load()) {
      ledb.update(0.13f, fvec3(0, 1, 0));
      usleep(16000);
      if (theq.try_pop(sv)) {
        printf("thrb got one\r");
        fflush(stdout);
      }
    }
    printf("thrb done..\n");
  });
  ///////////////////////////////////////////////////
  auto thrc = new std::thread([&]() {
    svar32_t sv;
    while (0 == app_lifecycle_state.load()) {
      ledc.update(0.17f, fvec3(0, 0, 1));
      usleep(16000);
      if (theq.try_pop(sv)) {
        printf("thrc got one\r");
        fflush(stdout);
      }
    }
    printf("thrc done..\n");
  });
  ///////////////////////////////////////////////////
  auto thrd = new std::thread([&]() {
    svar32_t sv;
    fquat q, r;
    fvec3 nx, ny, nz;
    fvec3 axis;
    ork::Timer t;
    t.Start();
    while (0 == app_lifecycle_state.load()) {
      if (t.SecsSinceStart() > 3.0f) {
        int rx = (rand() % 255) - 127;
        int ry = (rand() % 255) - 127;
        int rz = (rand() % 255) - 127;
        int rs = (rand() % 255) - 127;
        auto axis = fvec3(rx, ry, rz).Normal();
        r.FromAxisAngle(fvec4(axis, float(rs) * 0.01));
        t.Start();
      }

      q = q.Multiply(r);
      auto m = q.ToMatrix3();
      m.NormalVectorsOut(nx, ny, nz);

      ledd.update(0.19f, nx * 0.5 + fvec3(.5, .5, .5));

      usleep(16000);
      if (theq.try_pop(sv)) {
        printf("thrd got one\r");
        fflush(stdout);
      }
    }
    printf("thrd done..\n");
  });
  ///////////////////////////////////////////////////
  constexpr uint32_t itersperprint = 0xffff;
  auto outfifo_reset = registers + roffset(CSR_FIFOTEST_OUT_RESET_ADDR);
  auto inpfifo_reset = registers + roffset(CSR_FIFOTEST_INP_RESET_ADDR);
  csr_write8(outfifo_reset,1);
  csr_write8(outfifo_reset,0);
  csr_write8(inpfifo_reset,1);
  csr_write8(inpfifo_reset,0);
  usleep(1<<20);

  constexpr bool KCHECK = false;

  ///////////////////////////////////////////////////
  auto thr_fifo_send = new std::thread([&]() {
    auto outfifo_data = registers + roffset(CSR_FIFOTEST_OUT_DATAREG_ADDR);
    auto outfifo_ready = registers + roffset(CSR_FIFOTEST_OUT_READY_ADDR);
    auto outfifo_level = registers + roffset(CSR_FIFOTEST_OUT_LEVEL_ADDR);
    auto outfifo_wrcnt = registers + roffset(CSR_FIFOTEST_OUT_WRITECOUNTER_ADDR);

    uint32_t counter = 0;

    printf( "send thread started..\n");

    ork::Timer t;
    t.Start();
    uint32_t read_base = 0;

    uint32_t wrcount = 0;
    while (0 == app_lifecycle_state.load()) {

      while (csr_read8(outfifo_ready)) {
        //uint32_t x  = uint32_t(rand() & 0xffff);
        //         x |= uint32_t(rand() & 0xff) << 16;
        uint32_t x = counter++;

        csr_write32(outfifo_data,x);
        wrcount++;

        if( KCHECK )
          _queue->push(x);

        //uint32_t wrcount = csr_read32(outfifo_wrcnt);
        if(0==(wrcount%itersperprint)){
          int out_level = csr_read8(outfifo_level);
          printf("wrcount<%u> write <%08x> wrlev<%d>\n", wrcount, x, out_level);
        }
      }
      sched_yield();
    }
    printf( "send thread ending..\n");
  });
  auto thr_fifo_recv = new std::thread([&]() {
    auto inpfifo_data = registers + roffset(CSR_FIFOTEST_INP_DATAREG_ADDR);
    auto inpfifo_avail = registers + roffset(CSR_FIFOTEST_INP_DATAAVAIL_ADDR);
    auto inpfifo_level = registers + roffset(CSR_FIFOTEST_INP_LEVEL_ADDR);
    auto inpfifo_ack = registers + roffset(CSR_FIFOTEST_INP_ACK_ADDR);
    auto inpfifo_rdcnt = registers + roffset(CSR_FIFOTEST_INP_READCOUNTER_ADDR);

    int counter = 0;

    printf( "recv thread started..\n");

    ork::Timer t;
    t.Start();
    uint32_t read_base = 0;

    uint32_t rdcount = 0;
    while (0 == app_lifecycle_state.load()) {


      while(csr_read8(inpfifo_avail)) {
        uint32_t r = csr_read32(inpfifo_data);
        csr_write8(inpfifo_ack,1);
        rdcount++;
        if( KCHECK ){
          uint32_t chk = 0;
          while(false==_queue->try_pop(chk));
          if( r!=chk )
            printf( "got<0x%08x> expected<0x%08x>\n", r,chk);
            assert(r==chk);
          }

        //uint32_t rdcount = csr_read32(inpfifo_rdcnt);

        if((rdcount-read_base)>0x100000){
          float persec = float(rdcount-read_base)/t.SecsSinceStart();
          printf( "READRATE<%d reads/sec>\n",int(persec) );
          t.Start();
          read_base = rdcount;
        }

        if(0==(rdcount%itersperprint)){
          int inp_level = csr_read8(inpfifo_level);
          printf("   rdcount<%u> read <%08x> rdlev<%d>..\n", rdcount, r,inp_level);
        }

      }
      sched_yield();
    }
    printf( "recv thread ending..\n");
  });
  ///////////////////////////////////////////////////
  // threads
  ///////////////////////////////////////////////////
  _threads.insert(thra);
  _threads.insert(thrb);
  _threads.insert(thrc);
  _threads.insert(thrd);

  _threads.insert(thr_fifo_send);
  _threads.insert(thr_fifo_recv);
  ///////////////////////////////////////////////////
  // comms(0mq) thread
  ///////////////////////////////////////////////////
  /*std::thread thrz([&]{
    zmq::context_t context (1);
    zmq::socket_t socket (context, ZMQ_REP);
    socket.bind ("tcp://*:5555");

    while (0==app_lifecycle_state) {
        zmq::message_t request;

        //  Wait for next request from client
        int status = socket.recv (&request,ZMQ_NOBLOCK);
        if( 0 == status ){
          //printf("Received Hello\n");

          svar32_t item;
          item.Set<bool>(true);
          theq.push(item);

          //  Do some 'work'
          //sleep(1);

          //  Send reply back to client
          zmq::message_t reply (5);
          memcpy (reply.data (), "World", 5);
          socket.send (reply);
        }
        else
          usleep(1000);
    }
    printf( "thrz done..\n");

  });*/
  ///////////////////////////////////////////////////
  printf("entering runloop\n");
  csr_write8(registers+roffset(CSR_PMODA_IO1_ENABLE_ADDR),1);
  csr_write32(registers+roffset(CSR_PMODA_IO1_PERIOD_ADDR),255);
  float phase = 0.0f;
  ork::Timer t;
  t.Start();
  while (app_lifecycle_state.load() == 0) {
    float phase = t.SecsSinceStart()*2.0*PI;
    float val = 0.5f+sinf(phase*30)*0.5f;
    csr_write32(registers+roffset(CSR_PMODA_IO1_WIDTH_ADDR),int(val*255.0f));
    //usleep(1e4);
  }
  printf("exited runloop\n");
  ///////////////////////////////////////////////////

  delete[] mem;
  usleep(1 << 20);

  app_lifecycle_state.store(2);

  return 0;
}
