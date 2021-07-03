.386
.model flat, stdcall
.stack 4096

CountMatches PROTO,
	array1: PTR SDWORD,
	array2: PTR SDWORD,
	array_size: DWORD

.data
	p88_array1_size = 5
	p88_array1 SDWORD -1, 2, -3, 4, -5
	p88_array2 SDWORD -1, 2, 82, 4, -5
	p88_array3 SDWORD 1, 2, 3, 4, 5
.code

p88 PROC
; Write a procedure named CountMatches that receives pointers to two arrays to signed doublewords and a third parameter that indicates the length of the two arrays.
; For each element xi in the first array, if the corresopnding yi in the second array is equal, increment a count. At the end, return a count of the number of matching array elements in EAX.
; Write a test program that calls your procedure and passes pointers to two different pairs of arrays.
; Use the INVOKE statement to call your procedure and pass stack parameters.
; Create a PROTO declaration for CountMatches. Save and restore any registers (other than EAX) that are changed by your procedure.

	INVOKE CountMatches, OFFSET p88_array1, OFFSET p88_array2, p88_array1_size
	INVOKE CountMatches, OFFSET p88_array1, OFFSET p88_array3, p88_array1_size

	ret
p88 ENDP

CountMatches PROC USES ecx edx esi edi,
	array1: PTR SDWORD,
	array2: PTR SDWORD,
	array_size: DWORD

	xor eax, eax
	mov ecx, array_size
	mov esi, array1
	mov edi, array2
loop_head:
	mov edx, [edi]
	cmp [esi], edx
	jne not_equal
	inc eax
not_equal:
	add esi, TYPE DWORD
	add edi, TYPE DWORD
	loop loop_head

	ret
CountMatches ENDP

end