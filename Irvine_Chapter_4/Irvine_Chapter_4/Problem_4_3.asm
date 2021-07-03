TITLE Problem 4-3

; Write a program with a loop and indexed addressing that calculates the sum of all the gaps between successive array elements (i.e. adjacent difference). The array elements are doublewords, monotonically increasing.

.code
	monotonicArray DWORD 0, 2, 5, 9, 10
	
p43 PROC
	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx
	xor rsi, rsi
	xor rdi, rdi

	mov rsi, OFFSET monotonicArray
	mov rdi, TYPE monotonicArray
	mov rcx, LENGTHOF monotonicArray
	sub rcx, 1									; Only need to go up to second to last array element

L1:
	mov eax, [rsi + rdi]						; Store the i+1 element of the array in rax
	sub eax, [rsi]								; Subtract the i element from the i+1 element to get the adjacent difference for this iteration
	add ebx, eax								; Add the difference to the running total
	add rsi, rdi								; Increment the array pointer

	loop L1

	ret
	
p43 ENDP

end