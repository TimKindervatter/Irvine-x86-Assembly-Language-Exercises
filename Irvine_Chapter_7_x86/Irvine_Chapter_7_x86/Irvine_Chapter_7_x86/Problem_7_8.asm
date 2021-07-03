.386
.model flat, stdcall
.stack 4096

.data
	ALIGN 4
	packed1a DWORD 50000000h
	packed1b DWORD 50000000h
	SUM_SIZE1 = SIZEOF packed1a + 1
	sum1 BYTE SUM_SIZE1 DUP(?)

	ALIGN 4
	packed2a QWORD 5555555555555555h
	packed2b QWORD 3333333333333333h
	SUM_SIZE2 = SIZEOF packed2a + 1
	sum2 BYTE SUM_SIZE2 DUP(?)

	ALIGN 4
	packed3a QWORD 4242424242424242h, 4242424242424242h
	packed3b QWORD 4242424242424242h, 4242424242424242h
	SUM_SIZE3 = SIZEOF packed3a + 1
	sum3 BYTE SUM_SIZE3 DUP(?)
.code

p78 PROC
	; Extend the AddPacked procedure from Section 7.6.1 so that it adds two packed decimal integers of arbitrary size (both lengths must be the same).
	; Write a test program that passes AddPacked several pairs of integers: 4-byte, 8-byte, and 16-byte.

	mov esi, OFFSET packed1a
	mov edi, OFFSET packed1b
	mov edx, OFFSET sum1
	mov ecx, SIZEOF packed1a
	call AddPacked

	mov esi, OFFSET packed2a
	mov edi, OFFSET packed2b
	mov edx, OFFSET sum2
	mov ecx, SIZEOF packed2a
	call AddPacked

	mov esi, OFFSET packed3a
	mov edi, OFFSET packed3b
	mov edx, OFFSET sum3
	mov ecx, SIZEOF packed3a
	call AddPacked

	ret
p78 ENDP

AddPacked PROC
	; Args:
	;	esi: pointer to the first number
	;	edi: pointer to the second number
	;	edx: pointer to the sum
	;	ecx: number of bytes to add

	clc									; Clear the carry flag so that the sum of the lowest bytes does not have a carry bit included
loop_head:
	mov al, BYTE PTR [esi]
	adc al, BYTE PTR [edi]
	daa
	mov BYTE PTR [edx], al

	inc esi
	inc edi
	inc edx
	loop loop_head

	; Add final carry, if any
	mov al, 0
	adc al, 0
	mov BYTE PTR [edx], al
	
	ret
AddPacked ENDP

end