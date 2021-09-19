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

	character BYTE ?
	color WORD ?

	console_info CONSOLE_SCREEN_BUFFER_INFO <>
.code

random_screen_fill PROC
	bias_towards_red EQU [ebp + 8]

	push ebp
	mov ebp, esp

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov output_handle, eax

	INVOKE GetConsoleScreenBufferInfo, output_handle, ADDR console_info

	xor eax, eax
	mov ax, console_info.dwSize.X
	mul console_info.dwSize.Y

	mov ecx, eax

	call Randomize

loop_head:
	push ecx

	cmp DWORD PTR [bias_towards_red], 0
	je no_bias

	mov eax, 2
	call RandomRange
	
	cmp eax, 0
	je not_red
	mov color, red
	jmp set_color

no_bias:
not_red:
	mov eax, 16
	call RandomRange
	mov color, ax

set_color:
	INVOKE SetConsoleTextAttribute, output_handle, color

	mov eax, 255
	call RandomRange
	mov character, al

	INVOKE WriteConsole, output_handle, ADDR character, SIZEOF character, 0, 0

	pop ecx
	loop loop_head

	mov esp, ebp
	pop ebp

	ret 4
random_screen_fill ENDP

p114 PROC
	; Write a program that fills each screen cell with a random character in a random color.
	; Extra: Assign a 50% probability that the color of any character will be red.

	mov eax, 0
	push eax
	call random_screen_fill

	call Clrscr

	mov eax, 1
	push eax
	call random_screen_fill

	ret
p114 ENDP

end