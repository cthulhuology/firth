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
;vm
;%include "term.asm"
;quit


	mov rax, write		; 0x2000004 write
	mov rdi, 2		; stderr
	mov rsi, qword message	; string
	mov rdx, 18		; length
	syscall
	mov rax, exit		; 0x2000001 exit
	syscall

message: db "running in image",0xa,0xd
