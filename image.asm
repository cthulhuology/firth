;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; image.asm
;;
;;	© 2012,2013 David J. Goehrig
;;

BITS 64
ORG 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Include core macro files
%include "dict.asm"
%include "vm.asm"
%include "system.asm"
%include "net.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialize VM
vm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Define core words...

def boot
nop
nop
nop
.loop: jmp .loop
end boot

;; Operating System Interface
def arg1
arg1
end arg1

def arg2
arg2
end arg2

def arg3
arg3
end arg3

def arg4
arg4
end arg4

def arg5
arg5
end arg5

def arg6
arg6
end arg6

def os
os
end os

;; Stack Functions

def push
rpush
end push

def pop
rpop
end pop

def dup
dupe
end dup

def nip
nip
end nip

def drop
drop
end drop

def stack
stack
end stack

;; Memory Functions

def alloc
alloc
end alloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants, Variables, and Values




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The dictionary

dictionary:

; Initial boot routine
dict boot,'boot'
dict arg1,'arg1'
dict arg2,'arg2'
dict arg3,'arg3'
dict arg4,'arg4'
dict arg5,'arg5'
dict arg6,'arg6'
dict os,'os'
dict push,'push'
dict pop,'pop'
dict dup,'dup'
dict nip,'nip'
dict drop,'drop'
dict stack,'stack'
dict alloc,'alloc'
