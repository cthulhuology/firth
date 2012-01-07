all : firth image

image : image.asm
	yasm -f bin -o image image.asm

firth.o : firth.asm 
	yasm -f macho64 firth.asm

firth : firth.o
	ld -o firth -e mystart -macosx_version_min 10.7 -pagezero_size 0x100000000 firth.o

.PHONY: clean
clean:
	rm firth image *.o
