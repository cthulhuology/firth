;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; net.asm
;; 
;; © 2013 David J. Goehrig <dave@dloh.org>
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tcp selects a SOCK_STREAM

%macro tcp 0
	literal 1
	arg2
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; udp selects a SOCK_DGRAM

%macro udp 0 
	literal 2
	arg2
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; creates a socket and leave fd on top of stack

%macro create_socket 0
	literal 2		; PF_INET
	arg1
	literal socket		; socket syscall
	os			; fd on tos
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flags the socket address as reuseable, use before socket_bind

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; binds a socket to a given address, assumes IPv4
	
%macro bind_socket 0	
	literal 16		; sizeof sockaddr
	arg3
	arg2			; sockaddr tos
	arg1			; fd nos
	literal bind
	os
%endmacro			; tos 0 if successful

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; activates a inbound socket connection on the bound port, 255 connections max

%macro listen_socket 0
	literal 255		; backlog
	arg2
	arg1			; fd on tos
	literal listen
	os
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; connects the socket to the remote address

%macro connect_socket 0
	literal 16		; sizeof sockaddr
	arg3
	arg2			; sockaddr tos
	arg1			; fd nos
	literal connect		
	os
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sends data to a socket, use for udp

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; receive data from a socket, use for udp

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
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sends data to a bound socket, currently doesn't support OOB

%macro send_socket 0
	literal 0
	arg4
	arg3			; length tos
	arg2			; buffer nos
	arg1			; fd
	literal send
	os
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; receives data from a bound socket, currently doesn't support OOB

%macro recv_socket 0
	literal 0
	arg4
	arg3			; length tos
	arg2			; buffer nos
	arg1			; fd
	literal recv
	os
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; write data to a socket (or fd)

%macro write_socket 0
	arg3			; length tos
	arg2			; buffer nos
	arg1			; fd
	literal write
	os
%endmacro	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; read data from a socket (or fd)

%macro read_socket 0
	arg3			; length tos
	arg2			; buffer nos
	arg1			; fd
	literal read
	os
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; shutdown methods shutdown ro, wo, or r/w

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
