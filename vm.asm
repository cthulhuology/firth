;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VMMacros
;;
;;	© 2012 David J Goehrig
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Register Allocation 
;
; rax top of stack / return value
; rdx misc data, arg3 / 2nd return
; rcx count
; rbx context pointer			( preserved )  
; rbp data stack pointer		( preserved )
; rsp return stack pointer		( preserved )
; rdi -- syscalls arg1
; rsi -- syscalls arg2
; r8  -- syscalls arg5
; r9  -- syscalls arg6
; r10 -- syscalls arg4 
; r11 -- temp
; r12 free address location		( preserved )
; r13 image location			( preserved )
; r14 image size / fetch pointer	( preserved )
; r15 file handle / store pointer	( preserved )

; register machine
%define ip	rip		; instruction pointer
%define cp	rbx		; context pointer
%define fp	r12		; free pointer
%define bp	r13 		; base pointer
%define dp	rbp		; data stack pointer
%define rp	rsp		; return stack pointer
%define tos	rax		; top of data stack
%define nos	rbp*8+rbx	; next on data stack
%define src	r14		; source address register
%define dst	r15		; destination address register
%define tmp1	r10		; temporary register
%define tmp2	r11		; temporary register

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Define bits of the dictionary

; define a word (in code)

%macro definition 1 ; word
def_%1:
%endmacro

; end a definition (in code)
%macro end 1 ;  word
end_%1:	
	ret
%endmacro

%macro def 1 ; word
definition %1
%1
end %1
%endmacro

; create a dictionary entry (in data)
%macro dict 2 ; word
%strlen _len %2
align 8
word_%1:
dq def_%1		; definition address
dq end_%1 - def_%1	; definition length
dq _len			; word length
db %2 			; word
align 8, db 0
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VM Image Definition
%macro vm 0
_vm:
	jmp _init
	nop			; allocating some extra space for future 
	nop
	nop
	nop
	nop
	nop
	; VM header
	image_addr: dq 0	; 0x
	image_size: dq 0
	image_fd:   dq 0
_init:
	mov [bp + image_addr], r13	; Save addr
	mov [bp + image_size], r14	; Save size
	mov [bp + image_fd], r15	; Save file handle
	mov tos, 0x1000
	spawn				; create a new context
	save
	literal 0x01deadbeef
	literal 0x02deadbeef
	literal 0x03deadbeef
	literal 0x04deadbeef
	literal 0x05cafebabe
	literal 0x06cafebabe
	literal 0x07cafebabe
	literal 0x08cafebabe
	literal 0x09feedface
%endmacro

;; Defines a machine state relative to a context poitner
dstack	equ 0		; data stack
res_ip	equ 8*8		; saved instruction pointer
res_cp	equ 8*9		; context pointer
res_fp	equ 8*10	; free poitner
res_bp	equ 8*11	; base memory pointer
res_dp	equ 8*12	; data stack pointer
res_rp	equ 8*13	; return stack pointer
res_tos	equ 8*14	; top of data stack
res_src	equ 8*15	; memory source address pointer
res_dst	equ 8*16	; memory destination address pointer
rstack	equ 8*17	;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Context macros

;; Saves the machine's context so that it may safely exit
%macro save 0
	lea tmp1, [bp + .endstop]
	mov [cp + res_ip], tmp1		; this is past the data stack 
	mov [cp + res_cp], cp		; at the bottom or the return stack
	mov [cp + res_fp], fp
	mov [cp + res_bp], bp
	mov [cp + res_dp], dp
	mov [cp + res_rp], rp
	mov [cp + res_tos], tos
	mov [cp + res_src], src
	mov [cp + res_dst], dst
.endstop: nop
%endmacro

;; Resume loads the previously save register state into the machine registers
%macro resume 0
	mov bp, [cp + res_bp]
	mov dst, [cp + res_dst]
	mov src, [cp + res_src]
	mov tos, [cp + res_tos]
	mov rp, [cp + res_rp]
	mov dp, [cp + res_dp]
	mov fp, [cp + res_fp]
	mov tmp1, [cp + res_ip]
	push tmp1			; we restore the instruction pointer by returning to it
	ret
