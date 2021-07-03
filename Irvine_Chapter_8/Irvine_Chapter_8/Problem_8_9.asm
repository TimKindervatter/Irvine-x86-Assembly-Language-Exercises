.386
.model flat, stdcall
.stack 4096

CountNearMatches PROTO,
	array1: PTR SDWORD,
	array2: PTR SDWORD,
	array_size: DWORD,
	diff: DWORD

.data
	p88_array1_size = 5
	p88_array1 SDWORD 1, 2, 3, 4, 5
	p88_array2 SDWORD -1, -1, -1, -1, -1
.code

p89 PROC
; Write a procedure named CountNearMatches that receives pointers to two arrays to signed doublewords, a parameter that indicates the length of the two arrays, 
; and a parameter called diff that indicates the maximum allowed difference between andy two matching elements.
; For each element xi in the first array and corresopnding yi in the second array, if the difference xi - yi is less than diff, increment a count. At the end, return a count of the number of matching array elements in EAX.
; Write a test program that calls your procedure and passes pointers to two different pairs of arrays.
; Use the INVOKE statement to call your procedure and pass stack parameters.
; Create a PROTO declaration for CountMatches. Save and restore any registers (other than EAX) that are changed by your procedure.

	INVOKE CountNearMatches, OFFSET p88_array1, OFFSET p88_array2, p88_array1_size, 5
	INVOKE CountNearMatches, OFFSET p88_array1, OFFSET p88_array2, p88_array1_size, 10
	INVOKE CountNearMatches, OFFSET p88_array1, OFFSET p88_array2, p88_array1_size, 1

	INVOKE CountNearMatches, OFFSET p88_array2, OFFSET p88_array1, p88_array1_size, 5
	INVOKE CountNearMatches, OFFSET p88_array2, OFFSET p88_array1, p88_array1_size, 10
	INVOKE CountNearMatches, OFFSET p88_array2, OFFSET p88_array1, p88_array1_size, 1

	ret
p89 ENDP

CountNearMatches PROC USES ecx edx esi edi,
	array1: PTR SDWORD,
	array2: PTR SDWORD,
	array_size: DWORD,
	diff: DWORD

	xor eax, eax
	mov ecx, array_size
	mov esi, array1
	mov edi, array2
loop_head:
	mov edx, [esi]
	sub edx, [edi]
	cmp edx, diff
	jge difference_too_large
	inc eax
difference_too_large:
	add esi, TYPE DWORD
	add edi, TYPE DWORD
	loop loop_head

	ret
CountNearMatches ENDP

end