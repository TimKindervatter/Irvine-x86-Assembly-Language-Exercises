.386
.model flat, stdcall
.stack 4096

Delay PROTO
Gotoxy PROTO

SetColor PROTO

DisplayChessBoard PROTO,
	non_white_tile_color:DWORD

.data

.code

p83 PROC
; This exercise extends Exercise 2. Every 500 milliseconds, change the color of the colored squares and redisplay the board. 
; Continue until you have shown the board 16 times, using all possible 4-bit background colors. (The white squares remain white throughout.)

	mov ecx, 16
loop_head:
	mov ebx, ecx
	dec ebx
	
	mov dh, 0
	mov dl, 0
	call Gotoxy

	INVOKE DisplayChessBoard, ebx
	mov eax, 500
	call Delay

	loop loop_head

; Restore output colors to white foreground and black background
	push 0				; Background color
	push 15				; Foreground color
	call SetColor

	ret
p83 ENDP

end