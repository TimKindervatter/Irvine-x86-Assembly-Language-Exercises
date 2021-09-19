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
	output_handle HANDLE ?

	top BYTE 218, 196, 191
	sides BYTE 179, " ", 179
	bottom BYTE 192, 196, 217

	cursor_position COORD <0, 0>

	characters_written DWORD ?
.code

p115 PROC
	; Draw a box on the screen using the line-drawing characters from the character set listed inside the back cover of the book.
	; Hint: use the WriteConsoleOutputCharacter function.

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov output_handle, eax

	INVOKE WriteConsoleOutputCharacter, output_handle, ADDR top, SIZEOF top, cursor_position, ADDR characters_written

	add cursor_position.Y, 1

	INVOKE WriteConsoleOutputCharacter, output_handle, ADDR sides, SIZEOF sides, cursor_position, ADDR characters_written

	add cursor_position.Y, 1

	INVOKE WriteConsoleOutputCharacter, output_handle, ADDR bottom, SIZEOF bottom, cursor_position, ADDR characters_written

	ret
p115 ENDP

end