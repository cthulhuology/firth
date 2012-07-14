;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	call tib
	mov qword [rax],0	; clear the tib 
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
	show number,20
	ret

tib:
	dupe
	lea r11,[r13+lexicon]	; get the address of the top word
	mov r10,[r11+8]		; grab the count
	shr r10,3
	add r10,3
	shl r10,3		; get the aligned after the count
	lea rax,[r11+r10]	; get the address of the free word
	ret

tibc:
	call tib
	mov rax,[rax]		; load the count
	ret

tibcplus:
	call tib
	add qword [rax],1
	drop
	ret

tibfree:
	call tib		; base offset
	call tibc		; count
	addition		; +
	addnum 8		; skip the count 
	ret

key:
	call tibfree		; get the free address in tos
	dupe
	dupe
	call hexen
	call space
	drop
	mov r11,rax		; keys overwrites rax
	keys r11,1		; write stdin to tibfree
	drop
	fetchc
	jmp tibcplus		; increment the tibc count

type:
	call tibfree
	subnum 1
	mov r11,rax
	putc r11
	call space
	ret

read_keys:
	lea rax,[r13+end_of_lexicon]
	call hexen
	call space
	lea rax,[r13+lexicon]
	call hexen
	call space
	drop
	call key
	dupe
	call hexen
	call space
	drop
	drop
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
	tibcnt: dq 0
	tibbuf: dq 0,0,0,0,0
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
