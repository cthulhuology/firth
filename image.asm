
BITS 64
ORG 0

; r15 contains our file handle
; r14 contains our image size
; r13 contains our image location

mov rax, 0x2000004
mov rdi, 2
lea rsi, [ r13 + worked ]
mov rdx, 15
syscall

jmp $				; halt temporarily

mov rax, 0x2000001
mov edi, 0
syscall

worked: db "running image!", 0xa
