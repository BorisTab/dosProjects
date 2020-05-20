locals @@
.186
.model tiny

.data
Message		db "Assembler: Am I joke to you?$"

.code
org 100h

Start: 		call FillZero
			cld

			push 59d     ;cx
			push 0909h	 ;bx
			push 4d	 ;dx

ZoomFrame:	mov ah, 86h       ;wait 0.5s
			mov cx, 7h		  
			mov dx, 0a120h    
			int 15h

			pop dx
			pop bx
            pop cx
			push cx
            call Frame


			pop cx
			add cx, 2
			push cx
			add dl, 2
			dec bh
			dec bl

			push bx
			push dx
			cmp bh, 0
			ja ZoomFrame
			

			mov di, (80d*12d + 26d)*2d
			lea bx, Message
			call WriteMes
			
WaitClick:	mov ah, 00h
			mov bl, 78h
			int 16h
			cmp bl, al
			jne WaitClick 

            int 20h


;===========================================================
;Write message
;Entry:
;di - message start
;bx - pointer to message
;Destr:
;ax, bx, di, es
;===========================================================	
WriteMes	proc
			mov ax, 0b800h
			mov es, ax
			mov ah, '$'
			jmp @@check

@@Print:	stosb
			inc di
			inc bx

@@check:	mov al, byte ptr [bx]
			cmp al, ah
			jne @@Print

			ret
			endp		

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

			call nextLine

            mov al, 0bah
            mov ah, 05eh 
            stosw 

            mov al, 0
            rep stosw

            mov al, 0bah
            stosw

			call shadow

            inc dh
            cmp dh, dl
            jb @@Center
            

@@Down:     pop cx
			push cx

		    call nextLine

            mov al, 0c8h
            mov ah, 05eh 
            stosw 

            mov al, 0cdh
            rep stosw

            mov al, 0bch
            stosw

			call shadow
			pop cx

			call nextLine
			add di, 2
			add cx, 2
			mov ax, 1e00h
			rep stosw

            ret
            endp

;========================================================
;print one ceil
;========================================================
shadow		proc
			push ax
			mov ax, 1e00h
			stosw
			sub di, 2
			pop ax

			ret
			endp
;========================================================
;nextStr
;========================================================
nextLine	proc
			sub di, cx
			sub di, cx
			sub di, 4
			add di, 80d*2

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
