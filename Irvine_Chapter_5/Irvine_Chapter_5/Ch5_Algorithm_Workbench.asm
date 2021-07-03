WriteHex64 PROTO

.data
	aw4_array DWORD 1, 2, 3, 4, 5
.code

AW1 PROC
	; Write a sequence of statements that use only PUSH and POP instructions to exchange the values in the EAX and EBX registers (or RAX and RBX in 64-bit mode)
	mov rax, 10h
	mov rbx, 20h
	
	push rax
	push rbx
	pop rax
	pop rbx

	ret
AW1 ENDP

AW2 PROC
	; Suppose you wanted a subroutine to return to an address that was 3 bytes higher in memory than the return address currently on the stack. 
	; Write a sequence of intructions that would be inserted just before the subroutine's RET instruction that accomplishes this task.

	mov rsi, [rsp]
	sub rsi, 5					; By looking in the disassembly, we see that the call AW2 instruction is 5 bytes long, so subtracting that from the current return oddress on the stack points us back at the call AW2 instruction
	mov [rsp], rsi

	ret							; This will return to call AW2 and thus infinitely loop
AW2 ENDP

AW3 PROC
	; Functions in high-level languages often declare local variables just below the return address on the stack. Write an instruction that you could put at the beginning of an assembly language subroutine
	; that would reserve space for two integer doubleword variables. Then, assign the values 1000h and 2000h to the two local variables.
	
	sub rsp, 8					; Decrements the stack pointer by 8 bytes, which is enough space to fit two DWORDs
	mov DWORD PTR [rsp + 4], 1000h
	mov DWORD PTR [rsp], 2000h
	
	ret
AW3 ENDP

AW4 PROC
	; Write a sequence of statements using indexed addressing that copies an element in a doubleword array to the previous position in the same array.
	
	lea rsi, [3*TYPE aw4_array]	

	mov ebx, aw4_array[rsi]
	mov aw4_array[rsi - TYPE aw4_array], ebx

	ret
AW4 ENDP

AW5 PROC
	; Write a sequence of statements to display a subroutine's address. Be sure that whatever modifications you make to the stack do not prevent the subroutine from returning to its caller.
	
	mov rax, [rsp]
	call WriteHex64
	ret
AW5 ENDP

end