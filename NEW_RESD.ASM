
New09           proc

                push ax bx di es            ; push (1) (2) (3) (4)

                push ax                     ; push (5)

                mov bx, 0b800h              ; ES = VideoSeg
                mov es, bx
                mov ah, 4eh                 ; AH = yellow on red
                mov bx, 160d * 5 + 80d      ; BX = (40; 5) pos on screen

                in  al, 60h                 ; get scan key           
                mov di, ax
                mov cl, ah

                pop ax                      ; pop  (5)

                mov ax, di
                in al, 61h
                or al, 80h
                out 61h, al
                and al, not 80h
                out 61h, al

                mov al, 20h
                out 20h, al

                pop es di bx ax             ; pop  (4) (3) (2) (1) 

                db 0eah                     ; jmp Old_09_Seg:[Old_09_Ofs]
                Old_09_Ofs dw ?
                Old_09_Seg dw ?

                iret
                endp
