#!/bin/sh

rm -rf build
mkdir build

nasm -g -f elf64 -o build/main.o -l build/main.lst src/main.asm
ld -static -o build/main  build/main.o
