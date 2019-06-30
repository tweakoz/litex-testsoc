#include "common.inl"

using namespace ork;

uint8_t* registers = nullptr;

////////////////////////////////////////////////////////////////

void setled(uint8_t* baseaddr, bool enable, uint32_t period, uint32_t on_width ){
    csr_write32(baseaddr+0x04,on_width);
    csr_write32(baseaddr+0x14,period);
    csr_write8 (baseaddr+0x0,0);
    csr_write8 (baseaddr+0x0,255);
}

////////////////////////////////////////////////////////////////

void setledbri(uint8_t* baseaddr, uint8_t bri ){
    setled(baseaddr,true,1<<12,255-bri);
}

////////////////////////////////////////////////////////////////

struct rgbldriver{

    rgbldriver( uint8_t* addr ) : _baseaddr(addr), _phi(0.0f) {}

    void update(float frq,fvec3 wgt){
        float val = 0.5f+sinf(_phi)*0.5f;

        //printf( "val<%f>\n", val );

        int ir = int(val*255.0f*wgt.x);
        int ig = int(val*255.0f*wgt.y);
        int ib = int(val*255.0f*wgt.z);

        setledbri(_baseaddr+0x00,ir&0xff);
        setledbri(_baseaddr+0x24,ig&0xff);
        setledbri(_baseaddr+0x48,ib&0xff);

        _phi += frq;

    }

    float _phi;
    uint8_t* _baseaddr;

};

////////////////////////////////////////////////////////////////

std::atomic<int> app_lifecycle_state;
std::set<std::thread*> _threads;

////////////////////////////////////////////////////////////////

void onExit()
{
    printf( "cleaning UP!\n");
    app_lifecycle_state.store(1);

    while(_threads.empty()==false){

      auto it = _threads.begin();
      auto thr = * it;

      _threads.erase(it);

      printf( "joining thread<%p>\n", thr );
      thr->join();
      printf( "joined thread<%p>\n", thr );
      delete thr;

    }

    app_lifecycle_state.store(3);

    printf( "cleaning UP! registers<%p>\n", registers);
    if( registers ){
      usleep(1000);

      auto disled = [](uint8_t* addr){
        csr_write32(addr+0x0,0);
        csr_write32(addr+0x24,0);
        csr_write32(addr+0x48,0);
      };
      disled(registers+roffset(CSR_RGBLEDA_BASE));
      disled(registers+roffset(CSR_RGBLEDB_BASE));
      disled(registers+roffset(CSR_RGBLEDC_BASE));
      disled(registers+roffset(CSR_RGBLEDD_BASE));
    }
    usleep(1e6);
    abort();
}
void onSigInt(int x){
  onExit();
}

////////////////////////////////////////////////////////////////

