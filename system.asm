;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; System Maros for Mac OS X
;;
;;	© 2012 David J Goehrig <dave@dloh.org>
;;

%include "syscall.asm"

; displays the counted string on the top of the stack
; len str -- len
%macro show 0	
	arg2
	arg3
	literal 1
	arg1
	literal write
	os
%endmacro

; key -- 
%macro type 0
	dupe		; key -- key key
	stack		; nos address	key -- key stack
	arg2		; key stack -- key
	literal 1	; key -- key stdout 
	arg1		; key -- key
	literal 1	; key -- key 1 byte
	arg3		; key 1 -- key
	literal write	; key -- key write
	os		; key -- key count
	drop		; key -- key
	drop
%endmacro

; --
%macro quit 0
	literal 0
	arg1
	literal exit ; 0x2000001 exit
	os
%endmacro

; -- key
%macro key 0
	stack			; nos pointer
	arg2
	literal 1
	arg3			; read 1 byte
	literal 0		; stdin
	arg1
	literal read
	os
	drop
%endmacro

