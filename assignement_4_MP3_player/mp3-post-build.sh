#!/bin/bash


sed -i "s/export PS1='# '/export PS1='MP3_shell> '/" ${TARGET_DIR}/etc/profile

output/host/bin/aarch64-linux-gcc ${TARGET_DIR}/MyApplication/printHello.c -o ${TARGET_DIR}/MyApplication/printHello.o
rm ${TARGET_DIR}/MyApplication/printHello.c

