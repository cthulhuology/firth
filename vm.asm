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
; rcx count, arg4
; rbx context pointer			( preserved )  
; rbp data stack pointer		( preserved )
; rsp return stack pointer		( preserved )
; rdi -- syscalls arg1
; rsi -- syscalls arg2
; r8  -- syscalls arg5
; r9  -- syscalls arg6
; r10 -- temp 
; r11 -- temp
; r12 free address location		( preserved )
; r13 image location			( preserved )
; r14 image size / fetch pointer	( preserved )
; r15 file handle / store pointer	( preserved )

%macro vm 0
_vm:
	jmp _init
	; VM header
	image_addr: dq 0
	image_size: dq 0
	image_fd: dq 0

	; Memory Segments
	lexicon: dq 0		; [ r13 + lexicon ]
	dictionary: dq 0	; [ r13 + dictionary ]
	source: dq 0		; [ r13 + source ]
	code: dq 0		; [ r13 + code ]

	; Context
	context prime
		
_init:
	mov [r13 + image_addr], r13	; Save addr
	mov [r13 + image_size], r14	; Save size
	mov [r13 + image_fd], r15	; Save file handle
	lea rbx, [ r13 + prime ]	; primary context
%endmacro

; Context macros

%macro context 1
%1:
	.stack: dq  0,0,0,0,0,0,0,0
	.registers: dq 0,0,0		; data, return, free	-- could expand to have a dictionary, source, and code per context
%endmacro

%macro switch 0
	mov [rbx+64],rbp		; base pointer
	mov [rbx+72],rsp		; return pointer
	mov [rbx+80],r12		; heap pointer
	mov rbx,rax			; switch contexts
	mov rbp,[rbx+64]		; load base
	mov rsp,[rbx+72]		; load return
	mov r12,[rbx+80]		; load heap
%endmacro

%macro spawn 0	; allocate a new context


%endmacro


; stack macros
%define nos rbp*8+rbx

%macro rpush 0
	push rax
	drop
%endmacro

%macro rpop 0
	dupe
	pop rax
%endmacro

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
	mov rdx,[r12]			; squirrel away free address
	add [r12],rax			; update free pointer
	mov rax,rdx			; return address we alloc'd
%endmacro

%macro allocnum 1
	mov rax,[r12]			; return the free address
	add [r12], %1			; increment the free pointer
%endmacro

%macro fetchaddr 1			; fetch an address
	dupe
	mov rax, [ r13 + %1 ]
%endmacro

%macro fetch 0				; fetch address in tos
	mov rax,[rax]
%endmacro

%macro fetchplus 0
	dupe
	mov rax,[r14]
	lea r14,[r14+8]
%endmacro

%macro fetchc 0
	xor rdx,rdx
	mov dl, byte [rax]
	xchg rax,rdx
%endmacro

%macro src 0
	xchg r14,rax
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

%macro storeplus 0
	mov [r15],rax
	lea r15,[r15+8]
	drop
%endmacro

%macro storec 0
	mov rdx,[nos]
	mov byte [rax],dl
	nip
	drop
%endmacro

%macro dest 0
	xchg r15,rax
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

; Lexicon searching, returns the word

%macro lookup 0			; rax holds a counted string pointer
	dupe			; save old rax
	mov r10,[r13+lexicon]	; load the current lexicon into r10
.next:
	mov r11,[r10]		; lookup the next address
	mov rcx,[r10+8]		; load the length
	lea rsi,[r10+16]	; load the string address
	lea rdi,rax		; load the input buffer address
	repe cmpsb		; and test if equal	
	jz .found		; we found it 
	mov r10,r11		; otherwise we load the next
	test r10,r10
	jz .found		; we didn't actually find it here...
	jmp .next		; but we can only do it again if >0
.found:	
	mov rax,r10		; return the value we found
.done:
%endmacro

; A lexicon entry has the format:
;
;	dq next_word
;	dq character count
;	dq string...
;
; It is the counted string for each 

%macro lex 0			; rax contains tib
	mov r11,[r13+lexicon]	; lookup current lexicon address 
	mov r10,[r11+8]		; load count
	shr r10,3
	add r10,3
	shl r10,3		; cell boundary the count
	lea r9,[r11+r10]	; load the address of the next word
	mov [r9],r11		; save next pointer at free lexicon location
	mov rcx,[rax]		; load the count 
	mov [r9+8],rcx		; and store it
	lea rdi,[r9+16]		; and setup a copy
	lea rsi,[rax+8]		; load the tib into source
	rep movsb		; copy into place
	mov [r13+lexicon],r9	; save pointer to current word
%endmacro

; Definition binds a lexicon entry to a code address
;
;	dq word			- lexicon reference being defined
;	dq source address	- source is stored as pointers to lexicon entries
;	dq source words		- total number of words in this source listing
;	dq code address		- address of compiled code
;	dq code bytes		- number of bytes for the routine
;

%macro def 0


%endmacro

; Compilation
;
;

%macro compile 0


%endmacro
