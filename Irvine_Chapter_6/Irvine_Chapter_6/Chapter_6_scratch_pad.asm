.data
	lowercase BYTE "this is a lowercase string", 0
	uppercase BYTE LENGTHOF lowercase DUP(0)

	ALIGN 8
	;intArray SWORD 0,0,0,0,1,20,35,-12,66,4,0
	;intArray SWORD 1,0,0,0 ; alternate test data
	;intArray SWORD 0,0,0,0 ; alternate test data
	intArray SWORD 0,0,0,1 ; alternate test data
	noneMsg BYTE "A non-zero value was not found",0

	signed_array SWORD -5, -42, -11, 7, 2, 13
	sentinel SWORD 0									; The sentinel value is used as a backstop to prevent a loop of undefined length, in case the loop_until_nonnegative procedure is 
														; accidentally provided with an array length that is too long. It can also be used as an error code to report the 'not found' state.

	signed_array2 SWORD -5, -42, -11, -7, -2, -13
	sentinel2 SWORD 0

	signed_array3 SWORD 5, 42, 11, 7, -2, -13
	sentinel3 SWORD -1									; The sentinel value needs to be negative for the loop_until_negative prodecure.

	signed_array4 SWORD 5, 42, 11, 7, 2, 13
	sentinel4 SWORD -1

	ALIGN 8
	if_while_array DWORD 10, 60, 20, 33, 72, 89, 45, 65, 72, 18
	sample DWORD 50

	ALIGN 8
	X DWORD ?

.code

ch6_scratch_pad PROC
	call ch6_review

	call sec_65_review

	call if_inside_while

	mov rax, OFFSET signed_array			; Start at the base address of the array
	mov rcx, LENGTHOF signed_array			; Set the maximum number of loops as the length of the array
	call loop_until_nonnegative
	xor rdx, rdx
	mov dx, SWORD PTR [rax]					; rdx contains 7

	mov rax, OFFSET signed_array2			; Start at the base address of the array
	mov rcx, LENGTHOF signed_array2			; Set the maximum number of loops as the length of the array
	call loop_until_nonnegative
	xor rdx, rdx
	mov dx, SWORD PTR [rax]					; rdx contains the sentinel2 value -1

	mov rax, OFFSET signed_array3			; Start at the base address of the array
	mov rcx, LENGTHOF signed_array3			; Set the maximum number of loops as the length of the array
	call loop_until_negative
	xor rdx, rdx
	mov dx, SWORD PTR [rax]					; rdx contains -2

	mov rax, OFFSET signed_array4			; Start at the base address of the array
	mov rcx, LENGTHOF signed_array4			; Set the maximum number of loops as the length of the array
	call loop_until_negative
	xor rdx, rdx
	mov dx, SWORD PTR [rax]					; rdx contains the sentinel value -1

	mov rax, OFFSET intArray
	call loop_until_nonzero
	
	mov rax, OFFSET noneMsg
	call loop_until_zero

	call sec_63_review

	mov rax, OFFSET lowercase
	mov rbx, OFFSET uppercase
	mov rcx, LENGTHOF lowercase
	call to_upper
	call to_upper_in_place

	mov rax, OFFSET uppercase
	mov rbx, OFFSET lowercase
	call to_lower
	call to_lower_in_place
	ret
ch6_scratch_pad ENDP

to_upper PROC
;------------------------------------------
; Args: 
;	rax contains base address of null-terminated source string to convert to uppercase
;	rbx contains base address of null-terminated destination string, which will be uppercase
;	rcx contains the length of the strings
;------------------------------------------
	push rcx							; Save the value of rcx, since this procedure will overwrite it
	push rdx							; Save the value of rdx, since this procedure will overwrite it

	xor rdx, rdx						; Zero out rdx
	mov rsi, 0							; Index starting at 0

L1:
	mov dl, BYTE PTR [rax + rsi]
	and dl, 11011111b
	mov BYTE PTR [rbx + rsi], dl

	inc rsi
	loop L1

	pop rdx								; Restore the value of rdx to what it was before the function call
	pop rcx								; Restore the value of rcx to what it was before the function call
	ret
