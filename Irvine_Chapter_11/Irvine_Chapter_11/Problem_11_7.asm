IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096

.data
	output_handle HANDLE ?

	line BYTE " -----------------------------", 13, 10

	cursor_position COORD <0, 0>
	console_info CONSOLE_SCREEN_BUFFER_INFO <>
.code

p117 PROC
	; Write a program that writes 50 lines of text to the console screen buffer. Number each line.
	; Move the console window to the top of the buffer, and begin scrolling the text upward at a steady rate (two lines per second).
	; Stop scrolling when the console window reaches the end of the buffer.

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov output_handle, eax

	mov ecx, 50

	mov eax, 0
loop_head:
	call WriteDec
	
	pushad
	INVOKE WriteConsole, output_handle, OFFSET line, SIZEOF line, 0, 0
	popad

	inc eax
	loop loop_head

	INVOKE SetConsoleCursorPosition, output_handle, cursor_position

	INVOKE GetConsoleScreenBufferInfo, output_handle, ADDR console_info

	mov ecx, 50
scroll_loop_head:
	inc console_info.srWindow.Top
	inc console_info.srWindow.Bottom

	pushad
	INVOKE SetConsoleWindowInfo, output_handle, 1, ADDR console_info.srWindow
	INVOKE Sleep, 500
	popad

	loop scroll_loop_head

	ret
p117 ENDP

end