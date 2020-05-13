locals @@
.model tiny
.data
sysHandler  dd 0
freqE       dw 5274d
freqC       dw 4186d
freqD       dw 4698d    
scanCode    db 0

.code
org 100h

Start:
            mov ah, 35h
            mov al, 09h
            int 21h
            mov word ptr sysHandler, bx
            mov word ptr sysHandler + 2, es

            mov ah, 25h
            mov al, 09h
            mov dx, offset NewKeyboardInt
            int 21h

            mov ax, 3100h
            mov dx, offset EndInt
            int 21h

;=============================================================
;My keyboard interrupt
;
;=============================================================
NewKeyboardInt proc
            pushf
            call cs:sysHandler
            push ax di es

            in al, 60h
            add scanCode, 128d
            cmp al, scanCode
            je @@SoundOff
            mov scanCode, al

            ;расчёт коэффициента деления: c = 1193180 Гц / f
            mov ax,34dch  ;dx:ax = 1193180
            mov dx,12h

            cmp scanCode, 12h
            je @@noteE

            cmp scanCode, 2eh
            je @@noteC

            ; cmp scanCode, 20h
            ; je @@noteD

            jmp @@exit
        
@@noteE:    div freqE
            jmp @@setTimer

@@noteC:    div freqC
            jmp @@setTimer   

; @@noteD:    div freqD
            ; jmp @@setTimer           

@@setTimer: mov dx, ax
            mov al, 0b6h
            out 43h, al
            mov al, dl
            out 42h, al
            mov al, dh
            out 42h, al

@@SoundOn:  in al, 61h
            or al, 3
            out 61h, al
            jmp @@exit

@@SoundOff: in al, 61h
            and al, 2
            out 61h, al

@@exit:     in al, 61h
            mov ah, al
            or al, 80h
            out 61h, al
            xchg ah, al
            out 61h, al

            mov al, 20h
            out 20h, al

            pop es di ax
            iret
            endp
EndInt:

;===========================================================
;Draw frame on screen
;Entry: 
;cx - num repiats of central elements
;bx - left up corner (bl - x, bh - y)
;dl - num of rows
;Destr: cx, dx, ax, es, di, bx
;===========================================================

Frame       proc
            push cx

			mov ax, 0b800h
			mov es, ax

			mov al, 80d*2
			mul bh
			mov cl, bl
			add cl, bl
			add ax, cx
            mov di, ax

			pop cx
			push cx

            mov al, 0c9h
            mov ah, 05eh 
            stosw 

            mov al, 0cdh
            rep stosw

            mov al, 0bbh
            stosw


            mov dh, 0

@@Center:	pop cx
            push cx

			sub di, cx
			sub di, cx
			sub di, 4
			add di, 80d*2

            mov al, 0bah
            mov ah, 05eh 
            stosw 

            mov al, 0
            rep stosw

            mov al, 0bah
            stosw

            inc dh
            cmp dh, dl
            jb @@Center
            

            pop cx

            sub di, cx
			sub di, cx
			sub di, 4
			add di, 80d*2

            mov al, 0c8h
            mov ah, 05eh 
            stosw 

            mov al, 0cdh
            rep stosw

            mov al, 0bch
            stosw


            ret
            endp

end Start