to_upper ENDP

to_upper_in_place PROC
;------------------------------------------
; Args: 
;	rax contains base address of null-terminated source string to convert to uppercase
;	rcx contains the length of the string
;------------------------------------------

	push rcx

L1:
	and BYTE PTR [rax], 11011111b

	inc rax
	loop L1

	pop rcx
	ret
to_upper_in_place ENDP

to_lower PROC
;------------------------------------------
; Args: 
;	rax contains base address of null-terminated source string to convert to lowercase
;	rbx contains base address of null-terminated destination string, which will be lowercase
;	rcx contains the length of the strings
;------------------------------------------
	push rcx							; Save the value of rcx, since this procedure will overwrite it
	push rdx							; Save the value of rdx, since this procedure will overwrite it

	xor rdx, rdx						; Zero out rdx
	mov rsi, 0							; Index starting at 0

L1:
	mov dl, BYTE PTR [rax + rsi]
	or dl, 00100000b
	mov BYTE PTR [rbx + rsi], dl

	inc rsi
	loop L1

	pop rdx								; Restore the value of rdx to what it was before the function call
	pop rcx								; Restore the value of rcx to what it was before the function call
	ret
to_lower ENDP

to_lower_in_place PROC
;------------------------------------------
; Args: 
;	rax contains base address of null-terminated source string to convert to lowercase
;	rcx contains the length of the string
;------------------------------------------

	push rcx

L1:
	or BYTE PTR [rax], 00100000b

	inc rax
	loop L1

	pop rcx
	ret
to_lower_in_place ENDP

sec_62_review PROC
; 1. Write a single instruction using 16-bit operands that clears the high 8 bits of ax but does not change the 8 low bits
	xor rax, rax
	mov ax, 0FFFFh
	and ax, 00FFh

; 2. Write a single instruction using 16-bit operands that sets the high 8 bits of ax and does not change the low 8 bits
	xor rax, rax
	or ax, 0FF00h

; 3. Write a single instruction (other than NOT) that negates each bit in EAX
	mov eax, 0AAAAAAAAh
	mov ebx, eax

	xor eax, 0FFFFFFFFh
	not ebx

; 4. Write instructions that set the zero flag if the 32-bit value in EAX is even and clear the zero flag if EAX is odd
	mov eax, 0
	test eax, 1					; Even numbers always have the least-significant bit (ones place) clear and odd numbers have the least significant bit set.
								; Using the TEST instruction effectively ANDs the contents of EAX with 1, which results in 0 (and thus ZR = 1) if the LSbit is not set 
								; and results in 1 (and thus ZR = 0) if it is set.

; 5. Write a single instruction that converts an uppercase character in AL to lowercase but does not modify AL if it already contains a lowercase letter.
	mov al, lowercase[0]
	or al, 00100000b
	mov lowercase[0], al

	ret
sec_62_review ENDP

loop_until_nonzero PROC
;------------------------------------
; Args:
;	rax: Contains the base address of the array to loop through
;------------------------------------

	xor rbx, rbx
not_done:
	cmp SWORD PTR [rax], 0
	jnz done						; Once we've found a nonzero value, exit the infinite loop

	add rax, TYPE SWORD
	inc rbx							; Keep a count of how many elements we've checked so far
	jmp not_done					; Loops infinitely until we find a nonzero value

done:
	ret
loop_until_nonzero ENDP

loop_until_zero PROC
;------------------------------------
; Args:
;	rax: Contains the base address of the array to loop through
;------------------------------------

	xor rbx, rbx
not_done:
	cmp SWORD PTR [rax], 0
	jz done							; Once we've found a zero, exit the infinite loop

	add rax, TYPE BYTE
	inc rbx							; Keep a count of how many elements we've checked so far
	jmp not_done					; Loops infinitely until we find a zero

done:
	ret
loop_until_zero ENDP

sec_63_review PROC
Target:
	mov ax,8109h
	cmp ax,26h
	jg Target						; Does not jump because jg compares signed operands, so we have 8109h < 26h (-32503 < 38)

	ret
sec_63_review ENDP

