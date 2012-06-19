;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VMMacros

%macro vm 0
_vm:
	jmp _init
	stack: dq 0,0,0,0,0,0,0,0
_init:
	xor rbp,rbp
	xor rax,rax
	xor rdx,rdx
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


