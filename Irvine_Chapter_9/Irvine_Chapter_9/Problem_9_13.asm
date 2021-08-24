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

.data
	before_trimming BYTE "Before trimming: ", 0
	after_trimming BYTE "After trimming: ", 0

	string1 BYTE "###ABC", 0
	string2 BYTE "###AB#C", 0
	string3 BYTE "#", 0
	string4 BYTE "ABC", 0
	string5 BYTE "ABC#", 0

.code

Str_trim_front PROC
	string_pointer EQU [ebp + 8]
	character_to_trim EQU [ebp + 12]	

	push ebp
	mov ebp, esp

	mov esi, string_pointer					; Pointer to beginning of string
	mov edi, string_pointer					; Pointer which will be used to point to first character that will not be trimmed
	mov al, character_to_trim

	; Search for the first occurrence of a character that is not the character to trim
	cld
	repe scasb
	dec edi

loop_head:
	; Starting with the first non-trimmable character, copy each character to the front of the string, overwriting the characters to trim
	mov al, [edi]
	mov [esi], al

	; Once edi points to the null terminator, we've reached the end of the string
	cmp BYTE PTR [edi], 0
	je place_null_terminator

	inc edi
	inc esi
	jmp loop_head
	
place_null_terminator:
	mov BYTE PTR [esi], 0					; Place a new null terminator where esi points, which is the new endpoint for the trimmed string
done:
	mov esp, ebp
	pop ebp
	ret 8
Str_trim_front ENDP


trim_hash_symbol PROC
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

	; Trim the @ symbol from the end of the string
	push "#"
	push string_to_trim
	call Str_trim_front

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
trim_hash_symbol ENDP

p913 PROC
	; Create a variant of the Str_trim procedure that lets the caller remove all instances of a leading character from a string.
	; For example, if you were to call it with a pointer to the string "###ABC" and pass it the # character, the resulting string would be "ABC"

	push OFFSET string1
	call trim_hash_symbol

	push OFFSET string2
	call trim_hash_symbol

	push OFFSET string3
	call trim_hash_symbol

	push OFFSET string4
	call trim_hash_symbol

	push OFFSET string5
	call trim_hash_symbol

	ret
p913 ENDP

end