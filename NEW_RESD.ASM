
;------------------------------------------------

X_Pos = 1           ; Regs X pos    

WidthBox  = 29d
HeightBox = 6d
ColorBox  = 79d     ; White on Red

DrawBuff        dw  WidthBox * HeightBox dup (0)
SaveBuff        dw  WidthBox * HeightBox dup (0)

BoxStrRsd       db  0
BoxDataRsd      db  X_Pos - 1, 0, WidthBox, HeightBox, ColorBox, 1

IsPrintReg      db  0

;------------------------------------------------

New08           proc

                pusha
                push ds es 

                push cs                             ; DS = CS
                pop  ds

                cmp byte ptr IsPrintReg, 0          ; if( IsPrintReg == 0 )
                je __End 

                push bx                             ; save BX
                push ax                             ; save AX

                mov  bx, 0b800h                     ; ES = VideoSeg
                mov  es, bx

                pusha                               ; Compare VideoSeg Box with DrawBuff
                xor  di, di                         ; Buff_i  = 0
                mov  si, X_Pos - 1                  ; Video_i = X_Pos - 1
                xor  cx, cx                         ; k = 0

                __Next:             mov dx, es:[si]                     ; DX = VideoSeg[i] 
                                    cmp word ptr DrawBuff[di], dx       ; if( ViedeoSeg[i] == DrawBuff[i] )
                                    je __Equal

                                    mov word ptr SaveBuff[di], dx       ; SaveBuff[i] = ViedeoSeg[i]

                                    __Equal:
                                    add di, 2                           ; Buff_i  += 2
                                    add si, 2                           ; Video_i += 2
                                    add cx, 2                           ; k += 2

                                    cmp cx, 2*WidthBox                  ; if( k == 2*W )
                                    jne __NotNewLine

                                    add si, 160d                        ; Video_i += ( 2*80 - 2*W ) 
                                    sub si, 2*WidthBox
                                    xor cx, cx                          ; k = 0 

                                    __NotNewLine:
                                    cmp di, 2 * WidthBox * HeightBox    ; if( i == 2*W * H )
                                    je __EndLoop

                                    jmp __Next
                __EndLoop:
                popa

                mov  ax, offset BoxStrRsd
                mov  bx, offset BoxDataRsd
                call PrintBox

                pop  ax                             ; load AX

                mov  bh, X_Pos                      ; (X; Y) = (X_Pos; 1)
                mov  bl, 1
                call PrintNum                       ; print AX

                pop  bx                             ; load BX 
                mov  ax, bx                         ; AX = BX
                mov  bh, X_Pos                      ; (X; Y) = (X_Pos; 2)
                mov  bl, 2
                call PrintNum                       ; print BX

                mov  ax, cx                         ; AX = CX
                mov  bh, X_Pos                      ; (X; Y) = (X_Pos; 3)
                mov  bl, 3
                call PrintNum                       ; print CX
                
                mov  ax, dx                         ; AX = CX
                mov  bh, X_Pos                      ; (X; Y) = (X_Pos; 4)
                mov  bl, 4
                call PrintNum                       ; print CX

                mov  ax, offset DrawBuff
                xor  bx, bx
                mov  ch, WidthBox
                mov  cl, HeightBox
                call BoxCpy                         ; Screen to DrawBox

                __End:

                mov al, 20h                         ; End-of-Intr
                out 20h, al

                pop es ds
                popa  

                db 0eah                             ; jmp Old_08_Seg:[Old_08_Ofs]
                Old_08_Ofs dw 0
                Old_08_Seg dw 0 

                iret
                endp

;------------------------------------------------

New09           proc   

                push ax                             ; save AX
                in   al, 60h                        ; get scan key   
                cmp  al, 3bh                        ; F1 = print regs  
                je __PrintRegs

                jmp __NoPrintRegs

                __PrintRegs:

                push ds es

                push cs                             ; DS = CS
                pop  ds

                cmp  byte ptr IsPrintReg, 0
                je __NoPaste

                push bx
                mov  bx, 0b800h                     ; ES = VideoSeg
                mov  es, bx
                pop  bx
                                          
                push ax bx cx                       
                mov  ax, offset SaveBuff
                xor  bx, bx
                mov  ch, WidthBox
                mov  cl, HeightBox
                call BoxPaste                       ; Paste screen to SaveBuff
                pop cx bx ax 

                __NoPaste:
                xor byte ptr IsPrintReg, 1h         ; set on/off flag IsPrintReg

                in  al, 61h                         ; Signal keyboard
                or  al, 80h
                out 61h, al
                and al, not 80h             
                out 61h, al

                mov al, 20h                         ; End-of-Intr
                out 20h, al

                pop es ds

                pop ax                              ; load AX
                iret 
                
                __NoPrintRegs:

                pop  ax                             ; load AX  

                db 0eah                             ; jmp Old_09_Seg:[Old_09_Ofs]
                Old_09_Ofs dw 0
                Old_09_Seg dw 0  

                iret
                endp

;------------------------------------------------