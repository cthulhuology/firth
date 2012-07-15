;; tools.asm
;;
;; © 2012 David J Göhrig
;;
;;


octal:		
	dupe		; a -- a a
	shiftrnum 3	; a a -- a a/8
	dupe		; a -- a a/8 a/8
	shiftrnum 3	; a -- a a/8 a/16
	andnum 7	; 
	addnum 48	;
	type		; a/16&7
	andnum 7	;
	addnum 48	;
	type		; a/8&7
	andnum 7	;
	addnum 48	;
	type		; a&7
	ret

hexen:
	dupe
	shiftrnum 4		; a - a a/16
	andnum 15		; a - a a/16&15
	literal 9		; a - a a/16&15 9
	more			; a - a a/16&15 flag
	method first_digit	; a - a a/16&15 flag digit
	if			; a - a a/16&15
hexen_cont:
	addnum 48		; "a"-10
	type
	andnum 15
	literal 9
	more
	method second_digit
	if
	addnum 48
	type
	ret

first_digit:
	addnum 39
	method hexen_cont
	invoke

second_digit:
	addnum 87
	type
	ret

