; firth.asm - boot loader for a firth image
;

BITS 64

section .text

global start

start:
	mov rax, 0x2000005	; open
	mov rdi, qword image	; "image"
	mov rsi, 0x2		; RDWR
	syscall
	mov r8, rax		; fd

stat:
;	mov rax, 0x20000bd	; fstat
;	mov rdi, r8		; fd
;	mov rsi, qword stats		; address of stats array, st_size is at stats + 96 bytes
;	syscall
	
;	mov rsi, qword [rsi+96]	; st_size	
	
mmap:
	mov rax, 0x20000c5	; mmap
	mov rdi, 0x900000000	; addr
	; mov rsi, st_size
	mov rsi, 80
	mov rdx, 0x7		; READ|WRITE|EXEC
	mov rcx, 0x11		; SHARED|FILE|FIXED
	; mov r8, fd
	xor r9,0		; offset 0
	syscall

boot:
	mov rax,0x900000000
	jmp rax

image: db "image", 0,0,0

section .data

stats: dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0