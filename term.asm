;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Terminal Code
;;
;;	© 2012 David J Goehrig <dave@dloh.org>
;;

call clear
call done
quit

done:
	offset done_str		; done_str -> tos
	source			; tos <-> src
	fetchplus
	type
	fetchplus
	type
	fetchplus
	type
	fetchplus
	type
	call eol
	source
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

emit:
	mov r11,10		; radix
	mov rcx,20
.emit:
	xor rdx,rdx		; make sure we don't get junk
	idiv r11		; divide by radix
	add dl,48		; add ascii 0
	mov byte [ r13 + number + rcx - 1 ],dl	; move to slot
	test rax,rax		; if we've run out of data
	jz .done		; quit
	loopnz .emit		; otherwise do next loop
.done:
	literal 20
	offset number
	show			; null characters don't write!!!!
	ret

hexen:
	mov r11,16
	mov rcx,16
.hexen:
	xor rdx,rdx
	idiv r11
	cmp rdx,10
	jl .lessthanten
	add rdx,39	
.lessthanten:
	add rdx,48
	mov byte [ r13 + number + rcx - 1],dl
	test rcx,rcx
	loopnz .hexen
.done:
	literal 20
	offset number
	show
	ret


; ANSI color codes and jazz
align 16
terminal_data:
	number: dq 0,0,0
	tibcnt: dq 0
	tibbuf: dq 0,0,0,0,0
	done_str: dq "d","o","n","e"
	plain: db 27,"[0;0;0m"
	red: db 27,"[0;31;40m"
	green: db 27,"[0;32;40m"
	yellow: db 27,"[0;33;40m"
	blue: db 27,"[0;34;40m"
	magenta: db 27,"[0;35;40m"
	cyan: db 27,"[0;36;40m"
	white: db 27,"[0;37;40m"
	position: db 27,"[6n"
