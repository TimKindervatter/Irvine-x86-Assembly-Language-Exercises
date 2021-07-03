TITLE Problem 6-4

.386
.model flat, stdcall
.stack 4096

WriteString PROTO
ReadInt PROTO
Crlf PROTO

.data
	gradeAverage DWORD ?
	credits DWORD ?
	OkToRegister BYTE ?

	outOfRangeMessage BYTE "The number of credits must be between 1 and 30", 0
	gradePrompt BYTE "Enter the grade average: ", 0
	creditsPrompt BYTE "Enter the number of credits: ", 0

	canRegisterMessage BYTE "The student can register", 0
	cannotRegisterMessage BYTE "The student cannot register", 0
.code

p64_test PROC
	mov edx, OFFSET gradePrompt
	call WriteString
	call ReadInt
	mov [gradeAverage], eax

		mov edx, OFFSET creditsPrompt
	call WriteString
	call ReadInt
	mov [credits], eax

	call p64
	cmp [OkToRegister], 0
	jz cannot_register
	jnz can_register

cannot_register:
	mov edx, OFFSET cannotRegisterMessage
	call WriteString
	call Crlf
	ret
can_register:
	mov edx, OFFSET canRegisterMessage
	call WriteString
	call Crlf
	ret
	
p64_test ENDP

p64 PROC
	; Using the College Registration example from Section 6.7.3 as a starting point, do the following:
	;	* Recode the logic using CMP and conditional jump instructions instead of .IF and .ELSEIF directives
	;	* Perform range checking on the credits value; it cannot be less than 1 or greater than 30. If an invalid entry is discovered, display an appropriate error message.
	;	* Prompt the user for the grade average and credits values.
	;	* Display a message that shows the outcome of the evaluation, such as "The student can register" or "The student cannot register".

	cmp [credits], 1
	jl invalid_credits
	cmp [credits], 30
	jg invalid_credits

	mov [OkToRegister], 0				; Assume student cannot register

	cmp [gradeAverage], 350
	jae can_register					; If the grade average is > 350, student can register

	cmp [gradeAverage], 250				; Can only get here if first condition is false
	jle last_condition					; If the first predicate of the second case is false, short-circuit the AND operation. We still need to check the third case, so skip there.
	cmp [credits], 16					; If we've gotten here, then the first predicate is true
	jle can_register					; If the second predicate is also true, the student can register

last_condition:
	cmp [credits], 12					; If we've gotten here, first two cases are false
	jg cannot_register					; If the third case is also false, student cannot register
										; If the third case is true, fall through to the can_register case
can_register:
	mov [OkToRegister], 1
cannot_register:
	ret
invalid_credits:
	push edx
	mov edx, OFFSET outOfRangeMessage
	call WriteString
	pop edx
	ret
p64 ENDP

end