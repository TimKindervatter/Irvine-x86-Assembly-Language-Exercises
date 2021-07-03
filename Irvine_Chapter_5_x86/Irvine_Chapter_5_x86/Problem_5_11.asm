TITLE Problem 5-11

.386
.model flat, stdcall
.stack 4096

N EQU 50

.data
	indicator_array2 BYTE N DUP(?)
	indicator_array3 BYTE N DUP(?)
.code

p511 PROC
; Write a procedure that finds all multiples of K that are less than N. Initialize a BYTE array of size N and whenever a multiple of K is found, set the corresponding element of the array to 1.
; The procedure must save and restore any registers it modifies.

	mov ebx, N

	mov eax, 2
	mov esi, OFFSET indicator_array2
	call find_multiples

	mov eax, 3
	mov esi, OFFSET indicator_array3
	call find_multiples

	ret
p511 ENDP

find_multiples PROC
; ----------------------------------------------------------
; Args:
;	eax: Contains K, the number of which we are finding multiples
;	ebx: Contains N, the upper bound on the search interval
;	esi: Contains the base address of the indicator array
; ----------------------------------------------------------

	push edx

	mov edx, eax			; Store K in a register that won't change every iteration

L1:
	cmp eax, ebx			; Compare the current multiple of K to N
	jae done				; If the current multiple of K was greater than or equal to N, we're done
	
	mov BYTE PTR [esi], 1	; Set the element corresponding to the current multiple of K to 1
	add esi, edx			; Increment the array pointer by K bytes
	add eax, edx			; Get the next multiple of K by adding an additional K to the current contents of eax

	jmp L1

done:
	pop edx
	ret
find_multiples ENDP

end