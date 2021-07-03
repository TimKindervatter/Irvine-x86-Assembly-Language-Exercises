.data
	shr_array DWORD 648B2165h,8C943A29h,6DFA4B86h,91F76C04h,8BAF9857h
	
	ALIGN 8
	bin_to_asc_array BYTE 32 DUP(?)
	bin_to_asc_reversed_array BYTE 32 DUP(?)

	bMinutes BYTE ?

	var1 DWORD 3
	var2 DWORD 11
	var3 DWORD 4

.code

ch7_scratch_pad PROC
	call shift_array_right
	call sec71_review
	call sec_72_review

	call ex3
	call sec_74_review
	ret
ch7_scratch_pad ENDP

shift_array_right PROC
	mov bl, 4								; Number of bits to shift
	mov rsi, OFFSET shr_array
	mov rcx, (LENGTHOF shr_array) - 1		; Initialize loop counter
L1:
	push rcx								; Save loop counter because the only register that can be used to hold number of bits in a shift instruction is cl, so we'll need to overwrite cl in the loop
	mov eax, [rsi + TYPE shr_array]
	mov cl, bl								; Put the number of bits to shift into cl
	shrd [rsi], eax, cl						; Shift this element of the array right by 4 bits

	add rsi, TYPE shr_array	
	pop rcx									; Restore the loop counter
	loop L1

	shr DWORD PTR [rsi], 4					; Shift the last element

	ret
shift_array_right ENDP

sec71_review PROC
; 5. Write a series of instructions that shift the lowest bit of AX into the highest bit of BX without using the SHRD instruction. Next, perform the same operation using SHRD.
	xor rax, rax
	xor rbx, rbx
	mov ax, 00000101b
	mov bx, 0

	shr ax, 1
	rcr	bx, 1

	xor rcx, rcx
	xor rdx, rdx
	mov cx, 00000101b
	mov dx, 0

	shrd dx, cx, 1

; 6. One way to calculate the parity of a 32-bit number in EAX is to use a loop that shifts each bit into the Carry flag and accumulates a count of the number of times the Carry flag was set. 
; Write a code that does this, and set the Parity flag accordingly.

	mov rcx, 32
	mov rbx, 0						; Initialize the carry count
	mov eax, 0AAAAAAABh
L1:
	ror eax, 1
	jnc skip_inc					; If the carry flag was not set, do not increment the number of carries
	inc rbx
skip_inc:
	loop L1	

	test rbx, 1						; Result will be zero (even parity, and thus PF = 1) if the number of carries was even
									; Result will be one (odd parity, and thus PF = 0) if the number of carries was odd

	ret
sec71_review ENDP

sec_72_review PROC
; 1. Write instructions to calculate EAX*24
	mov eax, 10
	mov ebx, eax
	shl eax, 4						; Multiply by 16
	shl ebx, 3						; Multiply by 8
	add eax, ebx					; Add the two results together to get (eax*16) + (eax*8) = eax*(16 + 8) = eax*24

; 2. Write instructions to calculate EAX*21
	mov eax, 10
	mov ebx, eax
	mov ecx, eax
	shl eax, 4						; Multiply by 16
	shl ebx, 2						; Multiply by 4
	add eax, ebx					; Add the two results together to get (eax*16) + (eax*4) = eax*(16 + 4) = eax*20
	add eax, ecx					; ecx = eax, so we have eax*20 + eax = eax*21

; 3. Modify BinToAsc to display the binary value in reverse order
	mov eax, 0FFFF0000h
	mov esi, OFFSET bin_to_asc_array
	call BinToAsc

	mov eax, 0FFFF0000h
	mov esi, OFFSET bin_to_asc_reversed_array
	call BinToAscReversed

; 4. The time stamp field of a file directory entry uses bits 0 through 4 for the seconds, bits 5 through 10 for the minutes, and bits 11 through 15 for the hours. 
; Write instructions that extract the minutes and copy the value to a byte variable named bMinutes.
	mov eax, 010101000000100b				; 10:16:04
	shr eax, 5								; Shift over 5 bits so that bits 0 through 4 are now the minutes
	and al, 00011111b						; Mask al so that only the bits representing minutes are preserved
	mov [bMinutes], al						; bMinutes now contains 16

	ret
sec_72_review ENDP

;---------------------------------------------------------
BinToAsc PROC
;
; Converts 32-bit binary integer to ASCII binary.
; Receives: EAX = binary integer, ESI points to buffer
; Returns: buffer filled with ASCII binary digits
;---------------------------------------------------------
	push rcx
	push rsi

	mov ecx, 32						; number of bits in EAX
L1: 
	shl eax, 1						; shift high bit into Carry flag
	mov BYTE PTR [esi], '0'			; choose 0 as default digit
	jnc L2							; if no Carry, jump to L2
	mov BYTE PTR [esi], '1'			; else move 1 to buffer
L2: 
	inc esi							; next buffer position
	loop L1							; shift another bit to left

	pop rsi
	pop rcx
	ret
BinToAsc ENDP

;---------------------------------------------------------
BinToAscReversed PROC
;
; Converts 32-bit binary integer to ASCII binary.
; Receives: EAX = binary integer, ESI points to buffer
; Returns: buffer filled with ASCII binary digits
;---------------------------------------------------------
	push rcx
	push rsi

	mov ecx, 32						; number of bits in EAX
L1: 
	shr eax, 1						; shift low bit into Carry flag
	mov BYTE PTR [esi], '0'			; choose 0 as default digit
	jnc L2							; if no Carry, jump to L2
	mov BYTE PTR [esi], '1'			; else move 1 to buffer
L2: 
	inc esi							; next buffer position
	loop L1							; shift another bit to left

	pop rsi
	pop rcx
	ret
BinToAscReversed ENDP

ex3 PROC
; Implement the following C++ statement, using signed 32-bit integers:
; var4 = (var1 * -5) / (-var2 % var3);

; Numerator
	mov eax, [var1]				; eax = 3
	mov ebx, -5					; ebx = -5
	mul ebx						; eax = -15, edx = 2
	mov ecx, eax				; ecx = -15 (ax will be overwritten by other instructions, so need to preserve the value we just computed)
	
; Denominator
	mov eax, [var2]				; eax = 11
	neg eax						; eax = 0xFFFFFFF5 (-11)
	cdq 						; eax = 0xFFFFFFEF (-11), edx = 0xFFFFFFFF
								; var3 = 4
	idiv [var3]					; eax = -2, edx = -3

; Final Result
	mov ebx, edx				; ebx = -3
	mov eax, ecx				; eax = -15 (result of numerator that was saved earlier)
	cdq							; eax = 0xFFFFFFF1, edx = 0xFFFFFFFF
	idiv ebx					; eax = 5, dx = 0

	ret
ex3 ENDP

sec_74_review PROC
	mov edx, 10h
	mov eax, 0A0000000h
	add eax, 20000000h				; No carry because MSBs of the operands give 1010b + 0010b = 1100b = 0xC
	adc edx, 0						; edx = 0x00000010

	mov edx, 100h
	mov eax, 80000000h
	sub eax, 90000000h				; Carry because MSBs give 1000b - 1001b = 1111b, with carry flag set to indicate borrow
	sbb edx, 0						; edx = 0x000000FFh

	mov dx, 5
	stc
	mov ax, 10h
	adc dx, ax						; dx = 16h

	ret
sec_74_review ENDP

end