IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

Str_length PROTO,
    pString: PTR BYTE

.data
	target_string1 BYTE "123ABC342432", 0
	source_string1 BYTE "ABC", 0

	target_string2 BYTE "123AB3424ABC32", 0
	source_string2 BYTE "ABC", 0

	target_string3 BYTE "123342432", 0
	source_string3 BYTE "ABC", 0

.code

Str_find PROC
	source_string EQU [ebp + 8]
	target_string EQU [ebp + 12]
	
	push ebp
	mov ebp, esp

	push esi
	push edi
	push ebx
	push ecx
	push edx

	mov edi, target_string
	INVOKE Str_length, target_string
	mov ecx, eax
keep_going:
	cmp BYTE PTR [edi], 0
	je done
	mov esi, source_string
	mov al, BYTE PTR [esi]

	cld
	repne scasb				; Search the target string for the first character of the source string

	cmp BYTE PTR [edi], 0
	je not_found

	dec edi					; Back the target pointer up by 1, so it points to the start of the substring
	inc ecx					; Add one back to the loop counter to account for backing up the target pointer
	mov edx, edi			; In case the substring fully matches, populate EAX for the return value

	mov ebx, ecx			; Save the remaining number of characters to iterate over in target string

	repe cmpsb				; Compare the source and destination strings until a pair of characters doesn't match

	mov ecx, ebx			; Restore the number of characters to iterate over in target string

	; Back up the source pointer by 1 and see if the last character was the null-terminator of the source string. If so, we successfully matched the source string and we're done.
	; Otherwise, we only found part of the source string, so we need to repoint esi back to the start of the source string and keep searching within the target string.
	dec esi
	cmp BYTE PTR [esi], 0
	jne keep_going
	jmp found

not_found:
	test edi, edi			; EDI contins a pointer, so it is definitely non-zero. This will clear the zero flag to indicate that the substring wasn't found
found:
	mov eax, edx			; Move the pointer to the first character of the subtring into eax
done:
	pop edx
	pop ecx
	pop ebx
	pop edi
	pop esi

	mov esp, ebp
	pop ebp
	ret 8
Str_find ENDP


p94 PROC
	; Write a procedure named Str_find that searches for the first matching occrrence of a source string inside a target string and returns the matching position.
	; The input parameters should be a pointer to the source string and a pointer to the target string.
	; If a match is found, the procedure sets the Zero flag and EAX points to the matching position in the aarget string.
	; Otherwise, the Zero flag is clear and EAX is undefined.

	; The following code searches for "ABC" and returns with EAX pointing to the "A" character in the target string:
	; .data
	;	target BYTE "123ABC342432", 0
	;	source BYTE "ABC", 0
	;	pos DWORD ?

	; .code
	;	INVOKE Str_find, ADDR source, ADDR target
	;	jnz notFound
	;	mov pos, eax			; store the position value

	push ebp
	mov ebp, esp

	push OFFSET target_string1
	push OFFSET source_string1
	call Str_find

	push OFFSET target_string2
	push OFFSET source_string2
	call Str_find

	push OFFSET target_string3
	push OFFSET source_string3
	call Str_find

	mov esp, ebp
	pop ebp
	ret
p94 ENDP

end