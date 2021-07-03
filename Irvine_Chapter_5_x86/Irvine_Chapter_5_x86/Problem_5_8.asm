TITLE Problem 5-8

.386
.model flat, stdcall
.stack 4096

SetTextColor PROTO
WriteChar PROTO
Crlf PROTO

.data

.code

p58 PROC
	; Write a program that displays a single character in all possible combinations of foreground and background colors (16 x 16 = 256).
	
	mov esi, 16			; Outer loop counter
outer:
	dec esi
	mov edi, 16			; Inner loop counter
inner:
	dec edi

	mov eax, esi		; Foreground color
	mov ebx, edi		; Background color
	shl ebx, 4			; Background color must be multiplied by 16
	add eax, ebx		; Both colors stored in eax for use in SetTextColor
	
	call SetTextColor

	mov al, '$'
	call WriteChar
	
	cmp edi, 0
	jnz inner

	call Crlf

	cmp esi, 0
	jnz outer
	
	ret
p58 ENDP

end