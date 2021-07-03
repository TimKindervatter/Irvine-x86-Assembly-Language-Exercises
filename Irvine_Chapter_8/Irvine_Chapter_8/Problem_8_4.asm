.386
.model flat, stdcall
.stack 4096

FindThrees PROTO,
	array_pointer:PTR DWORD,
	array_size:DWORD

.data
	p84_array1 DWORD 2, 3, 3, 3, 1
	p84_array1_size = 5

	p84_array2 DWORD 2, 3, 3, 2, 1
	p84_array2_size = 5

	p84_array3 DWORD 2, 3, 3, 2, 1, 2, 3, 3, 2, 1
	p84_array3_size = 10

	p84_array4 DWORD 2, 3, 3, 2, 1, 2, 3, 3, 3, 1
	p84_array4_size = 10
.code

p84 PROC
; Create a procedure named FindThrees that returns a 1 if an array has three consecutive values of 3 somewhere in the array. Otherwise, return 0.
; The procedure's input parameter list contains a pointer to the array and the array's size.
; Use the PROC directive with a parameter list when declaring the procedure. Preserve all registers (except EAX) that are modified by the procedure.
; Write a test program that calls FindThrees several times with different arrays.

	INVOKE FindThrees, OFFSET p84_array1, p84_array1_size
	INVOKE FindThrees, OFFSET p84_array2, p84_array2_size
	INVOKE FindThrees, OFFSET p84_array3, p84_array3_size
	INVOKE FindThrees, OFFSET p84_array4, p84_array4_size

	ret
p84 ENDP

FindThrees PROC USES ebx ecx edx esi,
	array_pointer:PTR DWORD,
	array_size:DWORD
;-----------------------------------------------------------------------------------------------------------------------------
; FindThrees(int* array, int size)
; Returns 1 in EAX if the passed array has 3 consecutive values of 3 somewhere in the array, otherwise returns 0 in EAX.
;-----------------------------------------------------------------------------------------------------------------------------

	xor eax, eax						; Return value, initialize to 0
	xor ebx, ebx						; Counter to keep track of number of consecutive threes
	mov edx, 3							; Can't use a literal as an argument to cmp, so move 3 into a register for comparison later
	mov ecx, array_size
	mov esi, array_pointer
loop_head:
	cmp [esi], edx
	jne not_a_three						; If there was not a 3, continue the loop without incrementing the counter
	inc ebx								; If there was a 3, increment the counter
	cmp ebx, edx
	jne not_three_threes				; If there are fewer than three 3s, we're not done, so continue the loop
	mov eax, 1							; If there have been three 3s, set the return value to 1
	jmp done							; No need to continue, so return early
not_a_three:
	xor ebx, ebx						; We encountered a non-three so reset the counter
not_three_threes:
	add esi, TYPE DWORD
	loop loop_head
done:
	ret
FindThrees ENDP

end