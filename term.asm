;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Terminal Code
;;
;;	© 2012 David J Goehrig <dave@dloh.org>
;;

call clear
call read_keys

done:
	show done_str,6
	ret

eol:
	show nl,2
	ret

space:
	show wsp,1
	ret

clear:
	show clr,2
	ret

emit:
	mov r11,10		; radix
	zero number,20		; clear buffer
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
	show number,20		; null characters don't write!!!!
	ret

hexen:
	mov r11,16
	zero number,20
	mov rcx,20
.hexen:
	xor rdx,rdx
	idiv r11
	cmp rdx,10
	jl .lessthanten
	add rdx,39	
.lessthanten:
	add rdx,48
	mov byte [ r13 + number + rcx - 1],dl
	test rax,rax
	jz .done
	loopnz .hexen
.done:
	show number,20
	ret
	
key:
	mov r10,[r13+tibc]	; copy the count
	lea r11,[r13+tib]	; get the input buffer
	add r11,r10		; and offset into 
	keys r11,1		; write stdin to tib
	offset r11		; and fetch what we just wrote
	fetchc			; leave the 
	add r10,1		; increment count
	mov [r13+tibc],r10	; and update
	ret

type:
	offset tib
	storec
	show tib,1
	ret

read_keys:
	call key
	call term_pos
	call term_quit
	call term_red
	call term_green
	call term_normal
	call term_return
	call term_delete
	call type
	jmp read_keys

term_pos:
	cmp rax,20
	jne term_pos_done
	show position,4
	call key			; dump esc
	call emit
term_pos_done:	ret

term_quit:
	cmp rax,17
	jne .done
	quit
.done:	ret

term_red:
	cmp rax,18
	jne .done
	show red,10
	pop rdx
	jmp read_keys
.done:	ret

term_green:
	cmp rax,7
	jne .done
	show green,10
	pop rdx
	jmp read_keys
.done:	ret

term_normal:
	cmp rax,14
	jne .done
	show plain,8
	pop rdx
	jmp read_keys
.done:	ret

term_return:
	cmp rax,13
	jne .done
	call eol
	pop rdx
	jmp read_keys
.done:	ret

term_delete:
	cmp rax,127
	jne .done
	mov rax,8
.done:	ret

# ANSI color codes and jazz
terminal_data:
	number: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	tibc: dq 0
	tib: dq 0,0,0,0,0
	done_str: db "done"
	nl: db 0xd,0xa
	wsp: db 0x20
	clr: db 27,99
	plain: db 27,"[0;0;0m"
	red: db 27,"[0;31;40m"
	green: db 27,"[0;32;40m"
	yellow: db 27,"[0;33;40m"
	blue: db 27,"[0;34;40m"
	magenta: db 27,"[0;35;40m"
	cyan: db 27,"[0;36;40m"
	white: db 27,"[0;37;40m"
	position: db 27,"[6n"
