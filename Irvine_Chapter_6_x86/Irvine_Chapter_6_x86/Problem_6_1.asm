TITLE Problem 6-1

.386
.model flat, stdcall
.stack 4096

BetterRandomRange PROTO

N EQU 100

.data
	p61_array DWORD N DUP(?)
.code

p61 PROC
	; Create a procedure that fills an array of DWORDs with N random integers, making sure the values fall within the range j..k inclusive. 
	; When calling the procedure, pass a pointer to the array, N, and the values of j and k. Preserve all register values between calls to the procedure.
	; Write a test program that calls the procedure twice, using different values for j and k.

; ----------------------------------------------------------------------------
; Args:
;	esi: Contains the base address of the array to populate
;	ecx: Contains N, the number of integers to write to the array
;	eax: Contains j, the lower bound of the random range of integers
;	edx: Contains k, the upper bound of the random range of integers
; ----------------------------------------------------------------------------

	; Preserve registers
	push ebx

	mov ebx, edx
	inc ebx							; BetterRandomRange produces a random number in the interval [N, M-1], where N is passed in eax, and M is passed in ebx.
									; So to get a number in the range [j, k], we need to increment k by 1.

	mov edi, eax					; eax gets overwritten as the output of BetterRandomRange, need to preserve value

loop_head:
	mov eax, edi
	call BetterRandomRange
	mov DWORD PTR [esi], eax
	add esi, TYPE esi

	loop loop_head

	pop ebx
	ret
p61 ENDP

p61_test PROC	
	mov esi, OFFSET p61_array
	mov ecx, N
	mov eax, 9
	mov edx, 0
	call p61

	mov esi, OFFSET p61_array
	mov ecx, N
	mov eax, 200h
	mov edx, 100h
	call p61
	ret
p61_test ENDP

end