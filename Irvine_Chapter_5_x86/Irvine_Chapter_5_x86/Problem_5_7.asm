TITLE Problem 5-7

.386
.model flat, stdcall
.stack 4096

Gotoxy PROTO
GetMaxXY PROTO
RandomRange PROTO
WriteChar PROTO
Delay PROTO
SetTextColor PROTO

.data
	rows BYTE ?
	cols BYTE ?
.code

p57 PROC
	; Write a program that displays a single character at 100 random screen locations, using a timing delay of 100 milliseconds
	
	call GetMaxXY
	mov [rows], al					; Store the randomly generated x position for later use
	mov [cols], dl					; edx holds the number of columns, move it to eax for use by RandomRange

	mov ecx, 1000

L1:
	xor edx, edx					; Clear edx for later use by Gotoxy
	xor eax, eax

	mov al, [rows]
	call RandomRange				; eax already holds the number of rows, so produce a random x position using that value
	mov dh, al						; eax holds the result from the call to RandomRange, store the randomly generated x position in dh

	mov al, [cols]
	call RandomRange				; Generate a random y position
	mov dl, al						; eax holds the result from the call to RandomRange, store the randomly generated y position in dl

	call Gotoxy

	mov eax, 16
	call RandomRange
	call SetTextColor
	
	mov al, '$'
	call WriteChar
	
	mov eax, 10
	call Delay

	loop L1

	ret
p57 ENDP

end