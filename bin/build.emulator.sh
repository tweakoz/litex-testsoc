#!/usr/bin/env bash

cd ${PROJECT_ROOT}/emulator
make
cp ${SOC_BUILD_DIR}/${FPGAPLAT}/software/emulator/emulator.bin ${PROJECT_ROOT}/tftp_root/${FPGAPLAT}/
cat ${PROJECT_ROOT}/tftp_root/${FPGAPLAT}/boot.manifest | grep emul
ls -l ${PROJECT_ROOT}/tftp_root/${FPGAPLAT}/
