.386
.model flat, stdcall
.stack 4096

WriteString PROTO

.data
	packed1 DWORD 12345678h
	ascii1 DWORD 9 DUP(?)
.code

p73 PROC
	; Write a procedure named PackedToAsc that converts a 4-byte packed decimal integer to a string of ASCII decimal digits.
	; Pass the packed integer and the address of a buffer holding the ASCII digits to the procedure.
	; Write a short test program that passes at least 5 packed decimal integers to your procedure.
	
	mov esi, OFFSET packed1
	mov edi, OFFSET ascii1
	call PackedToAsc
	mov edx, OFFSET ascii1
	call WriteString

p73 ENDP

PackedToAsc PROC
	; Args:
	;	esi: base address of the packed decimal integer to convert to ASCII
	;	edi: base address of the location to store the converted ASCII string
	
	push eax
	push ebx
	push ecx

	xor eax, eax
	xor ebx, ebx

	add edi, 8

	mov ecx, 4
loop_head:
	mov al, [esi]			; To hold the lower nibble
	mov bl, [esi]			; To hold the upper nibble

	and al, 0Fh				; Clear the upper nibble so that it isn't included in the or operation
	shr bl, 4				; Need to shift the lower nibble out so that it isn't included in the or operation

	; Conversion to ASCII 
	or al, 30h
	or bl, 30h

	mov [edi - 1], al
	mov [edi - 2], bl

	inc esi
	sub edi, 2
	loop loop_head

	pop ecx
	pop ebx
	pop eax
	ret
PackedToAsc ENDP

end