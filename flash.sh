#!/usr/bin/env bash

export ESPTOOL_PORT=/dev/cu.SLAB_USBtoUART
esptool.py write_flash 0x00000 firmware.bin
