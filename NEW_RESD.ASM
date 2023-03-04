
BoxStrRsd       db  0
BoxDataRsd      db  0, 0, 29d, 6, 79d, 1

IsPrintReg      db  0

X_Pos = 1   

New08           proc

                push ax bx cx dx 
                push si ds es 

                push bx                     ; DS = CS
                mov  bx, cs
                mov  ds, bx
                pop  bx

                cmp byte ptr IsPrintReg, 0
                je __End 

                push bx                     ; save BX
                push ax                     ; save AX

                mov  bx, 0b800h             ; ES = VideoSeg
                mov  es, bx

                ; mov  si, offset 
                mov  ax, offset BoxStrRsd
                mov  bx, offset BoxDataRsd
                call PrintBox

                pop  ax                     ; load AX

                mov  bh, X_Pos              ; (X; Y) = (X_Pos; 1)
                mov  bl, 1                  
                call PrintNum               ; print AX

                pop  bx                     ; load BX 
                mov  ax, bx                 ; AX = BX
                mov  bh, X_Pos              ; (X; Y) = (X_Pos; 2)
                mov  bl, 2
                call PrintNum               ; print BX

                mov  ax, cx                 ; AX = CX
                mov  bh, X_Pos              ; (X; Y) = (X_Pos; 3)
                mov  bl, 3
                call PrintNum               ; print CX
                
                mov  ax, dx                 ; AX = CX
                mov  bh, X_Pos              ; (X; Y) = (X_Pos; 4)
                mov  bl, 4
                call PrintNum               ; print CX

                __End:

                mov al, 20h                 ; End-of-Intr
                out 20h, al

                pop es ds si
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

                push ds

                push bx                     ; DS = CS
                mov  bx, cs
                mov  ds, bx
                pop  bx
                
                xor  byte ptr IsPrintReg, 1h

                in  al, 61h                 ; Signal keyboard
                or  al, 80h
                out 61h, al
                and al, not 80h             
                out 61h, al

                mov al, 20h                 ; End-of-Intr
                out 20h, al

                pop ds

                pop ax                      ; load AX
                iret 
                
                __NoPrintRegs:

                pop  ax                     ; losd AX  

                db 0eah                     ; jmp Old_09_Seg:[Old_09_Ofs]
                Old_09_Ofs dw 0
                Old_09_Seg dw 0  

                iret
                endp
