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

p112 PROTO

.data
	output_handle HANDLE ?
	console_info CONSOLE_SCREEN_BUFFER_INFO <>

	console_size COORD <>
	top_left COORD <0, 0>

	total_characters DWORD ?
	blanks BYTE 100000 DUP(?)
.code

clear_screen PROC
	push ebp
	mov ebp, esp

	pushad

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov output_handle, eax

	INVOKE SetConsoleCursorPosition, output_handle, top_left

	INVOKE GetConsoleScreenBufferInfo, output_handle, ADDR console_info

	mov eax, console_info.dwSize
	mov console_size, eax

	xor eax, eax
	mov ax, console_size.X
	mul console_size.Y

	mov total_characters, eax
	mov ecx, eax
	mov esi, OFFSET blanks
loop_head:
	mov BYTE PTR [esi], " "
	inc esi
	loop loop_head

	INVOKE WriteConsole, output_handle, OFFSET blanks, total_characters, 0, 0

	INVOKE SetConsoleCursorPosition, output_handle, top_left

	popad

	mov esp, ebp
	pop ebp

	ret
clear_screen ENDP

p113 PROC
	; Write your own version of the link library's Clrscr procedure that clears the screen.

	call p112
	call clear_screen

	ret
p113 ENDP

end