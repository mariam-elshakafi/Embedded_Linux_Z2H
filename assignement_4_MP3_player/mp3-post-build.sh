#!/bin/bash

output/host/bin/aarch64-linux-gcc ${TARGET_DIR}/MyApplication/printHello.c -o ${TARGET_DIR}/MyApplication/printHello.o
rm ${TARGET_DIR}/MyApplication/printHello.c
