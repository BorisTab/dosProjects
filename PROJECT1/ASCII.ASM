.model tiny
.code
org 100h

Start:		mov ah, 0eh
		mov al, 0
		mov cl, 0

TableCycle:	int 10h
		inc al
		cmp al, cl
		ja TableCycle

		int 20h

end Start
		