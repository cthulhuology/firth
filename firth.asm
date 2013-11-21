m; firth.asm - boot loader for a firth image
;
; © 2012 David J Goehrig <dave@dloh.org>
;

BITS 64

section .text		; starts 0x100000000

%include "syscall.asm"

global open_image

open_image:
	mov rax, open		; 0x2000005 open
	mov rdi, qword image	; "image"
	mov rsi, 0x2		; RDWR
	syscall
	mov r8, rax		; fd
	mov r15, rax		; fd copy

find_size:
	mov rax, fstat		; 0x20000bd fstat
	mov rdi, r15		; file descriptor
	mov rsi, qword stats	; buffer address
	syscall
	mov r13, qword size	; size of image file
	mov r14, [r13]		; save image size

map_image:
	mov rax, mmap		; 0x20000c5 mmap
	mov rdi, 0x100003000	; addr
	mov rsi, r14		; file size
	mov rdx, 0x7		; READ0x1|WRITE0x2|EXEC0x4
	mov r10, 0x111		; NO_EXTEND0x100|SHARED0x01|FILE0x00| 0x10 FIXED 0x111 0x800 JIT (1802 ANON JIT PRIVATE)
	mov r8, 3 
	mov r9,0		; offset 0
; lo2p:	jmp lo2p
	syscall
	mov r13,rax		; image address

boot:
	cmp rdi,rax		; test image mmap result doesn't equal rdi we failed
	je works

fail:
	mov rax, write		; 0x2000004 write
	mov rdi, 2		; stderr
	mov rsi, qword error	; string
	mov rdx, 23		; length
	syscall
	mov rax, exit		; 0x2000001 exit
	syscall

works:
	jmp rax			; jump to image

section .data			; 0x100001000

error:	db "failed to load image!",0xa,0xd
worked: db "it loaded image", 0xa, 0xd
image:	db "image", 0,90,90
stats:	dq 0,0,			; starts at 0x40 from start of data segment
	dq 0,0,
	dq 0,0,
	dq 0,0,
	dq 0,
size:	dq 0,0,
	dq 0,0,
	dq 0,0,0,0,0,0,0,0,0,0,0,0,0		; 
	dq 0,0,0,0,0,0,0,0,0,0,0,0,0		; 
