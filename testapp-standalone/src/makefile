include ${PLATINC}
include $(SOC_DIRECTORY)/software/common.mak

${BUILDDIR}/${EXENAME}.bin: ${BUILDDIR}/${EXENAME}.elf
	riscv64-unknown-elf-objcopy -O binary ${BUILDDIR}/${EXENAME}.elf ${BUILDDIR}/${EXENAME}.bin
	python3 -m litex.soc.software.mkmscimg ${BUILDDIR}/${EXENAME}.bin --little

clean:
	rm ${BUILDDIR}/${EXENAME}.elf
	rm ${BUILDDIR}/${EXENAME}.bin

${BUILDDIR}/${EXENAME}.elf:	${BASE}/src/main.cpp ${BASE}/src/makefile
	riscv64-unknown-elf-g++ -v \
		-I$(BUILDINC_DIRECTORY) \
	  	-I$(SOC_DIRECTORY)/software/include \
		-I$(SOC_DIRECTORY)/software/include/base \
		-L$(BUILDINC_DIRECTORY)/../libnet \
		-L$(BUILDINC_DIRECTORY)/../libbase \
		-L$(BUILDINC_DIRECTORY)/../libcompiler_rt \
		-D__vexriscv__ ${DEFINES} \
		-std=c++17 -march=rv32im -mabi=ilp32 \
		$(LDFLAGS) \
		-T ${LINKERF} \
		-Wl,-Map=${BUILDDIR}/${EXENAME}.map \
		$(BUILDINC_DIRECTORY)/../libbase/crt0-$(CPU)-ctr.o \
		-N -O3 -g -o $@ ${BASE}/src/main.cpp -lnet -lbase-nofloat -lcompiler_rt
	riscv64-unknown-elf-objdump -d ${BUILDDIR}/${EXENAME}.elf > ${BUILDDIR}/${EXENAME}.asm
