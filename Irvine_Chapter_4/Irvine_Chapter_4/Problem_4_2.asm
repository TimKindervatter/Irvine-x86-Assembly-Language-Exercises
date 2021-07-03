TITLE Problem 4-2

; Write a program with a loop and indexed addressing tha texchanges every pair of values in an array with an even number of elements. Therefore, item i will exchange with item i+1, item i+2 will exchange with item i+3, and so on.

.data
	evenArray BYTE 1, 2, 3, 4, 5, 6, 7, 8

.code

p42 PROC
	; Determine the number of iterations, which is half the length of the array
	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx
	xor rdx, rdx
	xor rdi, rdi

	mov rdi, TYPE evenArray
	mov rax, LENGTHOF evenArray
	mov bl, 2
	div bl							; Divide the length of the array by 2

	mov rcx, rax
	mov rsi, 0

L1:
	mov bl, evenArray[rsi]
	xchg evenArray[rsi + rdi], bl
	mov evenArray[rsi], bl
	
	add rsi, rdi
	add rsi, rdi
	
	loop L1 

	ret
p42 ENDP

end