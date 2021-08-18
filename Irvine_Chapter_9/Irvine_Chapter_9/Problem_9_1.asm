IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.686
.model flat, stdcall
.stack 4096

Str_length PROTO,
    pString: PTR BYTE

.data
	source_string1 BYTE "This is the string to be copied", 0
	SOURCE_STRING_LENGTH1 = ($ - source_string1)
	target_string1 BYTE SOURCE_STRING_LENGTH1 DUP(?)

	source_string2 BYTE "This is the string to be copied", 0
	SOURCE_STRING_LENGTH2 = ($ - source_string2)
	target_string2 BYTE SOURCE_STRING_LENGTH2 DUP(?)

.code
;--------------------------------------------------------
; Str_copyN
; Copies a string from source to target, up to a maximum umber of characters N.
; Requires: the target string must contain enough space to hold a copy of the source string.
; Args:
;	source: Pointer to the source string to be copied from.
;	target: Pointer to the location in memory into which the string will be copied.
;	max_characters: The maximum number of characters that will be copied.
;--------------------------------------------------------
Str_copyN PROC
	source EQU [ebp + 8]
	target EQU [ebp + 12]
	max_characters EQU [ebp + 16]

	push ebp
	mov ebp, esp

	push eax
	push ecx
	push edx
	push esi
	push edi

	INVOKE Str_length, source			; Returns the length of the passed string in EAX

	mov ecx, eax
	inc ecx							; Add one byte for the null terminator

	cmp ecx, max_characters
	cmova ecx, max_characters		; If ecx > max_characters, move max_characters into ecx

	mov esi, source
	mov edi, target

	cld
	rep movsb

	pop edi
	pop esi
	pop edx
	pop ecx
	pop eax

	mov esp, ebp
	pop ebp
	ret 12
Str_copyN ENDP

p91 PROC
	; The Str_copy procedure shown in this chapter does not limit the number of characters to be copied.
	; Create a new version (named Str_copyN) that receives an additional input parameter indicating the maximum number of characters to be copied.

	push ebp
	mov ebp, esp

	mov eax, SOURCE_STRING_LENGTH1
	sub eax, 3
	push eax
	push OFFSET target_string1
	push OFFSET source_string1
	call Str_copyN

	mov eax, SOURCE_STRING_LENGTH2
	add eax, 3
	push eax
	push OFFSET target_string2
	push OFFSET source_string2
	call Str_copyN

	mov esp, ebp
	pop ebp
	ret
p91 ENDP

end