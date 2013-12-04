;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; net.asm
; 
; © 2013 David J. Goehrig <dave@dloh.org>
;

%macro tcp 0
	literal 1
	arg2
%endmacro

%macro udp 0 
	literal 2
	arg2
%endmacro

%macro create_socket 0
	literal 2		; PF_INET
	arg1
	literal socket		; socket syscall
	os			; fd on tos
%endmacro

%macro reuse_addr 0
	jmp .skip		; give us an int to work with inline
.flag:	dd 1
.skip:	literal 4		; sizeof .flag
	arg5
	data .flag		; 
	arg4
	literal 4		; SO_REUSEADDR
	arg3
	literal 0xffff		; SOL_SOCKET
	arg2
	arg1 			; fd off of tos
	literal setsockopt	; setsockopt syscall
	os
%endmacro			; tos 0 if successful
	
%macro bind_socket 0	
	literal 16		; sizeof sockaddr
	arg3
	arg2			; sockaddr tos
	arg1			; fd nos
	literal bind
	os
%endmacro			; tos 0 if successful

%macro listen_socket 0
	literal 255		; backlog
	arg2
	arg1			; fd on tos
	literal listen
	os
%endmacro

%macro connect_socket 0
	literal 16		; sizeof sockaddr
	arg3
	arg2			; sockaddr tos
	arg1			; fd nos
	literal connect		
	os
%endmacro

%macro send_to_socket 0
	literal 16
	arg6	
	arg5			; sockaddr tos
	literal 0
	arg4			; no flags
	arg3			; length
	arg2			; buffer
	arg1 			; fd	
	literal sendto
	os
%endmacro

%macro recv_from_socket 0
	jmp .skip
	literal 0		; null addrlen
	arg6
	literal 0		; null addr
	arg5 
	literal 0		; no flags
	arg4	
	arg3			; length tos
	arg2			; buffer nos
	arg1			; fd 
	literal recvfrom
	os
%endmacro
		
%macro send_socket 0
	literal 0
	arg4
	arg3			; length tos
	arg2			; buffer nos
	arg1			; fd
	literal send
	os
%endmacro

%macro recv_socket 0
	literal 0
	arg4
	arg3			; length tos
	arg2			; buffer nos
	arg1			; fd
	literal recv
	os
%endmacro

%macro write_socket 0
	arg3			; length tos
	arg2			; buffer nos
	arg1			; fd
	literal write
	os
%endmacro	

%macro read_socket 0
	arg3			; length tos
	arg2			; buffer nos
	arg1			; fd
	literal read
	os
%endmacro

%macro _shutdown 0
	arg1 			; fd
	literal shutdown
	os
%endmacro

%macro shutdown_read_socket 0
	literal 0
	arg2
	_shutdown
%endmacro

%macro shutdown_write_socket 0
	literal 1
	arg2
	_shutdown
%endmacro

%macro shutdown_socket 0
	literal 2
	arg2
	_shutdown
%endmacro
