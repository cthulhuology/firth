;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; image.asm
;;
;;	© 2012 David J. Goehrig
;;	All Rights Reserved.
;;

BITS 64
ORG 0

;; Include core macro files
%include "vm.asm"
%include "system.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; r15 contains our file handle
; r14 contains our image size
; r13 contains our image location

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize VM
vm

show_cafebabe:
	literal 0xcafebabe
	emit
	sp

show_zero:
	literal 0
	emit
	eol

read_keys:
	key
	cmp rax,27
	je .fin
	type		; print ascii character
	jmp read_keys

.fin:
	done
	quit


;; Data Section

; Data stack 8

