all : firth image syscall.asm

syscall.asm :  /usr/include/sys/syscall.h
	cat /usr/include/sys/syscall.h | grep -v "old " | grep "^#define" | sed 's%#define%\%define%' | sed 's%SYS_%%' | sed 's%$$% + 0x2000000%'   | tail -n +3 > syscall.asm

image.bin : image.asm syscall.asm
	yasm -f bin -o image.bin image.asm

image : image.bin
	dd if=/dev/zero of=image bs=1048576 count=1
	dd if=image.bin of=image bs=1048576 conv=notrunc count=1

firth.o : firth.asm 
	yasm -f macho64 firth.asm

firth : firth.o
	ld -o firth -e mystart -macosx_version_min 10.7 -pagezero_size 0x100000000 firth.o

.PHONY: clean
clean:
	rm firth image *.o *.bin syscall.asm
