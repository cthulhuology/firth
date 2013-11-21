;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; image.asm
;;
;;	© 2012 David J. Goehrig
;;

BITS 64
ORG 0x100003000	
;; Include core macro files
%include "vm.asm"
%include "system.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize VM

mov rax, write		; 0x2000004 write
mov rdi, 2		; stderr
mov rsi, qword inimage	; string
mov rdx, 18		; length
syscall

;;vm
;;%include "term.asm"
mov rax,exit
syscall

inimage: db "in the image now", 0xa, 0xd
