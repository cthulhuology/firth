
SYSCALLS = cat /usr/include/asm/unistd_64.h | grep -v "old " | grep "^#define" | sed 's%#define%\%define%' | sed 's%__NR_%%' | tail -n +2

ASM = yasm -f elf64

LD = ld -o firth -e open_image


syscall.asm: /usr/include/asm/unistd_64.h
	cat /usr/include/asm/unistd_64.h | grep "__NR_" | sed 's%.* __NR_%%g' | grep -v '#define' | grep -v SYSCALL | grep -v ifndef | grep -v endif | grep -v '\*' | awk '{ print "%define", $$1, $$2 }' > syscall.asm
	
firth.o : firth.asm syscall.asm
	yasm -f elf64 firth.asm -D Linux

firth : firth.o
	ld -o firth -e open_image firth.o
