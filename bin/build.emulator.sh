#!/usr/bin/env bash

cd ${PROJECT_ROOT}/emulator
make
cp ${SOC_BUILD_DIR}/software/emulator/emulator.bin ${PROJECT_ROOT}/tftp_root/arty/
cat ${PROJECT_ROOT}/tftp_root/arty/boot.manifest | grep emul
ls -l ${PROJECT_ROOT}/tftp_root/arty/
