;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; firth.asm - boot loader for a firth image
;
; © 2012,2013 David J Goehrig <dave@dloh.org>
;

BITS 64

section .text			; starts 0x100000000

image_start equ	0x100003000	; image loaded 3 pages higher

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
	mov rdi, image_start	; image addr
	mov rsi, r14		; file size
	mov rdx, 0x7		; READ0x1|WRITE0x2|EXEC0x4
	mov r10, 0x111		; NO_EXTEND0x100|SHARED0x01|FILE0x00| 0x10 FIXED 0x111 (1802 ANON JIT PRIVATE)
	; mov r8, fd
	mov r9,0		; offset 0
	syscall
	mov r13,rax		; image address

boot:
	test r13,r13		; test image mmap result (0 means we failed)
	jnz works

fail:
	mov rax, write		; 0x2000004 write
	mov rdi, 2		; stderr
	mov rsi, qword error	; string
	mov rdx, 23		; length
	syscall
	mov rax, exit		; 0x2000001 exit
	syscall

works:
	jmp r13			; jump to image

section .data			; 0x100001000

error:	db "failed to load image!",0xa,0xd
image:	db "image", 0,90,90
stats:	dq 0,0,			; starts at 0x40 from start of data segment
	dq 0,0,
	dq 0,0,
	dq 0,0,
	dq 0
size:	dq 0,					; 0x100001088
	dq 0,0,0,0,0,0,0,0,0,0,0,0,0		; 

