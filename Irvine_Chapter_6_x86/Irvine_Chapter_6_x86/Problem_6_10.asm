TITLE Problem 6-10

.386
.model flat, stdcall
.stack 4096

WriteString PROTO
Crlf PROTO

.data
	even_parity_array BYTE 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah
	odd_parity_array BYTE 0Bh, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah

	even_message BYTE "Even", 0
	odd_message BYTE "Odd", 0
.code

p610_test PROC
	; Create a procedure that returns True in the EAX register if the bytes in an array have even parity and false if they have odd parity.
	; Preserve all other register values between calls.
	; Write a test program that calls your procedure twice, each time passing in a pointer to an array and the length of the array.

	mov esi, OFFSET even_parity_array
	mov ecx, LENGTHOF even_parity_array
	call p610
	
	mov esi, OFFSET odd_parity_array
	mov ecx, LENGTHOF odd_parity_array
	call p610
	
	ret
p610_test ENDP

p610 PROC
	call check_parity
	cmp eax, 0
	jz odd_label
	jnz even_label

even_label:
	mov edx, OFFSET even_message
	call WriteString
	call Crlf
	jmp done
odd_label:
	mov edx, OFFSET odd_message
	call WriteString
	call Crlf
done:
	ret
p610 ENDP

check_parity PROC
; ----------------------------------------------------------------------------
; Args:
;	esi: Base address of the array whose parity is to be checked
;	ecx: Length of array
; Returns:
;	eax: Parity of the array (1 = even, 0 = odd)
; ----------------------------------------------------------------------------

	mov al, [esi]
	sub ecx, 1				; If the array has N bytes, we only need to do N-1 XOR operations; one between each pair
loop_head:
	add esi, 1
	xor al, [esi]
	loop loop_head

	jp even_parity
	jnp odd_parity

even_parity:
	mov eax, 1
	ret
odd_parity:
	mov eax, 0
	ret
check_parity ENDP

end