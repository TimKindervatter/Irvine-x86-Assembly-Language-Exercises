IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

;-----------------------------------------------------------
WriteString PROTO

; Writes a null-terminated string to the console window.
; Pass the string's offset in the EDX register.
;-----------------------------------------------------------

;-----------------------------------------------------------
Crlf PROTO

; Writes a newline to the console
;-----------------------------------------------------------

Str_length PROTO,
	pString: PTR BYTE

.data
	filter_set BYTE "%#!;$&*", 0

	before_trimming BYTE "Before trimming: ", 0
	after_trimming BYTE "After trimming: ", 0

	string1 BYTE "ABC#$&", 0
	string2 BYTE "String $;*to trim!;*&", 0
	string3 BYTE "&%!;", 0
	string4 BYTE "String to trim", 0
	string5 BYTE "%#;*String to trim", 0
	string6 BYTE 0									; Empty string
.code

Str_trim_set PROC
	string_pointer EQU [ebp + 8]
	filter_set_pointer EQU [ebp + 12]

	push ebp
	mov ebp, esp

	mov edi, string_pointer
	INVOKE Str_length, edi					; Populates eax with the length of the string
	cmp eax, 0								; If the string's length is 0, we're done
	je done

	mov ecx, eax							
	inc ecx									; Add one extra iteration for null terminator
	add edi, eax							; edi currently points one past the end of the string

string_loop_head:
	dec edi									; On each iteration, back up the string pointer to the next character to consider for trimming
	mov al, [edi]							; Store the current character in al to be compared to each element of the filter set in the inner loop
	mov esi, filter_set_pointer				; Reset esi to the start of the filter set
filter_set_loop_head:
	cmp [esi], al							; Compare the current element of the filter set to the current character of the string
	je continue								; If they match, the current character is to be trimmed so continue on to the next iteration
	
	inc esi									; Otherwise, increment esi to point to the next element of the filter set
	cmp BYTE PTR [esi], 0					; If we've reached the end of the filter set then the current character of the string does not need to be trimmed
	je insert_null_terminator				; If that's the case, we need to insert the null terminator to trim the end of the string
	jmp filter_set_loop_head				; Otherwise, we haven't checked all the characters in the filter set yet, so start the next iteration over the filter set

continue:
	loop string_loop_head

insert_null_terminator:
	mov BYTE PTR [edi + 1], 0				; Once we've found the first character of the string not in the filter set, place the null terminator directly after it
done:
	mov esp, ebp
	pop ebp
	ret 8
Str_trim_set ENDP


trim_filter_set PROC
	string_to_trim EQU [ebp + 8]

	; Preamble
	push ebp
	mov ebp, esp

	push edx

	; Show the string before it is trimmed
	mov edx, OFFSET before_trimming
	call WriteString

	mov edx, string_to_trim
	call WriteString
	call Crlf

	; Trim all elements of the filter set from the end of the string
	push OFFSET filter_set
	push string_to_trim
	call Str_trim_set

	; Show the trimmed string
	mov edx, OFFSET after_trimming
	call WriteString

	mov edx, string_to_trim
	call WriteString
	call Crlf
	call Crlf

	; Clean up
	pop edx
	
	mov esp, ebp
	pop ebp
	ret 4
trim_filter_set ENDP


p914 PROC
	; Create a variant of the Str_trim procedure that lets the caller remove all instances of a set of characters from the end of a string.
	; For example, if you were to call it with a pointer to the string "ABC#$&" and pass it a pointer to an array of filter characters containing "%#!;$&*", the resulting string would be "ABC"

	push OFFSET string1
	call trim_filter_set

	push OFFSET string2
	call trim_filter_set

	push OFFSET string3
	call trim_filter_set

	push OFFSET string4
	call trim_filter_set

	push OFFSET string5
	call trim_filter_set

	push OFFSET string6
	call trim_filter_set

	ret
p914 ENDP

end