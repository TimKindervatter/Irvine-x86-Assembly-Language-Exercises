IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

INCLUDE Irvine32.inc

.data

.code

insert_null_terminator PROC
	string_pointer equ [ebp + 8]

	push ebp
	mov ebp, esp

	pushad

	; Search for the carriage return character, which indicates the end of the user-entered string
	mov edi, string_pointer
	mov al, 0Dh
	repne scasb 						
	dec edi
	
	mov BYTE PTR [edi], 0				; Insert Null terminator

	popad

	mov esp, ebp
	pop ebp

	ret 4
insert_null_terminator ENDP
end