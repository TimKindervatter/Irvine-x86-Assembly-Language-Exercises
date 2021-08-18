IFDEF RAX
	END_IF_X64 EQU END
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
	source_string BYTE "FGH", 0
	target_string BYTE "ABCDE", 10 DUP(0)

.code

Str_concat PROC
	source EQU [ebp + 8]
	target EQU [ebp + 12]

	push ebp
	mov ebp, esp

	pushad

	; Place edi at the end of the target string
	mov edi, target
	mov al, 0

	cld
	repne scasb
	dec edi

	; Copy the contents of the source string onto the end of the target string
	INVOKE Str_length, source

	mov ecx, eax
	mov esi, source
	rep movsb

	popad

	mov esp, ebp
	pop ebp
	ret 8
Str_concat ENDP

p92 PROC
	; Write a procedure named Str_concat that concatenates a source string to the end of a target string. Sufficient space must exist in the target string to accommodate the new characters.
	; Pass pointers to the source and target strings.
	; Here is a sample call:

	; .data
	;	targetStr BYTE "ABCDE",10 DUP(0)
	;	sourceStr BYTE "FGH",0
	; .code
	;	INVOKE Str_concat, ADDR targetStr, ADDR sourceStr

	push ebp
	mov ebp, esp

	push OFFSET target_string
	push OFFSET source_string
	call Str_concat

	mov esp, ebp
	pop ebp
	ret
p92 ENDP

end