.data
	dividend_hi QWORD 00000108h
	dividend_lo QWORD 33300020h
	divisor QWORD 00000100h

	ALIGN 8
	val1 QWORD 20403004362047A1h
	val2 QWORD 055210304A2630B2h
	result QWORD 0

	multiplicand QWORD 0001020304050000h
.code

sa_71 PROC
	; In the following code sequence show the value of AL after each shift or rotate instruction has been executed
	mov al, 0D4h				; 0xD4 = 1101 0100b
	shr al, 1					; a. al = 0110 1010b = 0x6A

	mov al, 0D4h
	sar al, 1					; b. al = 1110 1010b = 0xEA

	mov al, 0D4h
	sar al, 4					; c. al = 1111 1101b = 0xFD

	mov al, 0D4h
	rol al, 1					; d. al = 1010 1001b = 0xA9

	ret
sa_71 ENDP

sa_72 PROC
	; In the following code sequence, show the value of AL after each shift or rotate instruction has executed
	mov al, 0D4h				; 0xD4 = 1101 0100b
	ror al, 3					; a. 1001 1010b = 0x9A

	mov al, 0D4h
	rol al, 7					; b. 0110 1010b = 0x6A

	stc
	mov al, 0D4h				; 0xD4 w/ carry set = 1 1101 0100b
	rcl al, 1					; c. 1 1010 1001 = 0xA9 w/ carry set

	stc
	mov al, 0D4h
	rcr al, 3					; d. 1 0011 1010b = 0x3A w/ carry set

	ret
sa_72 ENDP

sa_73 PROC
	; What will be the contents of ax and dx after the following operation

	xor rax, rax
	xor rdx, rdx

	mov dx, 0
	mov ax, 222h
	mov cx, 100h
	mul cx						; Result is 0x22200, which doesn't fit in ax, so dx = 0x002 and ax = 0x2200

	ret
sa_73 ENDP

sa_74 PROC
	; What will the contents of AX be after the following operation?

	xor rax, rax
	xor rdx, rdx

	mov ax, 63h
	mov bl, 10h
	div bl						; ax = 0x0306, because al = 0x06 (quotient), and ah = 0x03 (remainder)

	ret
sa_74 ENDP

sa_75 PROC
	; What will the contents of EAX and EDX be after the following operation?

	mov eax, 123400h
	mov edx, 0
	mov ebx, 10h
	div ebx						; eax = 0x00012340 (quotient), edx = 0x00000000 (remainder)

	ret
sa_75 ENDP

sa_76 PROC
	; What will the contents of AX and DX be after the following operation?

	xor rax, rax
	xor rdx, rdx

	mov ax, 4000h
	mov dx, 500h
	mov bx, 10h
	div bx						; Dividend is dx:ax or 0x5004000, the quotient will be stored in ax and the remainder in dx
								; This causes an overflow because the quotient is 0x500400, which is too large to fit in ax

	ret
sa_76 ENDP

sa_77 PROC
	; What will the contents of BX be after the following instructions execute?

	mov bx, 5
	stc
	mov ax, 60h
	adc bx, ax					; Adds 60h + 5 + carry = 60h + 5 + 1 = 66h

	ret
sa_77 ENDP

sa_78 PROC
	; Describe the output when the following code executes in 64-bit mode

	mov rdx, dividend_hi
	mov rax, dividend_lo		; Dividend is rdx:rax = 0x0000000000000108 0000000033300020, the quotient will be stored in rax and the remainder in rdx
	div divisor					; This causes an overflow because the quotient is 0x0000000000000001 0800000000333000, which is too large to fit in rax

	ret
sa_78 ENDP

sa_79 PROC
	; The following program is supposed to subtract val2 from val1. Find and correct all logic errors.

	comment !
	mov cx, 8					; loop counter
	mov esi, val1				; set index to start
	mov edi, val2
	clc							; clear Carry flag
top:
	mov al, BYTE PTR[esi]		; get first number
	sbb al, BYTE PTR[edi]		; subtract second
	mov BYTE PTR[esi], al		; store the result
	dec esi
	dec edi
	loop top
	!
sa_79 ENDP

sa_79_fixed PROC
	; The following program is supposed to subtract val2 from val1. Find and correct all logic errors.

	xor rax, rax
	xor rcx, rcx

	mov r8, [val1]
	mov r9, [val2]
	sub r8, r9

	mov cx, 8					
	mov rsi, OFFSET val1		; store the address of val1, not its value
	mov rdi, OFFSET val2		; store the address of val2, not its value
	clc							
top:
	mov al, BYTE PTR[rsi]		
	sbb al, BYTE PTR[rdi]		
	mov BYTE PTR[rsi], al		
	inc rsi						; Values are stored little-endian, so addresses must be incremented every loop, not decremented 
	inc rdi
	loop top

	cmp r8, [val1]
	jz same

not_same:
	ret
same:
	; If we've gotten here, then the subtraction was performed correctly
	ret
sa_79_fixed ENDP

sa_710 PROC
	; What will the hexadecimal contents of RAX be after the following instructions execute?

	imul rax, multiplicand, 4	; rax = 0004080C10140000h

	ret
sa_710 ENDP

end