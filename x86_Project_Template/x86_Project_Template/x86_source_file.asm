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

.data
	hello_x86_world BYTE "Hello x86 World!", 0

.code

hello_world_32 PROC
	push ebp
	mov ebp, esp

	push edx

	mov edx, OFFSET hello_x86_world
	call WriteString

	pop edx

	mov esp, ebp
	pop ebp
	ret
hello_world_32 ENDP

end