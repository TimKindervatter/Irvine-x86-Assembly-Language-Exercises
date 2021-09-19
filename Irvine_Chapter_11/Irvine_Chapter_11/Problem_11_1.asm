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

insert_null_terminator PROTO

.data
	console_handle HANDLE ?

	max_characters_to_read = 80
	string BYTE max_characters_to_read DUP(?)
	num_characters_entered DWORD ?
.code

MyReadString PROC
	string_pointer EQU [ebp + 8]
	max_characters EQU [ebp + 12]

	push ebp
	mov ebp, esp

	push edi

	INVOKE GetStdHandle, STD_INPUT_HANDLE
	mov console_handle, eax
	INVOKE ReadConsole, console_handle, string_pointer, max_characters, ADDR num_characters_entered, 0

	push string_pointer
	call insert_null_terminator

	mov eax, num_characters_entered

	pop edi

	mov esp, ebp
	pop ebp

	ret 8
MyReadString ENDP

p111 PROC
	; Implement your own version of the ReadString procedure, using stack parameters.
	; Pass it a pointer to a string and an integer, indicating the maximum number of characters to be entered.
	; Return a count (in EAX) of the number of characters actually entered.
	; The procedure must input a string from the console and insert a null byte at the end of the string (in the position occupied by 0Dh).
	; See Section 11.1.4 for details on the Win32 ReadConsole function.
	; Write a short program that tests your procedure.

	push max_characters_to_read
	push OFFSET string
	call MyReadString

	mov edx, OFFSET string
	call WriteString

	ret
p111 ENDP

end