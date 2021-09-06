IFDEF RAX
	END_IF_NOT_X64 EQU <>
ELSE
	END_IF_NOT_X64 EQU end
ENDIF

END_IF_NOT_X64

;-----------------------------------------------------------
WriteString PROTO

; Writes a null-terminated string to the console window.
; Pass the string's offset in the EDX register.
;-----------------------------------------------------------

.data
	hello_x64_world BYTE "Hello x64 World!", 0

.code

hello_world_64 PROC
	push rbp
	mov rbp, rsp

	push rdx

	mov rdx, OFFSET hello_x64_world
	call WriteString

	pop rdx

	mov rsp, rbp
	pop rbp
	ret
hello_world_64 ENDP

end