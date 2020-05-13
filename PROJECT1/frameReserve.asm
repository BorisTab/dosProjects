locals @@
.186
.model tiny
.code
org 100h

Start: 		mov ax, 0b800h
			mov es, ax
			mov bx, 0
		
			mov cx, (80d*25d)*2d

; FillZero:	mov byte ptr es: [bx], 0
; 			inc bx
; 			mov byte ptr es: [bx], 05eh
; 			inc bx
; 			cmp bx, cx
; 			jb FillZero


			mov bx, (80d*14d + 26d)*2d   ;Message start

			; mov byte ptr es: [bx], 'A'
			; add bx, 2
			; mov byte ptr es: [bx], 's'
			; add bx, 2
			; mov byte ptr es: [bx], 's'
			; add bx, 2
			; mov byte ptr es: [bx], 'e'
			; add bx, 2
			; mov byte ptr es: [bx], 'm'
			; add bx, 2
			; mov byte ptr es: [bx], 'b'
			; add bx, 2
			; mov byte ptr es: [bx], 'l'
			; add bx, 2
			; mov byte ptr es: [bx], 'e'
			; add bx, 2
			; mov byte ptr es: [bx], 'r'
			; add bx, 2
			; mov byte ptr es: [bx], ':'
			; add bx, 2
			; mov byte ptr es: [bx], ' '
			; add bx, 2

			; mov byte ptr es: [bx], 'A'
			; add bx, 2
			; mov byte ptr es: [bx], 'm'
			; add bx, 2
			; mov byte ptr es: [bx], ' '
			; add bx, 2

			; mov byte ptr es: [bx], 'I'
			; add bx, 2
			; mov byte ptr es: [bx], ' '
			; add bx, 2

			; mov byte ptr es: [bx], 'j'
			; add bx, 2
			; mov byte ptr es: [bx], 'o'
			; add bx, 2
			; mov byte ptr es: [bx], 'k'
			; add bx, 2
			; mov byte ptr es: [bx], 'e'
			; add bx, 2
			; mov byte ptr es: [bx], ' '
			; add bx, 2
		
			; mov byte ptr es: [bx], 't'
			; add bx, 2
			; mov byte ptr es: [bx], 'o'
			; add bx, 2
			; mov byte ptr es: [bx], ' '
			; add bx, 2

			; mov byte ptr es: [bx], 'y'
			; add bx, 2
			; mov byte ptr es: [bx], 'o'
			; add bx, 2
			; mov byte ptr es: [bx], 'u'
			; add bx, 2
			; mov byte ptr es: [bx], '?'



            mov cx, 78d
            mov dh, 10d
			mov bx, 0700h
            call Frame

            int 20h

;===========================================================
;Draw frame on screen
;Entry: 
;cx - num repiats of central elements
;bx - left up corner (bl - x, bh - y)
;dh - num of rows
;Destr: cx, dx
;===========================================================

Frame       proc
            push cx

			mov ax, 0b800h
			mov es, ax

			mov al, 80d*2
			mul bh
			mov cl, bl
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


            mov dl, 0

@@Center:	pop cx
            push cx

            mov al, 0bah
            mov ah, 05eh 
            stosw 

            mov al, '*'
            rep stosw

            mov al, 0bah
            stosw

            inc dl
            cmp dl, dh
            jb @@Center
            

            pop cx
            ; add di, 80d*2

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
