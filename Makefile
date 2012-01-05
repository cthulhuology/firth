all : test.s test boot image mmap

test.s : test.c
	gcc -arch x86_64 -m64 -S -fasm-blocks test.c

test : test.c
	gcc -arch x86_64 -m64 -fasm-blocks test.c -o test

boot : boot.c
	gcc -o boot boot.c

image : image.asm
	yasm -f bin -o image image.asm

mmap : mmap.asm
	yasm -f bin -o mmap mmap.asm
