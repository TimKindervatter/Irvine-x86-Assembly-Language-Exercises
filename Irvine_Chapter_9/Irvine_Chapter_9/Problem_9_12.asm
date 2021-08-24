IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

.data
	byte_array BYTE 2, 2, 2, 2
	byte_array_row_size = ($ - byte_array)
			   BYTE	3, 3, 3, 3

	word_array WORD 2, 2, 2, 2
	word_array_row_size = ($ - word_array)
			   WORD	3, 3, 3, 3
			   WORD	4, 4, 4, 4

	dword_array DWORD 2, 2, 2, 2
	dword_array_row_size = ($ - dword_array)
			    DWORD 3, 3, 3, 3
			    DWORD 4, 4, 4, 4
				DWORD 5, 5, 5, 5

.code

calc_row_sum PROC
	array_offset EQU [ebp + 8]
	row_size EQU [ebp + 12]
	array_type EQU [ebp + 16]
	row_index EQU [ebp + 20]

	push ebp
	mov ebp, esp

	push ebx
	push ecx
	push edx
	push esi
	push edi

	; Point esi to the start of the row to be summed
	mov eax, row_size
	mov ebx, row_index
	mul ebx								; ebx = row_size * row_index
	mov esi, array_offset
	add esi, eax						; esi = array_offset + row_size * row_index = pointer to start of row to be summed

	; Determine the number of elements in the row
	xor eax, eax						; Clear eax for use in div instruction
	mov eax, row_size
	mov ebx, array_type
	div ebx								; ebx = row_size/array_type = number of elements in row
	mov ecx, eax						; Put the number elements in ecx as the loop counter

	xor eax, eax

	; Determine what type the array is and jump to the appropriate loop
	mov edi, TYPE BYTE
	cmp array_type, edi
	jne not_byte_array
	jmp byte_loop_head
not_byte_array:
	mov edi, TYPE WORD
	cmp array_type, edi
	jne not_word_array
	jmp word_loop_head
not_word_array:
	mov edi, TYPE DWORD
	cmp array_type, edi
	jne done
	jmp dword_loop_head

	; Sum the elements in the row. Different accumulator registers and pointer types must be used depending on the type of the array
byte_loop_head:
	add al, BYTE PTR [esi]
	loop byte_loop_head
	jmp done
word_loop_head:
	add ax, WORD PTR [esi]
	loop word_loop_head
	jmp done
dword_loop_head:
	add eax, DWORD PTR [esi]
	loop dword_loop_head

done:
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	
	mov esp, ebp
	pop ebp
	ret 16
calc_row_sum ENDP


p912 PROC
	; Write a procedure named calc_row_sum that calculates the sum of a single row in a two-dimensional array of bytes, words, or doublewords.
	; The procedure should have the following stack parameters: array offset, row size, array type, and row index
	; It must return the sum in EAX. Use explicit stack parameters, not INVOKE or extended PROC.
	; Write a program that tests your procedure with arrays of bytes, words, and doublewords.
	; Prompt the user for the row index, and display the sum of the selected row.

	push 1
	push TYPE byte_array
	push byte_array_row_size
	push OFFSET byte_array
	call calc_row_sum

	push 2
	push TYPE word_array
	push word_array_row_size
	push OFFSET word_array
	call calc_row_sum

	push 3
	push TYPE dword_array
	push dword_array_row_size
	push OFFSET dword_array
	call calc_row_sum

	ret
p912 ENDP

end