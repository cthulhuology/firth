;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VMMacros
; rax top of stack / return value
; rdx misc data, arg3 / 2nd return
; rcx count, arg4
; rbx object pointer			( preserved )  
; rbp data stack pointer		( preserved )
; rsp return stack pointer		( preserved )
; rdi -- syscalls arg1
; rsi -- syscalls arg2
; r8  -- syscalls arg5
; r9  -- syscalls arg6
; r10 -- temp 
; r11 -- temp
; r12 free memory location		( preserved )
; r13 image location			( preserved )
; r14 image size			( preserved )
; r15 file handle			( preserved )

%macro vm 0
_vm:
	jmp _init
	image_addr: dq 0
	image_size: dq 0
	image_fd: dq 0
	free_addr: dq 0
	stack: dq 0,0,0,0,0,0,0,0
_init:
	mov [r13 + image_addr], r13	; Save addr
	mov [r13 + image_size], r14	; Save size
	mov [r13 + image_fd], r15	; Save file handle
	mov r12, [r13 + free_addr ]	; load old free addr
	test r12,r12
	jnz .goon
	lea r12,[__free_space]		; load free space pointer
.goon:
	xor rbp,rbp
	xor rax,rax
	xor rdx,rdx
	xor r12,r12
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

%macro zero 2				; equiv to memset(addr,len,zero)
	mov rcx,%2			; bytes to zero out
.reset:
	mov byte [ r13 + %1 + rcx - 1],0
	loopnz .reset
%endmacro

%macro alloc 0
	mov rdx,r12			; squirrel away free address
	add r12,rax			; update free pointer
	mov rax,rdx			; return address we alloc'd
	mov [r13+free_addr], r12	; save new offset
%endmacro

%macro allocnum 1
	mov rax,r12			; return the free address
	add r12, %1			; increment the free pointer
	mov [r13+free_addr], r12	; save new offset
%endmacro

%macro fetchaddr 1			; fetch an address
	dupe
	mov rax, [ r13 + %1 ]
%endmacro

%macro fetch 0				; fetch address in tos
	mov rax,[rax]
%endmacro

%macro storeaddr 1			; store tos to an address
	mov [r13 + %1],rax
	drop
%endmacro

%macro store 0				; store nos to address in tos
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

%macro addnum 1
	add rax, %1
%endmacro

%macro subtract 0
	sub rax,[nos]
	nip
%endmacro

%macro subnum 1
	sub rax,%1
%endmacro

%macro multiply 0
	imul rax,[nos]
	nip
%endmacro

%macro mulnum 1
	imul rax,%1
%endmacro

%macro divide 0
	xor rdx,rdx
	idiv rax,[nos]
	nip
%endmacro

%macro divnum 1
	xor rdx,rdx
	idiv rax,%1
%endmacro

%macro negate 0			; twos compliment negation
	neg rax
%endmacro

; Logic Macros

%macro intersect 0		; binary and tos and nos
	and rax,[nos]
	nip
%endmacro

%macro andnum 1			; binary and tos with literal
	and rax,%1
%endmacro

%macro union 0			; binary or tos with nos
	or rax,[nos]
	nip
%endmacro

%macro ornum 1			; binary or tos with literal
	or rax,%1
%endmacro

%macro exclusion 0		; binary xor tos with now
	xor rax,[nos]
	nip
%endmacro

%macro xornum 1			; binary xor tos with literal
	xor rax,%1
%endmacro

%macro compliment 0		; ones compliment negation
	not rax
%endmacro


