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
INCLUDE Macros.inc

BUFFER_SIZE = 1024

.data
	buffer BYTE BUFFER_SIZE DUP(?), 0
	filename BYTE 80 DUP(0)
	fileHandle HANDLE ?

	characters_read DWORD ?
.code

p1110 PROC
	; Modify the ReadFile.asm program in Section 11.1.8 so that it can read files larger than its input buffer.
	; Reduce the buffer size to 1024 bytes.
	; Use a loop to continue reading and displaying the file until it can read no more data.
	; If you plan to display the buffer with WriteString, remember to insert a null byte at the end of the buffer data.

	; Let user input a filename.
	mWrite "Enter an input filename: "
	mov edx, OFFSET filename
	mov ecx, SIZEOF filename
	call ReadString

	; Open the file for input.
	mov edx, OFFSET filename
	call OpenInputFile
	mov fileHandle, eax

	; Check for errors.
	cmp eax, INVALID_HANDLE_VALUE					; error opening file?
	jne file_ok										; no: skip

	mWrite <"Cannot open file", 0dh, 0ah>
	jmp quit										; and quit

file_ok:
	; Read the file into a buffer.
	INVOKE ReadFile, fileHandle, ADDR buffer, BUFFER_SIZE, ADDR characters_read, 0
	cmp eax, 0										; error reading?
	jne file_read_successful							

	mWrite "Error reading file. "					; yes: show error message
	call WriteWindowsMsg
	jmp close_file

file_read_successful:
	mov ebx, characters_read
	mov buffer[ebx], 0								; insert null terminator

	; Display the buffer.
	mov edx, OFFSET buffer							; display the buffer
	call WriteString

	cmp ebx, BUFFER_SIZE
	je file_ok

	call Crlf

close_file:
	mov eax,fileHandle
	call CloseFile
quit:
	ret
p1110 ENDP

end