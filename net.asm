

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

%macro connect 0
	literal 16		; sizeof sockaddr
	arg3
	arg2			; sockaddr nos
	arg1			; fd tos
	literal connect		
	os
%endmacro

