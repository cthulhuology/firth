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

;; Test code

literal 16
offset running
print

literal 4
literal 2
addition

literal 48
addition
offset number
storec

literal 3
offset number
print

literal 6
offset done
print 

quit


;; Data Section

running: db "running image!", 0xa, 0xd
number: db "0", 0xa,0xd
done: db "done",0xa,0xd

; Data stack 8

