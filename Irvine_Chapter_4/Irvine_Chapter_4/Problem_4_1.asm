TITLE Problem 4-1

; Write a program that uses the variables below and MOV instructions to copy the value from bigEndian to littleEndian, reversing the order of the bytes.

.data
	bigEndian BYTE 12h, 34h, 56h, 78h
	littleEndian DWORD ?

.code

p41 PROC
	xor rax, rax
	xor rcx, rcx
	xor rsi, rsi
	xor rdi, rdi

	mov rsi, LENGTHOF bigEndian					; Store the length of bigEndian
	mov rcx, rsi								; The length of bigEndian is also the number of iterations we need to do
L1:
	mov al, BYTE PTR bigEndian[rcx - 1]			; rcx starts as 4, so we first index bigEndian[3], then each iteration rcx decrements, so we index bigEndian[2], bigEndian[1], and bigEndian[0]
	mov rdi, rsi
	sub rdi, rcx
	mov BYTE PTR littleEndian[rdi], al			; rsi is always 4, and rcx starts as 4, so we start by indexing littleEndian[0], then as rcx decrements we index littleEndian[1], littleEndian[2], and littleEndian[3]
	loop L1
	
	ret
p41 ENDP

end