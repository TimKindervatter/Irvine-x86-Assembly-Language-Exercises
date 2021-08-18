IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

WriteString PROTO
Crlf PROTO

.data
	before_removing BYTE "Before removing characters: ", 0
	after_removing BYTE "After removing characters: ", 0

	target BYTE "abcxxxxdefghijklmop", 0
	target2 BYTE "abcxxx", 0
	target3 BYTE "abc", 0

.code

Str_remove PROC
	p_location_to_remove_characters EQU [ebp + 8]
	num_characters_to_remove EQU [ebp + 12]

	push ebp
	mov ebp, esp

	pushad

	mov esi, p_location_to_remove_characters
	add esi, num_characters_to_remove							; Point esi to the first character to be preserved in the string
	mov edi, p_location_to_remove_characters

	cld

; Starting with the first character after the ones to be removed, copy the rest of the string into the location passed in (thus overwriting the characters to be removed)
; Stop when the null terminator is reached
loop_head:
	lodsb
	stosb
	cmp al, 0				; Was the character we just copied the null terminator?
	je done					; If so, we're done, exit the loop
	jmp loop_head			; Otherwise, start another loop iteration

done:
	popad

	mov esp, ebp
	pop ebp
	ret 8
Str_remove ENDP


remove_characters_and_print PROC
	string EQU [ebp + 8]
	string_pointer_offset EQU [ebp + 12]
	num_characters EQU [ebp + 16]

	push ebp
	mov ebp, esp

	pushad

	mov edx, OFFSET before_removing
	call WriteString
	mov edx, string
	call WriteString
	call Crlf

	; Populate eax with the pointer to the first character to be removed
	mov eax, string
	add eax, string_pointer_offset

	mov ebx, num_characters

	push ebx
	push eax
	call Str_remove

	mov edx, OFFSET after_removing
	call WriteString
	mov edx, string
	call WriteString
	call Crlf

	popad

	mov esp, ebp
	pop ebp
	ret 12
remove_characters_and_print ENDP


p93 PROC
	; Write a procedure named Str_remove that removes n characters from a string. 
	; Pass a pointer to the position in the string where the characters are to be removed.
	; Pass an integer specifying the number of characters to remove.
	; The following code shows how to remove "xxxx" from target:

	; .data
	; 	target BYTE "abcxxxxdefghijklmop",0
	; .code
	;	INVOKE Str_remove, ADDR [target+3], 4

	push ebp
	mov ebp, esp

	string_offset = 3
	num_chars = 4

	mov eax, string_offset		
	mov ebx, num_chars		 
	
	push ebx
	push eax
	push OFFSET target
	call remove_characters_and_print

	string_offset = 3
	num_chars = 3

	mov eax, string_offset		
	mov ebx, num_chars		 
	
	push ebx
	push eax
	push OFFSET target2
	call remove_characters_and_print

	string_offset = 3
	num_chars = 0

	mov eax, string_offset		
	mov ebx, num_chars		 
	
	push ebx
	push eax
	push OFFSET target3
	call remove_characters_and_print

	mov esp, ebp
	pop ebp
	ret
p93 ENDP

end