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
	target1 BYTE "Johnson,Calvin", 0
	target2 BYTE "Johnson Calvin", 0
	target3 BYTE "Johnson,Calvin,", 0

.code

Str_nextWord PROC
	delimited_string EQU [ebp + 8]
	delimiter EQU [ebp + 12]

	push ebp
	mov ebp, esp

	push ecx
	push edi

	INVOKE Str_length, delimited_string
	mov ecx, eax							; Store the length of the string in ecx to limit the number of loop iterations

	mov edi, delimited_string
	mov al, delimiter

	cld
	repne scasb

	cmp BYTE PTR [edi], 0
	je no_delimiter

	mov eax, edi
	dec edi
	mov BYTE PTR [edi], 0
	xor edi, edi
	jmp done

no_delimiter:
	test edi, edi
done:
	pop edi
	pop ecx

	mov esp, ebp
	pop ebp
	ret 8
Str_nextWord ENDP

p95 PROC
	; Write a procedure called Str_nextWord that scans a string for the first occurrence of a certain delimiter character and replaces the delimiter with a null byte.
	; There are two input parameters: a pointer to the string and the delimiter character.
	; After the call, if the delimiter was found, the Zero flag is set and EAX contains the offset of the next character after the delimiter.
	; Otherwise, the Zero flag is clear and EAX is undefined.

	; The following example passes the address of target and a comma as the delimiter:

	; .data
	;	target BYTE "Johnson,Calvin",0
	; .code
	;	INVOKE Str_nextWord, ADDR target, ','
	;	jnz notFound

	push ebp
	mov ebp, esp

	push ","
	push OFFSET target1
	call Str_nextWord

	push ","
	push OFFSET target2
	call Str_nextWord

	push ","
	push OFFSET target3
	call Str_nextWord

	mov esp, ebp
	pop ebp
	ret
p95 ENDP

end