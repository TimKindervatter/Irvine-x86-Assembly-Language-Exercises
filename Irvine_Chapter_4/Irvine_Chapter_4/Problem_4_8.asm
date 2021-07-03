TITLE Problem 4-8

; Using a loop and indexed addressing, write code that rotates the members of a 32-bit integer array forward one position. The value at the end of the array must wrap around to the first position.
; E.g. [10, 20, 30, 40] would become [40, 10, 20, 30]

.data
	rotate_array BYTE 10h, 20h, 30h, 40h

.code

p48 PROC
	mov rsi, LENGTHOF rotate_array			; Get number of elements in array
	sub rsi, 1								; Subtract 1 from number of elements to get index of last element

	mov rcx, rsi							; Need (LENGTHOF array - 1) iterations to shift all elements right by one (last element will be handled separately).
	mov al, rotate_array[rsi]				; Store the last element to handle after the loop
	xor rbx, rbx
L1:
	; Shift element forward 1
	mov bl, rotate_array[rsi - 1]
	mov rotate_array[rsi], bl
	
	sub rsi, TYPE rotate_array				; Decrement the index
	loop L1

	mov rotate_array[0], al					; Move the last element into the first position
	ret
p48 ENDP

end