
.286
.model tiny
.code 
org 100h

locals __

include 	    ../TOOLS.ASM 	        ; Exit

;------------------------------------------------

Start:          mov ax, 1111h
                mov bx, 2222h
                mov cx, 3333h
                mov dx, 4444h

                __Next:     ; push ax
                            in   al, 60h  
                            cmp  al, 01h
                            ; pop  ax
                            jne __Next                  

                EXIT

end             Start

;------------------------------------------------