%endmacro

;; Switch swaps one context pointer for another
%macro switch 0
	mov [cp+64],dp		; base pointer
	mov [cp+72],rp		; return pointer
	mov cp,tos		; switch contexts
	mov dp,[cp+64]		; load stack
	mov rp,[cp+72]		; load return
%endmacro

;; Creates initializes a new context at a given address, 8 pages 32k
%macro spawn 0	
	lea cp,[bp + tos*8]		; load the context pointer in the top of the stack
	lea rp,[cp + 0x0ff8]		; loads the return stack pointer
	lea fp,[cp + 0x1000]		; free page memory above return stack
	xor dp,dp			; data stack pointer is 0, aka cp + 0
	xor tos,tos			; clear the rest of the pointers etc
	xor src,src
	xor dst,dst
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; System Functions Interface

;; loads OS C ABI arg1
%macro arg1 0
	mov rdi,tos
	drop
%endmacro

;; loads OS C ABI arg2
%macro arg2 0
	mov rsi,tos
	drop
%endmacro

;; loads OS C ABI arg3
%macro arg3 0
	mov rdx,tos
	drop
%endmacro

;; loads OS C ABI arg4
%macro arg4 0
	mov r10,tos
	drop
%endmacro

;; loads OS C ABI arg5
%macro arg5 0
	mov r8,tos
	drop
%endmacro

;; loads OS C ABI arg6
%macro arg6 0
	mov r9,tos
	drop
%endmacro

;; Makes an operating system call
%macro os 0
	syscall
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Stack functions

;; moves the top of the data stack to the top of the return stack
%macro rpush 0
	push tos
	drop
%endmacro

;; move top of the return stack to the top of the data stack
%macro rpop 0
	dupe
	pop tos
%endmacro

;; places tos in nos and pushes rest of the stack down
%macro dupe 0
	add dp,1
	and dp,7
	mov [nos],tos
%endmacro

;; drops the next on the data stack
%macro nip 0
	add dp,-1
	and dp,7
%endmacro

;; removes top of the stack fetches the next on stack
%macro drop 0
	mov tos,[nos]
	nip
%endmacro

;; places the address of the next on the stack into the top of the stack
%macro stack 0
	lea tos,[nos]
%endmacro

;; Places a literal value in tos
%macro literal 1
	dupe
	mov tos, %1
%endmacro

;; Places the address of a code point in tos
%macro method 1
	dupe
	lea tos,[bp+%1]
%endmacro

;; Locates literal data pointer
%macro data 1
	dupe
	lea tos,[bp+%1]
%endmacro


;; places the address of a static region of memory on the stack
%macro offset 1
	dupe
	lea tos,[%1]			; load it as if zero based addr
	shr tos,3			; divide by 8 to get cell addr
%endmacro

;; places the address of a given memory cell into tos, cells start addressing from 0
%macro cell 1
	dupe
	lea tos, [bp + %1*8]
%endmacro

; Memory macros

%macro free 0
	xchg tos,fp			; swaps the free pointer with tos
%endmacro

%macro compile 0
	mov [fp],tos			; copies tos to the next free address
	drop				; drops the tos
	lea fp,[fp+8]			; advances the free pointer
%endmacro

%macro alloc 0
	mov tmp1,fp			; squirrel away free address
	lea fp,[fp + tos*8]		; update free pointer allocating tos cells
	mov tos,tmp1			; return address we alloc'd
%endmacro

%macro allocnum 1
	mov tos,fp			; return the free address
	lea fp,[fp + %1*8]		; update by fixed num cells
%endmacro

%macro fetchraw 0
	mov tos,[tos]			; absolute addressing
%endmacro

%macro fetchaddr 1			; fetch an address
	dupe
	mov tos,[bp + %1*8]		; cell based addressing
%endmacro

%macro fetch 0				; fetch address in tos
	mov tos,[bp + tos*8]		;
