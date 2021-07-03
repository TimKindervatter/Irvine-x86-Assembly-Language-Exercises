.data
	three DWORD 12345678h
	var1 DWORD ?
	var2 DWORD ?
	var3 DWORD ?
	ALIGN 8
	AW8array DWORD 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	val2 WORD ?
	val4 WORD ?

	; Data for questions 12-18
	ALIGN 2
	myBytesWordLabel LABEL WORD
	myBytes2 BYTE 10h,20h,30h,40h
	myWordsDWordLabel LABEL DWORD
	myWords2 WORD 3 DUP(0AA42h),2000h
	myString2 BYTE "ABCDE"

.code
AW1 PROC
	; Write a sequence of MOV instructions that will exchange the upper and lower words in a doubleword variable named three
	xor rax, rax
	xor rbx, rbx
	mov ax, WORD PTR [three]
	mov bx, WORD PTR [three + 2]

	mov WORD PTR [three + 2], ax
	mov WORD PTR [three], bx
	ret
AW1 ENDP

AW2 PROC
	; Using the XCHG instruction no more than three times, reorder the values in four 8-bit registers from the order A,B,C,D to B,C,D,A
	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx
	xor rdx, rdx

	mov al, 'A'
	mov bl, 'B'
	mov cl, 'C'
	mov dl, 'D'

	xchg al, bl
	xchg bl, cl
	xchg cl, dl

	ret
AW2 ENDP

AW3 PROC
	; Suppose a message byte in the AL register contains 01110101b. Show how you could use the parity flag combined with an arithmetic instruction to determine if this message byte has even or odd parity.
	mov al, 01110101b
	add al, 0
	jp evn				; Jump if parity flag is set (i.e. even parity)
	jnp odd				; Jump if parity flag is not set (i.e. odd parity)
	
evn:
	nop			; Jumps here if parity is even
odd:
	nop			; Jumps here if parity is odd
	
	ret
AW3 ENDP

AW4 PROC
	; Write code using byte operands that adds two negative integers and causes the overflow flag to be set.
	xor rax, rax
	mov al, -1
	mov bl, -128
	add al, bl			; Adding any two negative numbers together that produces a result more negative than -128 sets the overflow flag.
	ret
AW4 ENDP

AW5 PROC
	; Write a sequence of two instructions that use addition to set the zero and carry flags at the same time.
	add bl, 0FFh
	add bl, 1			; bl overflows to 00h. The overflow sets the carry flag and the final value is zero so the zero flag is set.
	ret
AW5 ENDP

AW6 PROC
	; Write a sequence of two instructions that set the carry flag using subtraction
	mov bl, 127
	sub bl, 128			; Subtracting a larger unsigned value from a smaller unsigned value sets the carry flag
	ret
AW6 ENDP

AW7 PROC
	; Implement the following arithmetic expression: EAX = -val2 + 7 - val3 + val1, where val1, val2, val3 are 32-bit integer variables.
	mov DWORD PTR [var1], 43h
	mov DWORD PTR [var2], 7h
	mov DWORD PTR [var3], 1h
	
	xor rax, rax
	mov eax, [var2]
	neg eax
	add eax, 7
	sub eax, [var3]
	add eax, [var1]

	ret
AW7 ENDP

AW8 PROC
	; Write a loop that iterates through a doubleword array and calculates the sum of its elements using a scale factor with indexed addressing.
	xor rax, rax	
	xor rbx, rbx
	xor rsi, rsi
	mov rcx, LENGTHOF AW8array
L1:
	add ebx, AW8array[rax*TYPE AW8array] 
	inc rax
	loop L1

	ret
AW8 ENDP

AW9 PROC
	; Implement the following expression in assembly language: AX = (val2 - BX) - val4. Assume val2 and val4 are 16-bit integers
	xor rax, rax
	mov [val2], 10h
	mov [val4], 20h
	mov bx, 10h

	add bx, [val2]
	sub bx, val4
	mov ax, bx
	ret
AW9 ENDP

AW10 PROC
	; Write a sequence of two instructions that set both the carry and overflow flags at the same time
	xor rax, rax
	mov al, 80h
	add al, 80h			; Gives -128 + (-128) = -256, which is not representable by an 8-bit value, so we get a carry, and is also an underflow so the overflow flag is also set
	ret
AW10 ENDP

AW11 PROC
	; Write a sequence of instructions showing how the zero flag could be used to indicate unsigned overflow after executing INC and DEC isntructions.
	xor rax, rax
L2:
	inc eax
	jnz L2

L3:
	dec al
	jnz L3

	ret
AW11 ENDP

AW12 PROC
	; Insert a directive in the given data that aligns myBytes to an even-numbered address
AW12 ENDP

AW13 PROC
	; What will be the value of EAX after each of the following instructions execute?
	mov eax, TYPE myBytes2		; a. eax = 1
	mov eax, LENGTHOF myBytes2	; b. eax = 4
	mov eax, SIZEOF myBytes2	; c. eax = 4
	mov eax, TYPE myWords2		; d. eax = 2
	mov eax, LENGTHOF myWords2	; e. eax = 4
	mov eax, SIZEOF myWords2	; f. eax = 8
	mov eax, SIZEOF myString2	; g. eax = 5
	ret
AW13 ENDP

AW14 PROC
	; Write a single instruction that moves the first two bytes in myBytes2 into the DX register. The resulting value will be 2010h.
	xor rdx, rdx
	mov dx, WORD PTR [myBytes2]
	ret
AW14 ENDP

AW15 PROC
	; Write an instruction that moves the second byte in myWords into the AL register
	xor rax, rax
	mov al, BYTE PTR [myWords2 + 1]
	ret
AW15 ENDP

AW16 PROC
	; Write an instruction that moves all four bytes in myBytes2 to the EAX register
	xor rax, rax
	mov eax, DWORD PTR [myBytes2]
	ret
AW16 ENDP

AW17 PROC
	; Insert a LABEL directive in the given data that permits myWords2 to be moved directly to a 32-bit register
	mov ebx, [myWordsDWordLabel]
	ret
AW17 ENDP

AW18 PROC
	; Insert a LABEL directive in the given data that permits myBytes2 to be moved directly to a 16-bit register
	xor rcx, rcx
	mov cx, [myBytesWordLabel]
	ret
AW18 ENDP

end