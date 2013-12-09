;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dict.asm
;;
;; 

%macro def 1 ; word
def_%1:
%endmacro

%macro end 1 ;  word
end_%1:	
	ret
%endmacro

%macro dict 2 ; word
%strlen _len %2
align 8
word_%1:
dq def_%1		; definition address
dq end_%1 - def_%1	; definition length
dq _len			; word length
db %2 			; word

%endmacro
