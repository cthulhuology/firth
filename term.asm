;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Terminal Code
;;
;;	© 2012 David J Goehrig <dave@dloh.org>
;;


call clear
call term
; we never get here

;%include "screen.asm"
%include "tools.asm"

; this is the key input display loop
term:
	key
	call test_quit
;	call test_retn
;	call test_backspace
;	call update
	jmp term		; will return

charshift: ; key count --
	zero	
	continue	; return if 0
	rpush		; save count
	shiftlnum 8	; move over once
	rpop		; restore count
	subnum 1
	method charshift
	invoke		; loop

align 16
update:	; key -- 
	call cursor
	fetch		; key -- key addr
	andnum 7	; key -- key addr&7
	call charshift	; move character over tos times
	drop
	call cursor
	fetch		; cursor address
	shiftrnum 3	; cell oriented address
	fetch		; cursor contents
	orb		; shifted key, cursor contents  -- new contents
	call cursor
	fetch		; new contents, cursor address
	shiftrnum 3	; to cell oriented address
	store
	call cursor
	fetch
	addnum 1
	call cursor
	store
	ret
	
cursor:
	offset _cursor
	ret
align 16
_cursor: dq 8000

test_quit:
	literal 17
	equals
	method done
	if
	ret

test_retn:
	literal 13
	equals
	method linefeed
	if
	ret

linefeed:
	call cursor
	fetch
	divnum 144
	addnum 1
	mulnum 144
	call cursor
	store
	ret

test_backspace:

	ret

xdone:
	jmp done
	;; never get here
	offset done_str		; done_str -> tos
	fetch			; [done_str] -> tos
	dupe
	type
	shiftrnum 8
	dupe
	type
	shiftrnum 8
	dupe
	type
	shiftrnum 8		; don't dupe after so type consumes
	type
	call eol
	quit
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

; ANSI color codes and jazz
align 8
terminal_data:
	done_str: db "done",0,0,0,0
align 8
	plain_str: db 27,"[0;0;0m"
align 8
	red_str: db 27,"[0;31;40m"
align 8
	green_str: db 27,"[0;32;40m"
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
