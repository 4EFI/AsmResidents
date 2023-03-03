
.286
.model tiny
.code 
org 100h

locals __

include 	    TOOLS.ASM 				    ; Exit

;------------------------------------------------

Start:          cli                         ; START NO-INTR

                xor bx, bx                  ; ES = 0
                mov es, bx

                mov bx, 4d * 9d             ; BX = 4*9 (9th Intr)

                mov ax, es:[bx]             ; Old_09_Ofs = 0:[4*9]
                mov Old_09_Ofs, ax

                mov es:[bx], offset New09   ; 0:[4*9] = New_Intr_Func_Ofs

                mov ax, es:[bx + 2]         ; Old_09_Seg = 0:[4*9 + 2]
                mov Old_09_Seg, ax

                mov ax, cs
                mov es:[bx + 2], ax         ; 0:[4*9 + 2] = New_Intr_Func_Seg

                sti                         ; END NO-INTR

                mov ax, 3100h               ; EXIT with saving
                mov dx, offset EOP
                shr dx, 4
                inc dx
                int 21h	

;------------------------------------------------

include     NEW_RESD.ASM

CmdData	db	20 dup (0)		; Cmd line data

include 	SCR_HNDL.ASM 	; Clear screen function
; include 	CMD_HNDL.ASM 	; CMD line handler
include 	STR_HNDL.ASM 	; Str handler
include 	REG_PRNT.ASM 	; Print AX in BIN/DEC/HEX	

EOP:

end			Start

;------------------------------------------------
