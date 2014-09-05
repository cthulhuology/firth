
ARCH = $(shell uname)

all : firth image syscall.asm

# This routine is use to generate the base file, edited by hand later
dict.asm:
	grep def image.asm  | awk "{ printf \"dict %s,'%s'\\n\", \$$2, \$$2 }" > dict.asm

include $(ARCH).mk
	
image.bin : image.asm syscall.asm vm.asm term.asm tools.asm dict.asm
	yasm -m amd64 -f bin -o image.bin image.asm -D $(ARCH)

image : image.bin 
	dd if=/dev/zero of=image bs=1048576 count=1
	dd if=image.bin of=image bs=1048576 conv=notrunc count=1

.PHONY: clean
clean:
	rm firth image *.o *.bin syscall.asm