int main( int argc, const char** argv ){

  app_lifecycle_state.store(0);

  auto mem = new uint8_t[1<<20];
  registers = mapregbank(0xf0000000,0x10000); // 64K
  assert(registers);

  const int register_ok = std::atexit(onExit);
  assert(register_ok==0);
  const int register_ok2 = std::at_quick_exit(onExit);
  assert(register_ok2==0);
  signal(SIGINT, onSigInt);

  printf("what up yo mem<%p>\n", mem);
  printf( "cputype<%s>\n", config_cpu_type_read() );
  printf( "registers<%p>\n", registers );

  fvec3 a(0,1,0), b(1,0,0), c;

  c = a.Cross(b);

  printf( "c<%f %f %f>\n", c.x, c.y, c.z );

  rgbldriver leda(registers+roffset(CSR_RGBLEDA_BASE));
  rgbldriver ledb(registers+roffset(CSR_RGBLEDB_BASE));
  rgbldriver ledc(registers+roffset(CSR_RGBLEDC_BASE));
  rgbldriver ledd(registers+roffset(CSR_RGBLEDD_BASE));

  queue_t theq;

  ///////////////////////////////////////////////////
  auto thra = new std::thread([&](){
      svar32_t sv;
      while(0==app_lifecycle_state.load()){
          leda.update(0.1f,fvec3(1,0,0));
          usleep(16000);
          if( theq.try_pop(sv)){
              printf( "thra got one\r");
              fflush(stdout);
          }
      }
      printf( "thra done..\n");
  });
  ///////////////////////////////////////////////////
  auto thrb = new std::thread([&](){
      svar32_t sv;
      while(0==app_lifecycle_state.load()){
          ledb.update(0.13f,fvec3(0,1,0));
          usleep(16000);
          if( theq.try_pop(sv)){
              printf( "thrb got one\r");
              fflush(stdout);
          }
      }
      printf( "thrb done..\n");
  });
  ///////////////////////////////////////////////////
  auto thrc = new std::thread([&](){
      svar32_t sv;
      while(0==app_lifecycle_state.load()){
          ledc.update(0.17f,fvec3(0,0,1));
          usleep(16000);
          if( theq.try_pop(sv)){
              printf( "thrc got one\r");
              fflush(stdout);
          }
      }
      printf( "thrc done..\n");
  });
  ///////////////////////////////////////////////////
  auto thrd = new std::thread([&](){
      svar32_t sv;
      fquat q, r;
      fvec3 nx, ny, nz;
      fvec3 axis;
      ork::Timer t;
      t.Start();
      while(0==app_lifecycle_state.load()){

          if(t.SecsSinceStart()>3.0f){
            int rx = (rand()%255)-127;
            int ry = (rand()%255)-127;
            int rz = (rand()%255)-127;
            int rs = (rand()%255)-127;
            auto axis = fvec3(rx,ry,rz).Normal();
            r.FromAxisAngle(fvec4(axis,float(rs)*0.01));
            t.Start();
          }

          q = q.Multiply(r);
          auto m = q.ToMatrix3();
          m.NormalVectorsOut(nx,ny,nz);

          ledd.update(0.19f,nx*0.5+fvec3(.5,.5,.5));


          usleep(16000);
          if( theq.try_pop(sv)){
              printf( "thrd got one\r");
              fflush(stdout);
          }
      }
      printf( "thrd done..\n");

  });
  ///////////////////////////////////////////////////
  auto thr_fifo_send = new std::thread([&](){

      auto outfifo_data = registers+roffset(CSR_FIFOTEST_OUT_DATAREG_ADDR);
      auto outfifo_ready = registers+roffset(CSR_FIFOTEST_OUT_READY_ADDR);
      auto outfifo_level = registers+roffset(CSR_FIFOTEST_OUT_LEVEL_ADDR);

      uint32_t counter = 0;
      int prev_level = -1;
      while(0==app_lifecycle_state.load()){
            if( csr_read8(outfifo_ready) ){
              csr_write32(outfifo_data,counter++);
            }
            int level = csr_read8(outfifo_level);
            if(level!=prev_level)
                printf( "outfifo-level<%d>\n", level);
            prev_level=level;
            usleep(1<<10);
      }
  });
  ///////////////////////////////////////////////////
  auto thr_fifo_recv = new std::thread([&](){

      auto inpfifo_data = registers+roffset(CSR_FIFOTEST_INP_DATAREG_ADDR);
      auto inpfifo_avail = registers+roffset(CSR_FIFOTEST_INP_DATAAVAIL_ADDR);
      auto inpfifo_level = registers+roffset(CSR_FIFOTEST_INP_LEVEL_ADDR);

      uint32_t counter = 0;

      usleep(4<<20); // let the producer get ahead a bit

      while(0==app_lifecycle_state.load()){
          if( csr_read8(inpfifo_avail) ){
              uint32_t value = csr_read32(inpfifo_data);
          }
          int level = csr_read8(inpfifo_level);
          printf( "inpfifo-level<%d>\n", level);
          usleep(1<<20);
      }
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
  printf( "entering runloop\n");
  while( app_lifecycle_state.load() == 0 ){
    usleep(10e6);
  }
  printf( "exited runloop\n");
///////////////////////////////////////////////////

  delete[] mem;
  usleep(1<<20);

  app_lifecycle_state.store(2);



  return 0;
}
