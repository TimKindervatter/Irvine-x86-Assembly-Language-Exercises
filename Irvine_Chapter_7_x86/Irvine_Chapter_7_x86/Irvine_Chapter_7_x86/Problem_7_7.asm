.386
.model flat, stdcall
.stack 4096

WriteInt PROTO
Crlf PROTO

.data
	exponents BYTE 32 DUP(0)
.code

p77 PROC
	; Write a procedure named BitwiseMultiply that multiplies any unsigned 32-bit integer by EAX, using only shifting and addition. 
	; Pass the integer to the procedure in the EBX register and return the product in the EAX register.
	; Write a short test program that calls the procedure and displays the result.
	;  (We will assume that the product is never larger than 32 bits.)

	mov eax, 16
	mov ebx, 16
	call BitwiseMultiply
	call WriteInt
	call Crlf

	mov eax, 10
	mov ebx, 20
	call BitwiseMultiply
	call WriteInt
	call Crlf

	mov eax, 400
	mov ebx, 10
	call BitwiseMultiply
	call WriteInt
	call Crlf

	ret	
p77 ENDP

BitwiseMultiply PROC
	; Args:
	;	eax: a (factor 1)
	;	ebx: b (factor 2)
	; Returns:
	;	eax: a*b (product)

	; a*b = a*(sum of multiples of 2), where the multiples of 2 are exactly the set i = {bits that are set in the binary representation of b}
	;	  = sum_over_i(a*2^i) = sum_over_i(shl a, i)

	push ebx
	push ecx
	push edx
	push edi

	mov edi, 0				; Initialize the sum to 0
	mov cl, 0
loop_head:
	shr ebx, 1
	jnc bit_not_set			
	mov edx, eax			; Refresh the initial value of eax, which will be left shifted to obtain a*2^i
	shl edx, cl				; Gives 2^i

	add edi, edx			; Add this to the running sum representing a*b
bit_not_set:
	inc cl
	cmp cl, 32
	jb loop_head

	mov eax, edi			; Store the running sum in eax as the return value

	pop edi
	pop edx
	pop ecx
	pop ebx

	ret
BitwiseMultiply ENDP

end