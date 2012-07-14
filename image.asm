;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; image.asm
;;
;;	© 2012 David J. Goehrig
;;

BITS 64
ORG 0

;; Include core macro files
%include "vm.asm"
%include "system.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize VM
vm
%include "term.asm"
quit
