TITLE Problem 6-2

.386
.model flat, stdcall
.stack 4096

.data
	p62_array SDWORD -20h, 10h, 15h, -10h, -17h, 0h, 11h, 5h, -3h, -2h
.code

p62 PROC
	; Create a procedure that returns the sum of all array elements falling within the range j..k (inclusive).
	; Write a test program that calls the procedure twice, passing a pointer to a signed doubleword array, the size of the array, and the values of j an dk.
	; Return the sum in the EAX register, and preserve all other register values between calls to the procedure.

; ------------------------------------------------------------------
; Args:
;	esi: Contains the base address of the array
;	ebx: Contains j, the lower bound of the range
;	edx: Contains k, the upper bound of the range
;	ecx: Contains the length of the array
; Returns:
;	eax: Sum of array elements in the interval [j, k]
; ------------------------------------------------------------------
	push edi

	xor eax, eax
loop_head:
	mov edi, [esi]			; Move current element into register to avoid repeated memory accesses
	cmp edi, ebx
	jl skip					; If the current element is below j, don't add this element to the running total
	cmp edi, edx
	jg skip					; If the current element is above k, don't add this element to the running total
	
	add eax, edi			; If we've gotten here, then the current element is in the interval [j, k], so add it to the running total
skip:
	add esi, TYPE p62_array
	loop loop_head

	pop edi
	ret
p62 ENDP

p62_test PROC
	mov ebx, -15h
	mov edx, 15h
	mov esi, OFFSET p62_array
	mov ecx, LENGTHOF p62_array
	call p62

	mov ebx, -10h
	mov edx, 10h
	mov esi, OFFSET p62_array
	mov ecx, LENGTHOF p62_array
	call p62

	ret
p62_test ENDP

end