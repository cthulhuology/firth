
ORG 0x800000000
BITS 64

mov rax, 0x2000005	; open
mov rdi, qword mmap	; "mmap"
mov rsi, 0x2		; RDWR
syscall
mov r8, rax		; fd

mov rax, 0x20000c5	; mmap
mov rdi, 0x900000000	; addr
mov rsi, 80		; file size
mov rdx, 0x7		; READ|WRITE|EXEC
mov rcx, 0x11		; SHARED|FILE|FIXED
; mov r8, fd
mov r9,0		; offset 0
syscall

jmp rax 		; jump to address 0x90000000

mmap: db "mmap", 0
