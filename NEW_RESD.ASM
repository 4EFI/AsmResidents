
IsPrintReg      db  0

; X_Pos = 2   

New08           proc

                push ax bx cx dx 
                push si es 

                mov  si, 4*8 + 2             ; ES = CurrProgSeg
                mov  bx, [si]
                xchg bh, bl
                mov  es, bx
                mov  bx, offset IsPrintReg 
                cmp  byte ptr es:[bx], 0
                je __End 

                push bx                     ; save BX

                mov  bx, 0b800h             ; ES = VideoSeg
                mov  es, bx

                mov  bh, 0                  ; (X; Y) = (0; 0)
                mov  bl, 0                  
                call PrintNum               ; print AX

                pop  bx                     ; load BX 
                mov  ax, bx                 ; AX = BX
                mov  bh, 0                  ; (X; Y) = (0; 1)
                mov  bl, 1
                call PrintNum               ; print BX

                __End:

                pop es si
                pop dx cx bx ax  

                db 0eah                     ; jmp Old_08_Seg:[Old_08_Ofs]
                Old_08_Ofs dw 0
                Old_08_Seg dw 0 

                iret
                endp

New09           proc   

                push ax                     ; save AX
                in   al, 60h                ; get scan key   
                cmp  al, 3bh                ; F1 = print regs  
                je __PrintRegs

                jmp __NoPrintRegs

                __PrintRegs:

                push bx si es
                mov  si, 4*9 + 2             ; ES = CurrProgSeg
                mov  bx, [si]
                xchg bh, bl
                mov  es, bx
                mov  bx, offset IsPrintReg 
                xor  byte ptr es:[bx], 1             ; On/Off flag
                pop  es si bx

                in  al, 61h                 ; Signal keyboard
                or  al, 80h
                out 61h, al
                and al, not 80h             
                out 61h, al

                mov al, 20h                 ; End-of-Intr
                out 20h, al

                pop ax                      ; load AX
                iret 
                
                __NoPrintRegs:

                pop  ax                     ; losd AX  

                db 0eah                     ; jmp Old_09_Seg:[Old_09_Ofs]
                Old_09_Ofs dw 0
                Old_09_Seg dw 0  

                iret
                endp