%endmacro

; -- cell
%macro fetchplus 0
	dupe
	mov tos,[bp + src*8]		; fetch from src register
	add src,1			; increment src register
%endmacro

%macro source 0				; swaps the src and top of stack
	xchg src,tos
%endmacro

%macro storeaddr 1			; store tos to an address
	mov [bp + %1*8],tos	
	drop
%endmacro

%macro store 0				; store nos to address in tos
	mov tmp1,[nos]
	mov [bp + tos*8],tmp1		; store to a cell address
	nip
	drop				; remove two elements from stack
%endmacro

%macro storeplus 0
	mov [bp+ dst*8],tos		; store top of stack to memory address
	add dst,1			; increment meory addr
	drop
%endmacro

%macro dest 0
	xchg dst,tos			; swap destination and top of stack
%endmacro

%macro deststore 0
	dupe
	mov [dst],tos
%endmacro

%macro sourcefetch 0
	mov tos,[src]
	drop
%endmacro

; Math macros
%macro addition 0
	add tos,[nos]
	nip
%endmacro

%macro addnum 1
	add tos, %1
%endmacro

%macro subtract 0
	sub tos,[nos]
	nip
%endmacro

%macro subnum 1
	sub tos,%1
%endmacro

%macro multiply 0
	imul tos,[nos]
	nip
%endmacro

%macro mulnum 1
	imul tos,%1
%endmacro

%macro divide 0
	xor rdx,rdx
	mov tmp1,[nos]
	idiv tos,tmp1
	nip
%endmacro

%macro divnum 1
	xor rdx,rdx
	mov tmp1,%1
	idiv tos,tmp1
%endmacro

%macro negate 0			; twos compliment negation
	neg tos
%endmacro

; Logic Macros

%macro andb 0			; binary and tos and nos
	and tos,[nos]
	nip
%endmacro

%macro andnum 1			; binary and tos with literal
	and tos,%1
%endmacro

%macro orb 0			; binary or tos with nos
	or tos,[nos]
	nip
%endmacro

%macro ornum 1			; binary or tos with literal
	or tos,%1
%endmacro

%macro xorb 0			; binary xor tos with now
	xor tos,[nos]
	nip
%endmacro

%macro xornum 1			; binary xor tos with literal
	xor tos,%1
%endmacro

%macro notb 0			; ones compliment negation
	not tos
%endmacro

%macro shiftl 0			; shift left 1
	mov rcx,[nos]
	shl tos,cl
	nip
%endmacro

%macro shiftlnum 1		; shift left num
	shl tos,%1
%endmacro

%macro shiftr 0			; shift right 1
	mov rcx,[nos]
	shr tos,cl
	nip
%endmacro

%macro shiftrnum 1		; shift right num
	shr tos,%1
%endmacro

;; test / flow control 
; b a -- b 0|b
%macro equals 0
	cmp rax,[nos]
	je .econt
	xor rax,rax
.econt:	nop
%endmacro

%macro zero 0
	dupe
	test rax,rax
	jnz .zcont
	not rax		; rax is not zero
	jmp .zdone
.zcont: xor rax,rax	; rax is 0
.zdone: nop
%endmacro

; b a -- b 0|a
%macro less 0
	cmp [nos],rax
	jl .lcont
	xor rax,rax
.lcont:  nop
%endmacro

; b a -- b 0|a
%macro more 0
	cmp [nos],rax
	jg .gcont
	xor rax,rax
.gcont:  nop
%endmacro

; x addr -- x --> addr
%macro if 0
	rpush
	test rax,rax	; if it is zero we don't jump
	jz .ifcnt
	drop
	ret 
.ifcnt:	pop tos		; discard return address on return stack
	drop
%endmacro

%macro invoke 0
	rpush
	ret
%endmacro

%macro continue 0
	test rax,rax
	jz .cntcnt
	drop
	ret
.cntcnt: drop
%endmacro

%macro forever 0
	jmp $$
%endmacro