loop_until_nonnegative PROC
; ----------------------------------------------------
; Searches array of SWORDs for the first nonnegative number
; Args:
;	rax: Contains pointer to the base address of the array
;	rcx: Contains length of array
; Returns:
;	rax: Contains pointer to the first nonnegative element of the array, if present. Otherwise, returns pointer to the sentinel value.
; ----------------------------------------------------

L1:
	test WORD PTR [rax], 8000h				; Test the sign bit of the current element
	pushfq									; Store the flags so they don't get overwritten by the next instruction
	add rax, TYPE SWORD						; Point to the next element of the array
	popfq									; Restore the flags from the sign bit test
	loopnz L1								; If the element was negative, the sign bit was set, so the result of the test operation would be nonzero so ZR = 0. In this case we loop.
											; If the element was positive, the sign bit was not set, so the result of the test operation would be zero so ZR = 1. In this case we break.

	jnz quit								; If we reached the maximum number of loop iterations before finding a nonnegative element, jnz will still be true and we'll jump to the return statement
											; In this case, rax will point to the sentinel value.
	sub rax, TYPE SWORD						; If we did find a nonnegative element, jnz will be false and we'll get here. We incremented the array pointer even after finding the first nonnegative
											; element, so we need to back up one so that we're pointing at the first nonnegative element when we return
quit:
	ret
loop_until_nonnegative ENDP

loop_until_negative PROC
; ----------------------------------------------------
; Searches array of SWORDs for the first negative number
; Args:
;	rax: Contains pointer to the base address of the array
;	rcx: Contains length of array
; Returns:
;	rax: Contains pointer to the first negative element of the array, if present. Otherwise, returns pointer to the sentinel value.
; ----------------------------------------------------

L1:
	test WORD PTR [rax], 8000h				; Test the sign bit of the current element
	pushfq									; Store the flags so they don't get overwritten by the next instruction
	add rax, TYPE SWORD						; Point to the next element of the array
	popfq									; Restore the flags from the sign bit test
	loopz L1								; If the element was negative, the sign bit was set, so the result of the test operation would be nonzero so ZR = 0. In this case we loop.
											; If the element was positive, the sign bit was not set, so the result of the test operation would be zero so ZR = 1. In this case we break.

	jz quit								; If we reached the maximum number of loop iterations before finding a nonnegative element, jnz will still be true and we'll jump to the return statement
											; In this case, rax will point to the sentinel value.
	sub rax, TYPE SWORD						; If we did find a nonnegative element, jnz will be false and we'll get here. We incremented the array pointer even after finding the first nonnegative
											; element, so we need to back up one so that we're pointing at the first nonnegative element when we return
quit:
	ret
loop_until_negative ENDP

if_inside_while PROC
	mov rbx, LENGTHOF if_while_array			; ArraySize
	mov edx, sample								; sample
	mov rdi, 0									; index
	mov rax, 0									; sum
L1:
	; while (index < ArraySize)
	cmp rdi, rbx
	jge done

	; if (array[index] > sample)
	cmp if_while_array[rdi*TYPE if_while_array], edx
	jle skip_if_statement

	; sum += array[index]
	add eax, if_while_array[rdi*TYPE if_while_array]

skip_if_statement:
	; index++
	inc rdi
	jmp L1

done:
	ret
if_inside_while ENDP

sec_65_review PROC
	; if (ebx > ecx) X = 1
	cmp ebx, ecx
	jle skip
	mov DWORD PTR [X], 1

skip:
	; if (edx <= ecx) X = 1 else X = 2
	mov DWORD PTR [X], 2					; Assume the else case, so assign X = 2
	cmp edx, ecx
	jg done									; If the else case was correct, we're done
	mov DWORD PTR [X], 1					; If the if case was correct, need to assign X = 1

done:
	ret
sec_65_review ENDP

ch6_review PROC
; 1.
	mov bx, 0FFFFh
	and bx,   06Bh							; Produces 0x006B

; 2.
	mov bx, 91BAh
	and bx,   92h							; Produces 0x0092

; 3.
	mov bx, 0649Bh
	or bx,     3Ah							; Produces 0x64BB

