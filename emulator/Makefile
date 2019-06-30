include ${SOC_BUILD_DIR}/software/include/generated/variables.mak
include $(SOC_DIRECTORY)/software/common.mak

BUILD_DIR=${SOC_BUILD_DIR}/software/emulator

OBJECTS=${BUILD_DIR}/isr.o ${BUILD_DIR}/main.o

all: ${BUILD_DIR}/emulator.bin

# pull in dependency info for *existing* .o files
-include $(OBJECTS:.o=.d)

${BUILD_DIR}/%.bin: ${BUILD_DIR}/%.elf
	$(OBJCOPY) -O binary $< $@
	chmod -x $@

${BUILD_DIR}/emulator.elf: $(OBJECTS)
	$(LD) $(LDFLAGS) \
		-T linker.ld \
		-N -o $@ \
		 $(SOC_BUILD_DIR)/software/libbase/crt0-$(CPU)-ctr.o \
		$(OBJECTS) \
		-L$(SOC_BUILD_DIR)/software/libbase \
		-L$(SOC_BUILD_DIR)/software/libcompiler_rt \
		-lbase-nofloat -lcompiler_rt \
		-Map=${BUILD_DIR}/emulator.map
	chmod -x $@

${BUILD_DIR}/main.o: main.c
	$(compile)

${BUILD_DIR}/%.o: %.c
	$(shell mkdir -p $(BUILD_DIR))
	$(compile)

${BUILD_DIR}/%.o: %.S
	$(assemble)

clean:
	$(RM) $(OBJECTS) $(OBJECTS:.o=.d) ${BUILD_DIR}/emulator.elf ${BUILD_DIR}/emulator.bin .*~ *~

.PHONY: all main.o clean load

