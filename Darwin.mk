
syscall.asm: /usr/include/sys/syscall.h
	cat /usr/include/sys/syscall.h | grep -v "old " | grep "^#define" | sed 's%#define%\%define%' | sed 's%SYS_%%' | sed 's%$$% + 0x2000000%'   | tail -n +3 > syscall.asm
	
firth.o : firth.asm syscall.asm
	yasm -f macho64 firth.asm -D Darwin

firth : firth.o
	ld -o firth -e open_image -macosx_version_min 10.7 -pagezero_size 0x100000000 firth.o
