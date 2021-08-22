IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

.data
	consonants BYTE "BCDFGHJKLMNOPQRSTVWXYZ"
.code

;--------------------------------------------------------------------------------------------------------------------------------------------
is_character_in_set PROC
	set_pointer EQU [ebp + 8]
	num_elements_in_set EQU [ebp + 12]
	character EQU [ebp + 16]

; Receives:
;	First stack parameter (BYTE PTR) = Pointer to an array of BYTEs which represents the set of characters to search within
;	Second stack parameter (DWORD) = The number of elements in the character set
;	Third stack parameter (BYTE) = The character to search for in the set
; Returns:
;	Nothing, but sets the zero flag to 1 if the character was found, and sets the zero flag to 0 if the character was not found.
;--------------------------------------------------------------------------------------------------------------------------------------------

	push ebp
	mov ebp, esp

	pushad

	mov ecx, num_elements_in_set
	mov edi, set_pointer
	mov al, character

	cld
	repne scasb

	dec edi
	cmp BYTE PTR [edi], al
	
	popad
	mov esp, ebp
	pop ebp
	ret 12
is_character_in_set ENDP


test_is_character_in_set PROC
	push "C"
	push LENGTHOF consonants
	push OFFSET consonants
	call is_character_in_set

	push "Z"
	push LENGTHOF consonants
	push OFFSET consonants
	call is_character_in_set

	push "?"
	push LENGTHOF consonants
	push OFFSET consonants
	call is_character_in_set

	ret
test_is_character_in_set ENDP

end