;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tools.asm
;;
;;	© 2012 David J Goehrig <dave@dloh.org>
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; things necessary for bootstrapping the compiler
;;

jmp tools_end
dump:			; address count dump
	mov rcx,rax
	xor rdx,rdx
	drop
	src
.dump
	fetchplus	; fetch data
	push rcx	; save count
	push rdx	; save iteration
	call hexen	; hexdump cell
	call space	; then print a space
	pop rdx
	add rdx,1
	cmp rdx,4	;
	jl .continue
	call eol
	mov rdx,0
.continue:
	pop rcx		; recover the count
	test rcx,rcx
	loopnz .dump
	call eol
	ret

;; fin
tools_end:
