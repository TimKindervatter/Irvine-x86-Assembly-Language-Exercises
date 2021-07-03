.386
.model flat, stdcall
.stack 4096

SetTextColor PROTO
Crlf PROTO

SetColor PROTO
WriteColorChar PROTO

DisplayEvenLine PROTO,
	non_white_tile_color:DWORD

DisplayOddLine PROTO,
	non_white_tile_color:DWORD

DisplayChessBoard PROTO,
	non_white_tile_color:DWORD

DisplayTile PROTO,
	color:DWORD

white EQU 15
gray EQU 8
black EQU 0

.data

.code

p82 PROC
; Write a program that draws an 8 x 8 chess board with alternating gray and white squares. You can use the SetTextColor and Gotoxy procedures from the Irvine32 library.
; Avoid the use of global variables, and use declared parameters in all procedures.
; Use short procedures that are focused on a single task.

	INVOKE DisplayChessBoard, gray

; Restore output colors to white foreground and black background
	push black				; Background color
	push white				; Foreground color
	call SetColor

	ret
p82 ENDP


DisplayChessBoard PROC USES ecx,
	non_white_tile_color:DWORD
	mov ecx, 4
loop_head:
	INVOKE DisplayEvenLine, non_white_tile_color
	call Crlf
	INVOKE DisplayOddLine, non_white_tile_color
	call Crlf
	loop loop_head

	ret
DisplayChessBoard ENDP

DisplayEvenLine PROC USES ecx,
	non_white_tile_color:DWORD
	mov ecx, 4
loop_head:
	INVOKE DisplayTile, white
	INVOKE DisplayTile, non_white_tile_color
	loop loop_head

	ret
DisplayEvenLine ENDP


DisplayOddLine PROC USES ecx,
	non_white_tile_color:DWORD
	mov ecx, 4
loop_head:
	INVOKE DisplayTile, non_white_tile_color
	INVOKE DisplayTile, white
	loop loop_head

	ret
DisplayOddLine ENDP


DisplayTile PROC,
	color:DWORD

	push color
	push color
	push " "
	call WriteColorChar

	ret
DisplayTile ENDP

end