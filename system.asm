;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; System Maros for Mac OS X

%include "syscall.asm"

%macro show 2
	mov rax, write ; 0x2000004 write
	mov rdi, 1			; stderr
	lea rsi, [ r13 + %1 ]		; string 
	mov rdx, %2			; length
	syscall
%endmacro

%macro quit 0
	mov rax, exit ; 0x2000001 exit
	mov edi, 0			; return value
	syscall
%endmacro

%macro print 0
	mov rsi,rax
	mov rdx,[nos]
	nip
	mov rax, write
	mov rdi, 1
	syscall
%endmacro

%macro keys 2
	mov rax, read		; 0x
	mov rdi, 0		; stdin
	lea rsi, [ r13 + %1 ]	; buffer
	mov rdx, %2		; count
	syscall			; rax carries count
%endmacro

