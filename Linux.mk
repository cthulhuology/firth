
SYSCALLS = cat /usr/include/asm/unistd_64.h | grep -v "old " | grep "^#define" | sed 's%#define%\%define%' | sed 's%__NR_%%' | tail -n +2

ASM = yasm -f elf64

LD = ld -o firth -e open_image
