
INCPATHA = -I ${LITEX_ROOT}/soc/software/include
INCPATHB = -I ${SOC_BUILD_DIR}/software/include/generated
INCPATHC = -I ${BUILDROOT_DIR}/output/build/linux-headers-5.0.13/include
INCPATHD = -I ${BUILDROOT_DIR}/output/build/linux-headers-5.0.13/arch/riscv/include

ARCHABI = -march=rv32i -mabi=ilp32
CXXFLAGS = ${INCPATHB} ${INCPATHA} ${ARCHABI} ${LIBPATH} -std=c++17 -g -lpthread -lzmq -lrt -latomic -lork.core.IX.release

all:
	riscv32-buildroot-linux-gnu-g++ ${CXXFLAGS} main.cpp -o main.exe

client:
	g++ client.cpp -o host_client.exe -lzmq
