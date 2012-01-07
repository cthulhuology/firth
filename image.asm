
ORG 0x100003000
BITS 64

mov rax, 0x2000004
mov rdi, 1
mov rsi, qword worked
mov rdx, 15
syscall

jmp $

mov rax, 0x2000001
mov edi, 0
syscall


worked: db "running image!", 0xa
