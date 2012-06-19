;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; image.asm
;;
;;	© 2012 David J. Goehrig
;;	All Rights Reserved.
;;

BITS 64
ORG 0

%include "syscall.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; r15 contains our file handle
; r14 contains our image size
; r13 contains our image location

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Macros

; system macros
%macro show 2
	mov rax, write ; 0x2000004		; write
	mov rdi, 1			; stderr
	lea rsi, [ r13 + %1 ]		; string 
	mov rdx, %2			; length
	syscall
%endmacro

%macro quit 0
	mov rax, exit ; 0x2000001		; exit
	mov edi, 0			; return value
	syscall
%endmacro

; stack macros
%define nos rbp*8+r13+stack

%macro dupe 0
	add rbp,1
	and rbp,7
	mov [nos],rax
%endmacro

%macro nip 0
	add rbp,-1
	and rbp,7
%endmacro

%macro drop 0
	mov rax,[nos]
	nip
%endmacro

%macro literal 1
	dupe
	mov rax, %1
%endmacro

%macro offset 1
	dupe
	lea rax, [ r13 + %1 ]
%endmacro

; Memory macros

%macro fetch 0
	mov rax,[rax]
%endmacro

%macro store 0
	mov rdx,[nos]
	mov [rax],rdx
	nip
	drop
%endmacro

%macro fetchc 0
	xor rdx,rdx
	mov dl, byte [rax]
	xchg rax,rdx
%endmacro

%macro storec 0
	mov rdx,[nos]
	mov byte [rax],dl
	nip
	drop
%endmacro

; Math macros
%macro addition 0
	add rax,[nos]
	nip
%endmacro

%macro subtract 0
	sub rax,[nos]
	nip
%endmacro

%macro multiply 0
	imul rax,[nos]
	nip
%endmacro

%macro divide 0
	xor rdx,rdx
	idiv rax,[nos]
	nip
%endmacro

%macro negate 0
	neg rax
%endmacro

; Logic Macros

%macro intersect 0
	and rax,[nos]
	nip
%endmacro

%macro union 0
	or rax,[nos]
	nip
%endmacro

%macro exclusion 0
	xor rax,[nos]
	nip
%endmacro

%macro compliment 0
	not rax
%endmacro


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Print that we're running in image
show worked,16

; test vm machine models
mov rbp, 0
mov rax, 0

literal 4
literal 2
addition

literal 48
addition
offset number
storec

show number,2

show done,8
quit

; exit 0

worked: db "running image!", 0xa, 0xd
number: db "0", 0xd
done: db 0xa,0xd,"done",0xa,0xd


; Data stack 8
stack: dq 0,0,0,0,0,0,0,0

