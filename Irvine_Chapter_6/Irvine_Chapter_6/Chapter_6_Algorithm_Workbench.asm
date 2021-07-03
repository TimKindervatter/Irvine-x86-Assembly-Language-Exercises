TITLE Algorithm Workbench

.data
	AW1_array BYTE "0123456789", 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
	AW2_operand DWORD 0AAAAAAAAh
	SetX BYTE 11111100b
	SetY BYTE 00001101b

	val1 DWORD 50
	AW_X BYTE ?

	N SDWORD 14
	A SDWORD 8
	B SDWORD 10
.code

AW1_test PROC
	mov rsi, OFFSET AW1_array
	mov rcx, LENGTHOF AW1_array
while_more_elements:
	mov al, [rsi]
	call AW1
	inc rsi
	loop while_more_elements

	ret
AW1_test ENDP

AW1 PROC
	; Write a single instruction that converts an ASCII digit in AL to its corresponding binary value. If AL already contains a binary value (00h to 09h), leave it unchanged.
	cmp al, 9
	jle leave_as_is
	sub al, 48
leave_as_is:
	ret
AW1 ENDP


AW2 PROC
	; Write instructions that calculate the parity of a 32-bit memory operand. Hint: Use the formula B0 XOR B1 XOR B2 XOR B3
	mov rsi, OFFSET AW2_operand
	mov al, BYTE PTR [rsi]

	mov rcx, SIZEOF AW2_operand				; This will equal 4 bytes because AW2_operand is a DWORD
	dec rcx									; We only need 3 XORs
while_more_bytes:
	inc rsi									; Point to the next byte of the operand
	xor al, [rsi]							; XOR the running result with that byte
	loop while_more_bytes
	
	ret										; The parity flag here will be 0 if the whole operand has an odd number of bits and 1 if the whole operand has an odd number of bits
AW2 ENDP

AW3 PROC
	; Given two bit-mapped sets named SetX and SetY, write a sequence of instructions that generate a bit string in EAX that represents members in SetX that are not members of SetY.
	; Note that this is the same as SetX - SetY  which is the same as SetX AND NOT SetY
	mov bl, SetY
	not bl
	mov al, SetX
	and al, bl

	ret
AW3 ENDP

AW4 PROC
	; Write instructions that jump to label L1 when the unsigned integer in DX is less than or equal to the integer in CX
	xor rax, rax
	xor rcx, rcx
	mov dx, 7Fh							; +127 unsigned, +127 signed
	mov cx, 080h						; +128 unsigned, -128 signed

	cmp dx, cx
	jbe L1								; Will jump because using jbe, which is unsigned
	mov eax, 0DEADBEEFh
L1:
	ret
AW4 ENDP

AW5 PROC
	; Write instructions to jump to label L2 when the signed integer in AX is greater than the integer in CX.
	xor rax, rax
	xor rcx, rcx
	mov cl, 80h							; +128 unsigned, -128 signed
	movsx cx, cl
	mov al, 7Fh							; +127 unsigned, +127 signed
	movsx ax, al

	cmp ax, cx
	jg L2
	mov eax, 0DEADBEEFh
L2:
	ret
AW5 ENDP

AW6 PROC
	; Write instructions that first clear bits 0 and 1 in AL. Then, if the destination operand is equal to zero, the code should jump to label L3. Otherwise, it should jump to label L4.
	
	mov al, 3

	and al, 0FCh					; Clear the lowest two bits of AL
	jz L3
	jnz L4
	mov ebx, 0DEADBEEFh
L3:
	ret
L4:
	ret
AW6 ENDP

AW7 PROC
	; Implement the following pseudocode in assembly language. Use short-circuit evaluation and assume that val1 and X are 32-bit variables.
	; if (val1 > ecx) AND (ecx > edx)
	;	X = 1
	; else
	;	X = 2

	mov ecx, 60
	mov edx, 40

	mov BYTE PTR [AW_X], 2			; Assume else case

	cmp [val1], ecx
	jna else_case					; Short circuit if first condition is false
	cmp ecx, edx
	jna else_case
	mov BYTE PTR [AW_X], 1			; If both conditions pass, we're in the if case, so set X = 1

else_case:
	ret
AW7 ENDP

AW8 PROC
	; Implement the following pseudocode in assembly language. Use short-circuit evaluation and assume that X is a 32-bit variable.
	; if (ebx > ecx) OR (ebx > val1)
	;	X = 1
	; else
	;	X = 2

	mov ebx, 40
	mov ecx, 40

	mov BYTE PTR [AW_X], 1			; Assume if case

	cmp ebx, ecx
	ja if_case						; Short circuit if first condition is true
	cmp ebx, [val1]
	ja if_case
	mov BYTE PTR [AW_X], 2			; If both conditions pass, we're in the else case, so set X = 2

if_case:
	ret
AW8 ENDP

AW9 PROC
	; Implement the following pseudocode in assembly language. Use short-circuit evaluation and assume that X is a 32-bit variable.
	; if (ebx > ecx AND ebx > edx) OR (edx > eax)
	;	X = 1
	; else
	;	X = 2

	mov ebx, 30
	mov ecx, 20
	mov edx, 30
	mov eax, 30

	mov BYTE PTR [AW_X], 1			; Assume if case

	cmp ebx, ecx
	jna first_predicate_false		; If ebx <= ecx, we know the first predicate is false, but we still need to check the second predicate, so jump there
	cmp ebx, edx
	ja if_case						; If we've gotten here, then ebx > ecx. If ebx > edx as well, then the first predicate is true which is enough to satisfy the if statement, so we're done.
first_predicate_false:
	cmp edx, eax
	ja if_case						; If edx > eax, the if statement is satisfied, so we're done.

	mov BYTE PTR [AW_X], 2			; If we've gotten here, then both predicates were false, so we're in the else case
if_case:
	ret
AW9 ENDP

AW10 PROC
	; Implement the following pseudocode in assembly language. Use short-circuit evaluation and assume that A, B, and N are 32-bit signed integers.
	; while N > 0
	;	if N != 3 AND (N < A OR N > B)
	;		N = N - 2
	;	else
	;		N = N - 1
	; end while

	mov eax, [A]
	mov ebx, [B]

while_loop:
	cmp [N], 3
	je else_case			; If N == 3, then the first predicate is false, so we short-circuit and go to the else case
	cmp [N], eax
	jl if_case				; If we've gotten here, then the first predicate is false. If N < A, then the second predicate is true, so we can short-circuit and use the if case
	cmp [N], ebx
	jng else_case			; If we've gotten here, then both the first predicate and the first half of the second predicate are false.  
							; If the second half of the second predicate is also false, then we must take the else case.
	
if_case:
	sub [N], 2
	jmp continue

else_case:
	sub [N], 1				; edx will be 1 if we took the else case, and edx will be 2 if we took the if case

continue:
	cmp [N], 0
	jg while_loop

	ret
AW10 ENDP

end