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

offset dump_test
literal 10
call dump
quit

%include "term.asm"
%include "tools.asm"

__free_space:
dq 90,90,90,90,90,90,90,90

dump_test: 
	dq 0xcafebabe, 0xdeadbeef, 0xfeedface, 0x1234, 0xffeeddaa
	dq 0x12345678cafebabe, 0xdeadbeef, 0xfeedface, 0x1234, 0xffeeddaa
