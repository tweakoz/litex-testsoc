export PLATINC=${SOC_BUILD_DIR}/${FPGAPLAT}/software/include/generated/variables.mak
export LINKERF=${LITEX_ROOT}/soc/software/libbase/linker-sdram.ld
export BASE=${PROJECT_ROOT}/testapp-standalone
export BUILDDIR=${BASE}/.build
export EXENAME=main-device
export DEFINES="-DDEVICE"
make -f ${BASE}/src/makefile clean
make -f ${BASE}/src/makefile
