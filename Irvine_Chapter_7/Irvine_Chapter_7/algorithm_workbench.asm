.data
	byteArray BYTE 81h, 20h, 33h
	ALIGN 2
	wordArray WORD 810Dh, 0C064h, 93ABh

	aw_79_var1 WORD ?

	ALIGN 4
	aw_711_val1 DWORD ?
	aw_711_val2 DWORD 3
	aw_711_val3 DWORD 4
	aw_711_val4 DWORD 9

	ALIGN 4
	aw_712_val1 DWORD 8
	aw_712_val2 DWORD 8
	aw_712_val3 DWORD 2

	dividend DWORD 1000
	divisor DWORD 32 ; must be a power of 2
	answer DWORD ?

.code

aw_71 PROC
	; Write a sequence of shift instructions that cause AX to be sign-extended into EAX. In other words, the sign bit of AX is copied into the upper 16 bits of EAX. Do not use the CWD instruction.
	
	xor rax, rax
	mov ax, 8000h
	shl eax, 16
	sar eax, 16

	ret
aw_71 ENDP

aw_72 PROC
	; Suppose the instruction set contained no rotate instructions. Show how you would use SHR and a conditional jump instruction to rotate the contents of the AL register 1 bit to the right.

	xor rax, rax
	xor rbx, rbx
	mov rbx, 1
	ror bl, 1

	mov al, 1
	shr al, 1
	jnc carry_not_set
	or al, 80h
carry_not_set:
	ret
aw_72 ENDP

aw_73 PROC
	; Write a logical shift instruction that multiplies the contents of EAX by 16
	
	mov eax, 1
	shl eax, 4

	ret
aw_73 ENDP

aw_74 PROC
	; Write a logical shift instruction that divides ebx by 4

	mov ebx, 4	
	shr ebx, 2

	ret
aw_74 ENDP

aw_75 PROC
	; Write a single rotate instruction that exchanges the high and low halves of the DL register

	mov dl, 24h
	ror dl, 4

	ret
aw_75 ENDP

aw_76 PROC
	; Write a single SHLD instruction that shifts the highest bit of the AX register into the lowest bit position of DX and shifts DX one bit to the left

	xor rax, rax
	xor rdx, rdx

	mov ax, 8000h
	mov dx, 8000h
	shld dx, ax, 1

	ret
aw_76 ENDP

aw_77 PROC
	; Write a sequence of instructions that shift three memory bytes to the right by 1 bit position.

	mov rsi, OFFSET byteArray
	mov rcx, LENGTHOF byteArray
loop_head:
	rcr BYTE PTR [rsi], 1						; Shift the current byte 1 to the right, and store the "underflow" in the carry flag for the next iteration
	inc rsi
	loop loop_head

	mov rax, 812033h
	shr rax, 1

	ret
aw_77 ENDP

aw_78 PROC
	; Write a sequence of instructions that shift three memory words left by 1 bit position

	mov rsi, OFFSET wordArray
	add rsi, SIZEOF wordArray - 2			; We're shifting left, so we need to start with the rightmost byte
	mov rcx, LENGTHOF wordArray
loop_head:
	rcl WORD PTR [rsi], 1
	dec rsi
	dec rsi									; dec twice rather than sub rsi, 2 because the sub instruction affects the carry flag
	loop loop_head

	mov rax, 810DC06493ABh
	shl rax, 1

	ret
aw_78 ENDP

aw_79 PROC
	; Write instructions that multiply -5 by 3 and store the result in a 16-bit variable var1

	mov bx, -5
	imul ax, bx, 3
	mov [aw_79_var1], ax
	
	ret
aw_79 ENDP

aw_710 PROC
	; Write instructions that divide -276 by 10 and store the result in a 16-bit variable var1

	xor rax, rax
	xor rdx, rdx

	mov ax, -276
	cwd						; ax must be sign extended to 8 bytes in order to do a signed division with ax, otherwise the answer will be incorrect
	mov bx, 10
	idiv bx
	mov [aw_79_var1], ax

	ret
aw_710 ENDP

aw_711 PROC
	; Implement the following C++ expression in assembly language using 32-bit unsigned operands:
	; val1 = (val2 * val3) / (val4 - 3)

	xor rdx, rdx

	mov ebx, [aw_711_val4]
	sub ebx, 3

	mov eax, [aw_711_val2]
	imul [aw_711_val3]
	
	idiv ebx

	mov [aw_711_val1], eax
	
	ret
aw_711 ENDP

aw_712 PROC
	; Implement the following C++ expression in assembly language using 32-bit unsigned operands:
	; val1 = (val2 / val3) * (val1 + val2)

	xor rdx, rdx

	mov ebx, [aw_712_val1]
	add ebx, [aw_712_val2]

	mov eax, [aw_712_val2]
	idiv [aw_712_val3]
	
	imul ebx

	mov [aw_712_val1], eax
	
	ret
aw_712 ENDP

aw_714 PROC
	; Suppose AX contains 0072h and the Auxiliary Carry flag is set as a result of adding two unknown ASCII decimal digits. 
	; Use the Intel 64 and IA-32 Instruction Set Reference to determine what output the AAA instruction would produce. Explain your answer.

	; After AAA, AX would equal 0108h. Intel says: First, if the lower digit of AL is greater than 9 or the
	; AuxCarry flag is set, add 6 to AL and add 1 to AH. Then in all cases, AND AL with 0Fh. Here is their pseudocode:

comment 
!
	IF ((AL AND 0FH) > 9) OR (AuxCarry = 1) THEN
	add 6 to AL
	add 1 to AH
	END IF
	AND AL with 0FH
!

aw_714 ENDP

aw_715 PROC
	; Using only SUB, MOV, and AND instructions, show how to calculate x = n mod y, assuming that you are given the values of n and y. 
	; You can assume that n is any 32-bit unsigned integer, and y is a power of 2

	mov edx, divisor			; create a bit mask
	sub edx, 1
	mov eax, dividend
	and eax, edx				; clear high bits, low bits contain mod value
	mov answer, eax

	ret
aw_715 ENDP

aw_716 PROC
	; Using only SAR, ADD, and XOR instructions (but no conditional jumps), write code that calculates the absolute value of the signed integer in the EAX register. 
	; Hints: A number can be negated by adding -1 to it and then forming its one’s complement. 
	; Also, if you XOR an integer with all 1s, its 1s are reversed. On the other hand, if you XOR an integer with all zeros, the integer is unchanged.

	mov edx, eax
	sar eax, 31
	add eax, edx
	xor eax, edx

	ret
aw_716 ENDP

end