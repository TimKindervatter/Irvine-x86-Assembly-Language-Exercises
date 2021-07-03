TITLE Problem 4-4

; Write a program that uses a loop to copy all the elements from an unsigned Word (16-bit) array into an unsigned doubleword (32-bit) array.

.data
	wArray WORD 10h, 20h, 30h, 40h, 50h
	ALIGN 8
	dwArray DWORD ?

.code

p44 PROC
	xor rbx, rbx
	mov rcx, LENGTHOF wArray
	xor rsi, rsi
	xor rsi, rsi
L1:
	mov bx, wArray[rsi]
	mov dwArray[rdi], ebx

	add rsi, TYPE wArray
	add rdi, TYPE dwArray
	
	loop L1
p44 ENDP

end