;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Terminal Code
;;
;;	© 2012 David J Goehrig <dave@dloh.org>
;;


call clear
call term
; we never get here

%include "tools.asm"

; this is the key input display loop
term:
	key
	dupe
	type
	call test_quit
	call test_retn
	call test_backspace
	call test_plain
	call test_red
	call test_green
	jmp term		; will return

test_quit:
	literal 17	; ctrl-q
	equals
	method done
	if
	ret

done:
	quit
	ret

test_retn:
	literal 13
	equals
	method linefeed
	if
	ret

linefeed:
	literal 10
	type
	ret

test_backspace:
	literal 127		; delete key
	equals
	method backspace
	if
	ret

backspace:
	literal 8
	type
	literal 32
	type
	literal 8
	type
	ret

nl:	
	literal 0xa
	type
	ret

eol:
	literal 0xd
	type
	literal 0xa
	type
	ret

space:
	literal 0x20
	type
	ret

clear:
	literal 27
	type
	literal 99
	type
	ret

test_green;
	literal 7
	equals
	method green_text
	if
	ret

green_text:
	data green_str
	cshow
	ret

test_red:
	literal 18
	equals
	method red_text
	if
	ret

red_text:
	data red_str
	cshow
	ret

test_plain:
	literal 16
	equals
	method plain_text
	if
	ret

plain_text:
	data plain_str
	cshow
	ret

; ANSI color codes and jazz
align 8
terminal_data:
	done_str: db "done",0,0,0,0
align 8
	plain_str: db 8,27,"[0;0;0m"
align 8
	red_str: db 10,27,"[0;31;40m"
align 8
	green_str: db 10,27,"[0;32;40m"
align 8
	yellow_str: db 27,"[0;33;40m"
align 8
	blue_str: db 27,"[0;34;40m"
align 8
	magenta_str: db 27,"[0;35;40m"
align 8
	cyan_str: db 27,"[0;36;40m"
align 8
	white_str: db 27,"[0;37;40m"
align 8
	position_str: db 27,"[6n"
