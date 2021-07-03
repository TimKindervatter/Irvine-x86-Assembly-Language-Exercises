TITLE Problem 5-2

.data
	chars BYTE "HACEBDFG"
	links DWORD 0, 4, 5, 6, 2, 3, 7, 0
	output_array BYTE LENGTHOF chars DUP(?)
.code

p52 PROC
	; Suppose you are given three data items that indicate a starting index in a list, an array of characters, and an array of indices.
	; You are to write a program that traverses the indices and locates the characters in the correct sequence.

	mov r8, OFFSET chars
	mov r9, OFFSET links	
	mov rcx, LENGTHOF chars
	mov rsi, 1
	call p52_sub
	
	ret		
p52 ENDP

p52_sub PROC
;-----------------------------------------
; Args:
;	 r8: Contains the starting index of the array of characters
;	 r9: Contains the starting index of the array of indices
;	 rcx: Contains the length of the arrays
;	 rsi: Contains the starting index
;-----------------------------------------
	push rax
	push rbx

	xor rax, rax
	xor rbx, rbx
L1:
	; Move the character of chars that corresponds to the current index into the next spot in output_array
	mov al, chars[rsi]
	mov output_array[rbx], al

	mov esi, links[rsi*TYPE links]			; Get the next index from the links array
	inc rbx									; Increment the pointer into output_array
	loop L1

	pop rbx
	pop rax
	ret
p52_sub ENDP

end