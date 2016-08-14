#!/usr/bin/env bash

export ESPTOOL_PORT=/dev/cu.SLAB_USBtoUART
export ESPTOOL_FS=32m # 32m works
export ESPTOOL_FM=qio # qio works
FIRMWARE=nodemcu-master-8-modules-2016-08-10-17-47-53-integer.bin

esptool.py write_flash --verify 0x00000 $FIRMWARE 0x3fc000 esp_init_data_default.bin
