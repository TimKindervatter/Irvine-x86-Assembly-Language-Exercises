.386
.model flat, stdcall
.stack 4096

Random32 PROTO

CreateRandomArray PROTO,
	array_pointer:PTR DWORD,
	array_size:DWORD

SwapConsecutivePairs PROTO,
	array_pointer:PTR DWORD,
	array_size:DWORD

Swap PROTO,
	pValX:PTR DWORD,
	pValY:PTR DWORD

.data
	p85_array_size = 20
	p85_array DWORD p85_array_size DUP(?)

	p85_array2_size = 5
	p85_array2 DWORD p85_array_size DUP(?)
.code

p86 PROC
; Create an array of randomly ordered integers. Using the swap procedure from Secion 8.4.6 as a tool, write a loop that exchanges each consecutive pair of integers in the array

	INVOKE CreateRandomArray, OFFSET p85_array, p85_array_size
	INVOKE SwapConsecutivePairs, OFFSET p85_array, p85_array_size

	INVOKE CreateRandomArray, OFFSET p85_array2, p85_array2_size
	INVOKE SwapConsecutivePairs, OFFSET p85_array2, p85_array2_size

	ret
p86 ENDP

CreateRandomArray PROC USES eax ecx esi,
	array_pointer:PTR DWORD,
	array_size:DWORD

	mov ecx, array_size
	mov esi, array_pointer
populate_loop_head:
	call Random32
	mov [esi], eax
	add esi, TYPE DWORD
	loop populate_loop_head

	ret
CreateRandomArray ENDP


SwapConsecutivePairs PROC USES ecx edx esi edi,
	array_pointer:PTR DWORD,
	array_size:DWORD

	mov ecx, array_size
	shr ecx, 1						; Divide array size by 2 to get number of pairs of elements
	mov esi, array_pointer
	mov edx, TYPE DWORD
	shl edx, 1						; Each loop, need to increment esi by two elements, so multiply TYPE DWORD by 2
swap_loop_head:
	lea edi, [esi + 4]
	INVOKE Swap, esi, edi
	add esi, edx
	loop swap_loop_head

	ret
SwapConsecutivePairs ENDP

;-------------------------------------------------------
Swap PROC USES eax esi edi,
	pValX:PTR DWORD, ; pointer to first integer
	pValY:PTR DWORD ; pointer to second integer
;
; Exchange the values of two 32-bit integers
; Returns: nothing
;-------------------------------------------------------
	mov esi, pValX			; get pointers
	mov edi, pValY
	mov eax, [esi]			; get first integer
	xchg eax, [edi]			; exchange with second
	mov [esi], eax			; replace first integer

	ret						; PROC generates RET 8 here
Swap ENDP

end