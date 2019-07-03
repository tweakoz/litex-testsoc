#!/usr/bin/env sh

djtgcfg prog -d Arty -i 0 -f ${SOC_BUILD_DIR}/gateware/top.bit
litex_term --speed 115200 ${DEVTTY} --kernel main.bin
stty sane
