locals @@
.186
.model tiny

.data
Buffer:     db "qwertyandzxcv$"
Buffer2:    db "qwertybbbbbbb$"

.code
org 100h

Start:              
            lea si, Buffer2
            lea di, Buffer
            mov cx, 14
            call Memcmp
            mov ah, 0fh

            mov dx, 0b800h
            mov es, dx
            mov di, (80d*12d + 40d)*2
            stosw
            
            int 20h

;========================================================
;Memchr func from C
;
;Entry:
;di - pointer to buffer
;al - character
;cx - max number of characters to examine
;
;Exit:
;di - pointer to character
;Destr:
;al, cx, di
;========================================================
Memchr      proc
            cld
            repne scasb
            jne @@NotFound
            dec di
            ret

@@NotFound: mov di, 0 
            ret
            endp

;========================================================
;Memcmp func from C
;
;Entry:
;si - pointer to buffer1
;di - pointer to buffer2
;cx - max number of characters to compare
;
;Exit:
;al > 0 if si > di
;al = 0 if si = di
;al < 0 if si < di
;Destr:
;cx, di, si
;========================================================
Memcmp      proc
            cld
            repe cmpsb

            mov al, [si - 1]
            sub al, [di - 1]
            ret
            endp

;========================================================
;Memset func from C
;
;Entry:
;di - pointer to buffer
;al - char to set
;cx - number of char to set
;
;Exit:
;bx - pointer to buffer
;Destr:
;cx, al
;========================================================
Memset      proc
            mov bx, di
            cld
            rep stosb

            ret
            endp

;========================================================
;Memcpy func from C
;
;Entry:
;di - pointer to destination
;si - ponter to source
;cx - number of characters to copy
;
;Exit:
;bx - pointer to destination
;Destr:
;cx, di, si
;========================================================
Memcpy      proc
            mov bx, di
            cld
            rep movsb

            ret
            endp

;========================================================
;Strlen func from C
;
;Entry:
;di - pointer to string
;
;Exit:
;bx - buffer len
;Destr:
;cx, di, al
;========================================================
Strlen      proc
            mov cx, 0ffffh
            mov bx, cx
            mov al, '$'
            cld
            repne scasb
            sub bx, cx

            ret
            endp

;========================================================
;Strchr func from C
;
;Entry:
;di - pointer to string
;ah - char to find
;
;Exit:
;di - pointer to char
;Destr:
;di, al
;========================================================
Strchr      proc
            mov bl, '$'
            cld
@@find:     lodsb
            cmp bl, al
            je @@NotFound
            cmp ah, al
            loopne @@find
            ret

@@NotFound: mov di, 0
            ret
            endp

;========================================================
;Strcpy func from C
;
;Entry:
;di - pointer to destination
;si - ponter to source
;
;Exit:
;bx - pointer to destination
;Destr:
;di, si, al
;========================================================
Strcpy      proc
            mov al, '$'
            mov bx, di
            cld
@@copy:     scasb
            movsb
            loopne @@copy

            ret
            endp


;========================================================
;Strcmp func from C
;
;Entry:
;si - pointer to str1
;di - pointer to str2
;
;Exit:
;ah > 0 if si > di
;ah = 0 if si = di
;ah < 0 if si < di
;Destr:
;di, si, al
;========================================================
Strcmp      proc
            mov bl, '$'
            cld

@@compare:  cmpsb
            jne @@endCmp
            dec si
            lodsb
            cmp bl, al
            je @@endCmp

@@endCmp:   mov ah, [si - 1]
            sub ah, [di - 1]
            ret
            endp




;========================================================
;Fill screen with zero
;
;Destr:
;ax, es, bx, cx
;========================================================
FillZero    proc
            mov ax, 0b800h
			mov es, ax
			mov bx, 0
		
			mov cx, (80d*25d)*2d
@@Fill: 	mov byte ptr es: [bx], 0
			inc bx
			mov byte ptr es: [bx], 0
			inc bx
			cmp bx, cx
			jb @@Fill
            ret

            endp



end Start   
