all : test.s test boot boot2 image firth

test.s : test.c
	gcc -arch x86_64 -m64 -S -fasm-blocks test.c

test : test.c
	gcc -arch x86_64 -m64 -fasm-blocks test.c -o test

boot : boot.c
	gcc -o boot boot.c

boot2 : boot.asm
	yasm -f bin -o boot2 boot.asm

image : image.asm
	yasm -f bin -o image image.asm

firth.o : firth.asm 
	yasm -f macho64 firth.asm

firth : firth.o
	ld -o firth -e start -macosx_version_min 10.7 firth.o
