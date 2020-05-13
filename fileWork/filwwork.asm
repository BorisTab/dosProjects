locals @@
.model tiny

.code
org 100h

Start:
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
            int 21h


;=====================================================
;int 28h 
;write file
;=====================================================
clearFileWrite proc
            pushf
            call cs:sysHandler28
            push ax bx cx dx ds es di

            mov ax, cs
            mov ds, ax
            
            mov ah, 3dh
            mov al, 1
            mov dx, offset logPath
            int 21h

            mov fileHandle, ax

            mov ah, 42h
            mov bx, fileHandle
            mov al, 2
            mov cx, 0
            mov dx, 0
            int 21h
            
            mov ah, 40h
            mov cx, 6d
            mov dx, offset wrBuf
            int 21h

            mov ah, 3eh
            int 21h

            pop  di es ds dx cx bx ax
            iret
            endp

.data
Data:
logPath     db "s:\doc\projects\keyloger\key.log", 0
wrBuf       db "Hello!"
sysHandler28  dd ? 
fileHandle  dw ?
dsss       dw ? 

EndInt:
end Start