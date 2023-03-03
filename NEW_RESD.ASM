
IsPrintReg      db  0

New08           proc

                push ax bx cx dx 
                push es   

                push bx                     ; save BX

                mov  bx, 0b800h             ; ES = VideoSeg
                mov  es, bx
                
                mov  bh, 0                  ; (X; Y) = (0; 0)
                mov  bl, 0                  
                call PrintNum               ; print AX

                pop bx                      ; load BX 
                mov  ax, bx                 ; AX = BX
                mov  bh, 0                  ; (X; Y) = (0; 1)
                mov  bl, 1
                call PrintNum               ; print BX

                mov al, 20h                 ; End-of-Intr
                out 20h, al

                pop es
                pop dx cx bx ax  

                db 0eah                     ; jmp Old_08_Seg:[Old_08_Ofs]
                Old_08_Ofs dw 0
                Old_08_Seg dw 0 

                iret
                endp

New09           proc   

                push ax                     ; save AX
                in   al, 60h                ; get scan key   
                cmp  al, 3bh                ; F1 check code        
                jne   __NoPrintRegs

                xor  IsPrintReg, 01h        ; On/Off flag

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