; 4.
	mov bx, 029D6h
	xor bx,  8181h							; Produces 0xA857

; 5.
	mov ebx, 0AFAF649Bh
	or ebx,   3A219604h						; Produces 0xBFAFF69F

; 6.
	mov rbx, 0AFAF649Bh
	xor rbx, 0FFFFFFFFh						; Produces 0xFFFFFFFF50509B64

; 7.
	mov al, 01101111b
	and al, 00101101b						; al = 00101101b = 0x2D

	mov al, 6Dh
	and al, 4Ah								; al = 0x48

	mov al, 00001111b
	or al, 61h								; al = 0x6F

	mov al, 94h
	xor al, 37h								; al = 0xA3

; 8.
	mov al, 7Ah
	not al									; al = 0x85

	mov al, 3Dh
	and al, 74h								; al = 0x34

	mov al, 9Bh
	or al,  35h								; al = 0xBF

	mov al,  72h
	xor al, 0DCh							; al 0xAE

; 9.
	mov al,  00001111b
	test al, 00000010b						; a. CF=0 ZF=0 SF=0			0x0F & 0x02 = 0x02, which is nonzero, positive, and does not carry out of al

	mov al, 00000110b
	cmp al, 00000101b						; b. CF=0 ZF=0 SF=0			6 - 5 = 1, which is nonzero, positive, and does not carry

	mov al, 00000101b
	cmp al, 00000111b						; c. CF=1 ZF=0 SF=1			5 - 6 = -1 which is nonzero, negative, and carries because result must be 2's complemented

; 10. Which conditional jump instruction executes a branch based on the contents of ECX?
; jecxz
	mov ecx, 1
	jecxz done
	mov eax, 100

done:

; 11. How are JA and JNBE affected by the Zero and Carry flags?
; They jump if ZF = 0 and CF = 0 (i.e. if the result of an implicit unsigned subtraction is nonzero and positive)

; 12. What will be the final value in EDX after this code executes?
	 mov edx, 1
	 mov eax, 7FFFh
	 cmp eax, 8000h
	 jl L1									; Compare signed, but recall that we're comparing 32-bit registers, so we're comparing 0x00007FFF to 0x00008000, so both are positive
											; Thus we're testing whether +32767 < +32768, which is true, so jump
	 mov edx, 0
L1:											; edx is 1 here

; 13. What will be the final value in EDX after this code executes?
	 mov edx, 1
	 mov eax, 7FFFh
	 cmp eax, 8000h
	 jb L2									; Compare unsigned, which is identical to previous problem because we're still using 32-bit registers
	 mov edx, 0
L2:											; edx is 1 here

; 14. What will be the final value in EDX after this code executes?
	 mov edx, 1
	 mov eax, 7FFFh
	 cmp eax, 0FFFF8000h
	 jl L3									; Compare signed with 32-bit registers, so we're comparing 0x00007FFF with 0xFFFF8000. That is, +32767 < -32768? No, so don't jump
	 mov edx, 0
L3:											; edx is 0 here

; 15. Does the following code jump to the label Target?
; Yes, -30 > -50 using signed comparison
	mov eax,-30
	cmp eax,-50
	; jg Target
	mov eax, 0

; 16. Does the following code jump to the label Target?
; Yes, ja is unsigned comparison, so -42 is interpreted as 0xFFD6, or +65494, which is greater than 26.
	mov eax, -42
	cmp eax, 26
	; ja Target
	mov eax, 0

Target:

; 17. What will be the value of RBX after the following instructions execute?
	mov rbx, 0FFFFFFFFFFFFFFFFh
	and rbx, 80h							; rbx = 0x0000000000000080

; 18. What will be the value of RBX after the following instructions execute?
	mov rbx, 0FFFFFFFFFFFFFFFFh
	and rbx, 808080h						; rbx = 0x0000000000808080

; 19. What will be the value of RBX after the following instructions execute?
	mov rbx, 0FFFFFFFFFFFFFFFFh
	and rbx, 80808080h						; rbx = 0xFFFFFFFF80808080

	ret
ch6_review ENDP


end