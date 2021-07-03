TITLE Problem 4-6

; Use a loop with indirect or indexed addressing to reverse the elements of an integer array in place. Do not copy the elements to any other array.
; Use the SIZEOF, TYPE, and LENGTHOF operators to make the program as flexible as possible.

.data
	array_to_reverse BYTE 1, 2, 3, 4, 5, 6, 7, 8, 9

.code

p46 PROC
	mov bl, 2
	mov rax, LENGTHOF array_to_reverse
	div bl
	xor rcx, rcx
	mov cl, al

	mov rdi, SIZEOF array_to_reverse
	mov rsi, 0
	xor rax, rax
L1:
	mov al, array_to_reverse[rsi]
	xchg array_to_reverse[rdi - 1], al
	mov array_to_reverse[rsi], al

	add rsi, TYPE array_to_reverse
	sub rdi, TYPE array_to_reverse
	loop L1
	
	ret
p46 ENDP

end