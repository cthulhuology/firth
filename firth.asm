; firth.asm - boot loader for a firth image
;

BITS 64

section .text

global mystart

mystart:
	mov rax, 0x2000004
	mov rdi, 1
	mov rsi, qword booting
	mov rdx, 17
	syscall

open_image:
	mov rax, 0x2000005	; open
	mov rdi, qword image	; "image"
	mov rsi, 0x2		; RDWR
	syscall
	mov r8, rax		; fd
	mov r15, rax		; fd copy

find_size:
	mov rax, 0x20000bd	; fstat
	mov rdi, r15		; file descriptor
	mov rsi, qword stats	; buffer address
	syscall
	mov r13, 0x100001088
	mov r14, [r13] ; save image size
	jmp $

map_image:
	mov rax, 0x20000c5	; mmap
	mov rdi, 0x100003000	; addr
	mov rsi, r14		; file size
	mov rdx, 0x7		; READ0x1|WRITE0x2|EXEC0x4
	mov rcx, 0x111		; NO_EXTEND0x100|SHARED0x01|FILE0x00| 0x10 FIXED 0x111 (1802 ANON JIT PRIVATE)
	; mov r8, fd
	mov r9,0		; offset 0
	syscall
	mov r13,rax		; image address

boot:
	test r13,r13		; test image mmap result (0 means we failed)
	jnz works

fail:
	mov rax, 0x2000004	; write
	mov rdi, 2		; stderr
	mov rsi, qword error	; 
	mov rdx, 22
	syscall
	mov rax, 0x2000001	; exit
	syscall

works:
	mov rax, 0x2000004
	mov rdi, 2
	mov rsi, qword worked
	mov rdx, 17
	syscall
	jmp r13			; jump to image

section .data

error: db "failed to load image!",0xa
worked: db "loading image...", 0xa
booting: db "booting firth...", 0xa
image: db "image", 0,90,90
stats: dq 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
done: db "done"

