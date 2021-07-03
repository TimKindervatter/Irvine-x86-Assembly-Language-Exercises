.386
.model flat, stdcall
.stack 4096

.data
	count = 100
	array WORD count DUP(?)
.code

scratchpad PROC
	; Push arguments in reverse order. C-style function signature would be fillArray(WORD* array, BYTE count)
	push count
	push OFFSET array
	; call fillArray
	call fillArray_enter_leave

	call makeArray
	call makeArray_enter_leave

	mov eax, 0
	mov ecx, 5
	call recursiveSum

	push 13
	call recursiveFactorial
	ret
scratchpad ENDP

fillArray PROC
	; Function prologue
	push ebp
	mov ebp, esp
	pushad				; Save all existing register values

	; Populate local parameters from the argument values pushed onto the stack
	mov esi, [ebp + 8]	; esi register now holds the pointer to the base address of the array
	mov ecx, [ebp + 12]	; ecx now holds the number of elements in the array

	; Populate the array
	cmp ecx, 0
	je loop_finished
loop_head:
	mov WORD PTR [esi], 42h
	add esi, TYPE WORD
	loop loop_head
loop_finished:
	; Function epilogue
	popad				; Restore saved values of registers
	pop ebp
	ret 8				; Clean up the space being used	for arguments (two arguments, each of size 4 bytes)
fillArray ENDP

fillArray_enter_leave PROC
	; Function prologue
	enter 0, 0			; Equivalent to push ebp, then mov ebp, esp. Does not reserve any space for local variables
	pushad				; Save all existing register values

	; Populate local parameters from the argument values pushed onto the stack
	mov esi, [ebp + 8]	; esi register now holds the pointer to the base address of the array
	mov ecx, [ebp + 12]	; ecx now holds the number of elements in the array

	; Populate the array
	cmp ecx, 0
	je loop_finished
loop_head:
	mov WORD PTR [esi], 42h
	add esi, TYPE WORD
	loop loop_head
loop_finished:
	; Function epilogue
	popad				; Restore saved values of registers
	leave				; Equivalent to pop ebp
	ret 8				; Clean up the space being used	for arguments (two arguments, each of size 4 bytes)
fillArray_enter_leave ENDP

makeArray PROC
	; Translate the following code into assembly:
	; makeArray()
	; {
	;	char myString[30]
	;	for (int i = 0; i < 30; i++)
	;		myString[i] = '*';
	; }

	; Function prologue
	push ebp
	mov ebp, esp
	sub esp, 32			; Reserve space for local variables. Only local is myString[], which is an array of 30 bytes. The stack pointer needs to be aligned on a 4-byte boundary so we need to reserve 32 bytes for it.
	pushad				; Save all register values

	; Make the array
	lea esi, [ebp - 30] ; Address of local variable cannot be known at assemble time, so we can't use OFFSET to get a pointer to the local array. Instead use lea to get the address relative to ebp at runtime.
	mov ecx, 30
loop_head:
	mov BYTE PTR [esi], '*'
	inc esi
	loop loop_head

	; Function epilogue
	popad
	mov esp, ebp		; Free the space that was reserved for local variables
	pop ebp
	ret
makeArray ENDP

makeArray_enter_leave PROC
	; Translate the following code into assembly:
	; makeArray()
	; {
	;	char myString[30]
	;	for (int i = 0; i < 30; i++)
	;		myString[i] = '*';
	; }

	; Function prologue
	enter 32, 0
	pushad				; Save all register values

	; Make the array
	lea esi, [ebp - 30] ; Address of local variable cannot be known at assemble time, so we can't use OFFSET to get a pointer to the local array. Instead use lea to get the address relative to ebp at runtime.
	mov ecx, 30
loop_head:
	mov BYTE PTR [esi], '%'
	inc esi
	loop loop_head

	; Function epilogue
	popad
	leave
	ret
makeArray_enter_leave ENDP

recursiveSum PROC
	cmp ecx, 0
	je done
	add eax, ecx
	dec ecx
	call recursiveSum
done:
	ret
recursiveSum ENDP

recursiveFactorial PROC
	push ebp
	mov ebp, esp

	mov eax, [ebp + 8]
	cmp eax, 0
	ja n_greater_than_zero
	mov eax, 1
	jmp done
n_greater_than_zero:
	dec eax
	push eax
	call recursiveFactorial
	mov ebx, [ebp + 8]
	mul ebx
done:
	pop ebp
	ret 4
recursiveFactorial ENDP

end