export PLATINC=${SOC_BUILD_DIR}/${FPGAPLAT}/simulation/software/include/generated/variables.mak
export BASE=${PROJECT_ROOT}/testapp-standalone
export LINKERF=${BASE}/src/link_as_rom.d
export BUILDDIR=${BASE}/.build
export EXENAME=main-sim
export DEFINES="-DSIM"
make -f ${BASE}/src/makefile clean
make -f ${BASE}/src/makefile
