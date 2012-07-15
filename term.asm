;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Terminal Code
;;
;;	© 2012 David J Goehrig <dave@dloh.org>
;;

call clear
call term

term:
	key
	call test_quit
	call test_retn
	type
	jmp term

test_quit:
	literal 17
	equals
	method done
	if
	ret

test_retn:
	literal 13
	equals
	method nl
	if
	ret

done:
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
