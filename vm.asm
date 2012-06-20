;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VMMacros

%macro vm 0
_vm:
	jmp _init
	stack: dq 0,0,0,0,0,0,0,0
	number: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	tib: dq 0
	done_str: db "done"
	nl: db 0xd,0xa
	space: db 0x20
_init:
	xor rbp,rbp
	xor rax,rax
	xor rdx,rdx
%endmacro

%macro done 0
	show done_str,6
%endmacro

%macro eol 0
	show nl,2
%endmacro

%macro sp 0
	show space,1
%endmacro

%macro clear 2
	mov rcx,%2		; max numbers
.reset:
	mov byte [ r13 + %1 + rcx - 1],0
	loopnz .reset
%endmacro

%macro emit 0
	mov r11,10		; radix
	clear number,20		; clear buffer
	mov rcx,20
.emit:
	xor rdx,rdx		; make sure we don't get junk
	idiv r11		; divide by radix
	add dl,48		; add ascii 0
	mov byte [ r13 + number + rcx - 1 ],dl	; move to slot
	test rax,rax		; if we've run out of data
	jz .done		; quit
	loopnz .emit		; otherwise do next loop
.done:
	show number,20		; null characters don't write!!!!
%endmacro

%macro key 0
	keys tib,1
	offset tib
	fetchc
%endmacro

%macro type 0
	offset tib
	storec
	show tib,1
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


