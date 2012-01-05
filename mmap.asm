
ORG 0x900000000
BITS 64

mov rax, 0x2000004
mov rdi, 1
mov rsi, qword worked
mov rdx, 11
syscall

nop
nop
nop
nop
nop
nop
nop

mov rax, 0x2000001
mov edi, 0
syscall

nop
nop
nop
nop
nop
nop
nop
nop
nop
nop

worked: db "it worked!", 0xa, 0,0,0,0,0
