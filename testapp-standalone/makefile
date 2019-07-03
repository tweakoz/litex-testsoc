include ${SOC_BUILD_DIR}/simulation/software/include/generated/variables.mak
include $(SOC_DIRECTORY)/software/common.mak

main.bin: main.elf
	riscv64-unknown-elf-objcopy -O binary main.elf main.bin
	python3 -m litex.soc.software.mkmscimg main.bin --little

clean:
	rm main.elf
	rm main.bin

main.elf:	main.cpp makefile
	riscv64-unknown-elf-g++ -v \
		-I$(BUILDINC_DIRECTORY) \
	  	-I$(SOC_DIRECTORY)/software/include \
		-I$(SOC_DIRECTORY)/software/include/base \
		-L$(BUILDINC_DIRECTORY)/../libnet \
		-L$(BUILDINC_DIRECTORY)/../libbase \
		-L$(BUILDINC_DIRECTORY)/../libcompiler_rt \
		-D__vexriscv__  \
		-std=c++17 -march=rv32im -mabi=ilp32 \
		$(LDFLAGS) \
		-T ${PROJECT_ROOT}/testapp-standalone/link_as_rom.d \
		-Wl,-Map=main.map \
		$(BUILDINC_DIRECTORY)/../libbase/crt0-$(CPU)-ctr.o \
		-N -O0 -g -o $@ main.cpp -lnet -lbase-nofloat -lcompiler_rt
	riscv64-unknown-elf-objdump -d ./main.elf > main.asm

#-T $(SOC_DIRECTORY)/software/libbase/linker-sdram.ld \
