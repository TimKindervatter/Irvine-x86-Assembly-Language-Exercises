TITLE 4-7

; Write a program with a loop and indirect addressing that copies a string from source to target, reversing the character order in the process.

.data
	source BYTE "This is the source string",0
	target BYTE SIZEOF source DUP('#')

.code

p47 PROC
	mov rdi, OFFSET target			; Store the base address of target

	mov rsi, OFFSET source			; Store the base address of source
	add rsi, SIZEOF source			; Move the pointer past the end of source
	sub rsi, TYPE source			; Back up one element to point to the last element of source

	xor rbx, rbx
	mov rcx, LENGTHOF source
	
L1:
	mov bl, [rsi]					; Move the currently-pointed-to character from the source into a register
	mov [rdi], bl					; Store the copied character into target

	sub rsi, TYPE source			; Decrement the source pointer
	add rdi, TYPE target			; Increment the target pointer

	loop L1

	ret
	
p47 ENDP

end