
read_keys:
	key
	call term_quit
	call term_red
	call term_green
	call term_normal
	call term_return
	call term_delete
	type
	jmp read_keys

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
	cmp rax,20
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
	eol
	pop rdx
	jmp read_keys
.done:	ret

term_delete:
	cmp rax,127
	jne .done
	mov rax,8
.done:	ret

# ANSI color codes and jazz
plain: db 27,"[0;0;0m"
red: db 27,"[0;31;40m"
green: db 27,"[0;32;40m"
yellow: db 27,"[0;33;40m"
blue: db 27,"[0;34;40m"
magenta: db 27,"[0;35;40m"
cyan: db 27,"[0;36;40m"
white: db 27,"[0;37;40m"
