.data
	array DWORD 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	array_sum DWORD ?

	array16 WORD 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

	add_four_result QWORD ?

	ALIGN 8
	ex6_array DWORD 4 DUP(0)

.code

scratch_pad PROC
	; call Ex2					; This breaks if uncommented
	call Ex6

	; The push command is equivalent to decrementing the stack pointer and then moving the value into the address now pointed to by the stack pointer
	mov rax, 1

	; sub rsp, 8
	; mov [rsp], rax

	push rax					; Equivalent to the above two lines

	mov rcx, LENGTHOF array		; Store length of array to determine number of iterations
	mov rsi, OFFSET array		; Store the base address of the array to be summed
	call sum_32_bit_array
	mov [array_sum], eax

	mov rcx, LENGTHOF array16		; Store length of array to determine number of iterations
	mov rsi, OFFSET array16		; Store the base address of the array to be summed
	call sum_16_bit_array
	mov WORD PTR [array_sum], ax

	sub rsp, 8					; Stack pointer must be aligned on 16-byte boundary. When main is called, the 8-byte address of the instruction following the call was pushed onto the stack, so only 8 more bytes are needed for alignement.
	sub rsp, 20h				; Allocate 32 bytes of shadow space for registers according to the x64 calling convention

	mov rcx, 1
	mov rdx, 2
	mov r8, 3
	mov r9, 4
	call add_four
	mov [add_four_result], rax

	add rsp, 28h				; Restore the stack pointer so that the return address is popped into rip upon executing the ret instruction
	mov rcx, 0					; Return code from main is stored in rcx
	ret
scratch_pad ENDP

sum_32_bit_array PROC
; -------------------------------------------------------
; Args:
;	rsi contains base address of array of 32-bit integers whose elements are to be summed
;	rcx contains number of array elements	
; Returns:
;	rax contains the sum of the elements in the array specified by the arguments
; -------------------------------------------------------

	push rcx					; Save rcx
	push rsi					; Save rsi
	xor rax, rax				; Array sum will be returned in rax, initialize return value to zero

L1:
	add eax, DWORD PTR [rsi]				; Add the current element of the array to the running total
	add rsi, TYPE DWORD			; Increment the array pointer
	loop L1

	pop rsi						; Restore the saved value of rsi
	pop rcx						; Restore the saved value of rcx

	ret							; The return value is stored in rax

sum_32_bit_array ENDP

sum_32_bit_array_with_uses PROC USES rsi rcx				; The USES directive pushes rsi and rcx onto the stack, and then pop them back off the stack at the end of this procedure
; -------------------------------------------------------
; Args:
;	rsi contains base address of array of 32-bit integers whose elements are to be summed
;	rcx contains number of array elements
; Returns:
;	rax contains the sum of the elements in the array specified by the arguments
; -------------------------------------------------------

	xor rax, rax				; Array sum will be returned in rax, initialize return value to zero

L1:
	add eax, DWORD PTR [rsi]				; Add the current element of the array to the running total
	add rsi, TYPE DWORD			; Increment the array pointer
	loop L1

	ret							; The return value is stored in rax

sum_32_bit_array_with_uses ENDP

sum_16_bit_array PROC USES rsi rcx				; The USES directive pushes rsi and rcx onto the stack, and then pop them back off the stack at the end of this procedure
; -------------------------------------------------------
; Args:
;	rsi contains base address of array of 16-bit integers whose elements are to be summed
;	rcx contains number of array elements
; Returns:
;	rax contains the sum of the elements in the array specified by the arguments
; -------------------------------------------------------

	xor rax, rax				; Array sum will be returned in rax, initialize return value to zero

L1:
	add ax, WORD PTR [rsi]				; Add the current element of the array to the running total
	add rsi, TYPE WORD			; Increment the array pointer
	loop L1

	ret							; The return value is stored in rax

sum_16_bit_array ENDP

outer PROC
; Doesn't work as expected
	mov eax, 123h
	call inner				; Pushes address of 'mov eax, 456h' instruction onto stack, because that's the next instruction
	inner PROC
		mov eax, 456h
		ret					; First time, pops the address of 'mov eax, 456h' instruction into rip, so that will be the next instruction. Second time, pops the instruction after the call to outer into rip, because that was the next thing on the stack.
	inner ENDP
	ret						; Program never reaches here
outer ENDP

add_four PROC
; -------------------------------------------------------
; Args:
;	rcx, rdx, r8, r9: Each contains an integer to be added
; Returns:
;	rax: Contains the sum of the four passed-in parameters
; -------------------------------------------------------

	mov rax, rcx
	add rax, rdx
	add rax, r8
	add rax, r9
	ret
add_four ENDP

Ex2 PROC
	push 10
	push 20
	call Ex2Sub				; Push the address of the 'pop rax' instruction on the next line
	pop rax					; Control flow never reaches here
	ret
Ex2 ENDP

Ex2Sub PROC
	pop rax					; Pop the address of the 'pop rax' instruction following the call to Ex2Sub
	ret						; Pop 20 into the instruction pointer, which causes an access violation exception because this process is not allowed to access that address
Ex2Sub ENDP

Ex4 PROC
	mov eax, 40h
	mov rsi, OFFSET Here
	push rsi
	jmp Ex4Sub
Here:
	mov eax, 30h
	ret
Ex4 ENDP

Ex4Sub PROC
	ret
Ex4Sub ENDP

Ex5 PROC
	mov edx, 0
	mov eax, 40h
	push rax
	call Ex5Sub
	ret
Ex5 ENDP

Ex5Sub PROC
	pop rax
	pop rdx
	push rax
	ret
Ex5Sub ENDP

Ex6 PROC
	mov eax, 10h
	mov esi, 0
	call proc_1
	add esi, 4
	add eax, 10h
	mov DWORD PTR ex6_array[rsi], eax
	ret
Ex6 ENDP

proc_1 PROC
	call proc_2
	add esi, 4
	add eax, 10h
	mov DWORD PTR ex6_array[rsi], eax
	ret
proc_1 ENDP

proc_2 PROC
	call proc_3
	add esi, 4
	add eax, 10h
	mov DWORD PTR ex6_array[rsi], eax
	ret
proc_2 ENDP

proc_3 PROC
	mov DWORD PTR ex6_array[rsi], eax
	ret
proc_3 ENDP

end