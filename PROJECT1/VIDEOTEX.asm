.model tiny
.code
org 100h

Start: 		mov ax, 0b800h
			mov es, ax
			mov bx, 0
		
			mov cx, (80d*25d)*2d

FillZero:	mov byte ptr es: [bx], 0
			inc bx
			mov byte ptr es: [bx], 05eh
			inc bx
			cmp bx, cx
			jb FillZero


			mov di, (80d*14d + 26d)*2d   ;Message start

			mov ah, '$'
			lea bx, Message
			mov al, byte ptr [bx]
Print:		stosb
			inc di
			inc bx
			mov al, byte ptr [bx]
			cmp al, ah
			jne Print



			int 20h

.data
Message		db "Assembler: Am I joke to you?$"

end Start

