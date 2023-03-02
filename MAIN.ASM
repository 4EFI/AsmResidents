
.186
.model tiny
.code 
org 100h

locals __

include 	TOOLS.ASM 				    ; Exit

;------------------------------------------------

Start:		mov bx, 0b800h 			    ; ES = VideoSeg
			mov es, bx

            mov ah, 4eh                 ; yellow or red
            mov bx, 160d * 5 + 80d      

Next:       in  al, 60h
            mov es:[bx], ax

            add bx, 2
            and bx, 4095d

            xor cx, cx
Delay:      dec cx
            loop Delay

            cmp al, 1
            jne Next

			EXIT	

;------------------------------------------------




CmdData	db	20 dup (0)		; Cmd line data

include 	SCR_HNDL.ASM 	; Clear screen function
; include 	CMD_HNDL.ASM 	; CMD line handler
include 	STR_HNDL.ASM 	; Str handler
include 	REG_PRNT.ASM 	; Print AX in BIN/DEC/HEX	

end			Start

;------------------------------------------------
