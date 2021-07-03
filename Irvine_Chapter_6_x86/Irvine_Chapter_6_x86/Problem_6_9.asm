TITLE Problem 6-9

.386
.model flat, stdcall
.stack 4096

WriteString PROTO
WriteInt PROTO
Crlf PROTO

.data
	lower_bounds BYTE 5, 2, 4, 1, 3
	upper_bounds BYTE 9, 5, 8, 4, 6

	PIN1 BYTE 6, 3, 7, 2, 5				; Valid
	PIN2 BYTE 2, 4, 1, 5, 7				; Invalid in position 1
	PIN3 BYTE 7, 9, 2, 6, 2				; Invalid in position 2
	PIN4 BYTE 8, 2, 1, 9, 5				; Invalid in position 3
	PIN5 BYTE 9, 3, 5, 8, 1				; Invalid in position 4
	PIN6 BYTE 6, 4, 7, 4, 9				; Invalid in position 5

	PIN_valid BYTE "PIN is valid", 0
	PIN_invalid BYTE "PIN is invalid in digit ", 0
.code

p69_test PROC
	; Create a procedure named Validate_PIN that receives a pointer to an array of BYTEs containing a 5-digit PIN.
	; Declare two arrays to hold the minimum and maximum range values, and use these arrays to validate each digit of the PIN.
	; If any digit is found to be outside its valid range, immediately return the digit's position (beteween 1 and 5) in the EAX register.
	; If the entire PIN is valid, return 0 in EAX. Preserve all other registers between calls to the procedure.
	; Write a test program that calls Validate_PIN at least four times, using both valid and invalid byte arrays.
	; The table of valid digit ranges is as follows:
	; Digit Number Range
	;	1	  5 to 9
	;	2	  2 to 5
	;	3	  4 to 8
	;	4	  1 to 4
	;	5	  3 to 6

	mov esi, OFFSET PIN1
	call p69

	mov esi, OFFSET PIN2
	call p69

	mov esi, OFFSET PIN3
	call p69

	mov esi, OFFSET PIN4
	call p69

	mov esi, OFFSET PIN5
	call p69

	mov esi, OFFSET PIN6
	call p69

	ret
	
p69_test ENDP

p69 PROC
	push eax
	push edx

	call Validate_PIN
	cmp eax, 0
	jz valid
	jnz invalid

valid:
	mov edx, OFFSET PIN_valid
	call WriteString
	jmp done

invalid:
	mov edx, OFFSET PIN_invalid
	call WriteString
	call WriteInt						; The digit that was out of range is in eax from the earlier call to Validate_PIN

done:
	call Crlf
	pop edx
	pop eax
	ret
p69 ENDP

Validate_PIN PROC
;-----------------------------------------------------------------
; Args:
;	esi: Contains base address of PIN 
; Returns:
;	eax: Number of digit that is out of range (0 if the whole PIN is valid)
;-----------------------------------------------------------------

	push edi
	push ebx
	push ecx

	mov edi, 0							; Index into the bounds arrays
	mov ecx, LENGTHOF lower_bounds
loop_head:
	mov ebx, [esi]						; CMP cannot compare two memory operands, so we need to move the current digit into a register

	; If the current digit is out of range, jump to the error handling branch
	cmp bl, lower_bounds[edi]
	jb error
	cmp bl, upper_bounds[edi]
	ja error
	
	inc esi								; Increment the pointer into the PIN array
	inc edi								; Increment the index into bounds arrays
	loop loop_head
		
	mov eax, 0							; If we've gotten here, then no digit was out of range, so return 0 in eax to indicate that the PIN is valid
	jmp no_error						; Skip over the error handling branch and return from the procedure

error:
	mov eax, edi						; The digit number will be returned in eax
	inc eax								; The digit number is the current index plus 1

no_error:
	pop ecx
	pop ebx
	pop edi
	ret
Validate_PIN ENDP

end