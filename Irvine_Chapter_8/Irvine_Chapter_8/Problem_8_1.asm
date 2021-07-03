.386
.model flat, stdcall
.stack 4096

FindLargest PROTO,
	array_pointer:PTR DWORD,
	array_length:DWORD

.data
	ARRAY1_SIZE = 10
	array1 DWORD 4, 1, -2, 6, 3, 9, 23h, 2, -5, 6

	ARRAY2_SIZE = 5
	array2 DWORD -5, -4, -3, -2, -1

	ARRAY3_SIZE = 3
	array3 DWORD 1, 0, -1
.code

p81 PROC
; Create a procedure named FindLargest that receives two parameters: a pointer to a signed doubleword array, and a count of the array's length.
; The procedure must return the value of the largest array member in EAX. 
; Use the PROC directive with a parameter list when declaring the procedure.
; Preserve all registers (except EAX) that are modified by the procedure.
; Write a test program that calls FindLargest and passes three different arrays of different lengths.
; Be sure to include negative values in your arrays.
; Create a PROTO definition for FindLargest

	INVOKE FindLargest, OFFSET array1, ARRAY1_SIZE
	INVOKE FindLargest, OFFSET array2, ARRAY2_SIZE
	INVOKE FindLargest, OFFSET array3, ARRAY3_SIZE

	ret
p81 ENDP

FindLargest PROC USES esi ecx,
	array_pointer:PTR DWORD,
	array_length:DWORD
;--------------------------------------------------------------------
; FindLargest(int* array, int length)
; Returns the largest value in the passed array in the EAX register
;--------------------------------------------------------------------

	mov esi, array_pointer
	mov ecx, array_length
	mov eax, [esi]
loop_head:
	cmp eax, [esi]
	jge skip_assignment
	mov eax, [esi]
skip_assignment:
	add esi, TYPE DWORD
	loop loop_head

	ret
FindLargest ENDP

end