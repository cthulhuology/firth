;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; image.asm
;;
;;	© 2012,2013 David J. Goehrig
;;

BITS 64
ORG 0

;; Include core macro files
%include "vm.asm"
%include "system.asm"
%include "net.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize VM
vm
%include "term.asm"

;; never get here
method .demo
invoke

nop
nop

.demo:
	literal 18
	data message 
	show

.server:
	tcp
	create_socket
	dupe
	reuse_addr
	drop
	dupe
	data sockaddr
	bind_socket
	drop
	dupe
	listen_socket	
.loop:
	jmp .loop

message: db "running in image",0xa,0xd

sockaddr: db 0,2,0x1F,0x90,127,0,0,1,0,0,0,0,0,0,0,0
