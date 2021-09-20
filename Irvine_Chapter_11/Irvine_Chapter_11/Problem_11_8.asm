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

Clrscr PROTO

.data
	output_handle HANDLE ?

	square BYTE 0DBh, 0DBh

	position COORD <15, 5>

	console_info CONSOLE_SCREEN_BUFFER_INFO <>
	console_view SMALL_RECT <>
.code

p118 PROC
	; Write a program that draws a small square on the screen using several blocks (ASCII code DBh) in color.
	; Move the square around the screen in randomly generated directions.
	; Use a fixed delay value of 50 milliseconds.
	; Extra: Use a randomly generated delay value between 10 and 100 milliseconds.

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov output_handle, eax

	INVOKE SetConsoleTextAttribute, output_handle, blue
	INVOKE SetConsoleCursorPosition, output_handle, position

	INVOKE WriteConsole, output_handle, ADDR square, SIZEOF square, 0, 0

	call Randomize

	mov ecx, 100
loop_head:
	push ecx

	call Clrscr

	mov eax, 4
	call RandomRange

	cmp eax, 0
	je move_up
	cmp eax, 1
	je move_right	
	cmp eax, 2
	je move_down
	cmp eax, 3
	je move_left
	
move_up:
	inc position.Y
	jmp continue
move_right:
	inc position.X
	jmp continue
move_down:
	dec position.Y
	jmp continue
move_left:
	dec position.X
	jmp continue

continue:

	INVOKE SetConsoleCursorPosition, output_handle, position
	INVOKE WriteConsole, output_handle, ADDR square, SIZEOF square, 0, 0

	mov eax, 90
	call RandomRange
	add eax, 10

	INVOKE Sleep, eax

	pop ecx

	dec ecx
	cmp ecx, 0
	jne loop_head

	ret	
p118 ENDP

end