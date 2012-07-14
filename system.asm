;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; System Maros for Mac OS X
;;
;;	© 2012 David J Goehrig <dave@dloh.org>
;;

%include "syscall.asm"

%macro show 2
	mov rax, write ; 0x2000004 write
	mov rdi, 1			; stderr
	lea rsi, [ r13 + %1 ]		; string 
	mov rdx, %2			; length
	syscall
%endmacro

%macro putc 1
	mov rax,write
	mov rdi,1
	lea rsi, [ %1 ]
	mov rdx,1
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
	lea rsi, [ %1 ]		; buffer
	mov rdx, %2		; count
	syscall			; rax carries count
%endmacro

