all : firth image syscall.asm

syscall.asm :  /usr/include/sys/syscall.h
	cat /usr/include/asm/unistd_64.h | grep -v "old " | grep "^#define" | sed 's%#define%\%define%' | sed 's%__NR_%%' | tail -n +2 > syscall.asm

image.bin : image.asm syscall.asm vm.asm term.asm tools.asm
	yasm -m amd64 -f bin -o image.bin image.asm

image : image.bin 
	dd if=/dev/zero of=image bs=1048576 count=1
	dd if=image.bin of=image bs=1048576 conv=notrunc count=1

firth.o : firth.asm syscall.asm
	yasm -f elf64 firth.asm

firth : firth.o
	ld -o firth -e open_image firth.o

.PHONY: clean
clean:
	rm firth image *.o *.bin syscall.asm
