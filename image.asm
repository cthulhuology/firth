;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; image.asm
;;
;;	© 2012,2013 David J. Goehrig
;;

BITS 64
ORG 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Include core macro files
%include "vm.asm"
%include "system.asm"
%include "net.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialize VM
vm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Define core words...

definition boot
nop
nop
nop
.loop: jmp .loop
end boot

;; Operating System Interface
def arg1
def arg2
def arg3
def arg4
def arg5
def arg6
def os

;; Stack Functions

def rpush
def rpop
def dupe
def nip
def drop
def stack

;; Memory Functions

def free
def compile
def alloc
def fetch
def fetchplus
def store
def storeplus
def source
def dest
def deststore
def sourcefetch

; math routines

def addition
def subtract
def multiply
def divide
def negate

; logic routines
def andb
def orb
def xorb
def notb
def shiftl
def shiftr

; test / control
def equals
def zero
def less
def more
def if
def invoke
def continue
def forever

; dictionary
def create

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants, Variables, and Values

;dictionary_last: dq word_create		;; last word in dict.asm
;dictionary_free: dq dictionary_end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The dictionary

dictionary:
;; %include "dict.asm"
dictionary_end: dq 0
