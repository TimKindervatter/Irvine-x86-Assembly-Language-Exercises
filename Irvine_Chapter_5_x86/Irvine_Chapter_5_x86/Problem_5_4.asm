TITLE Problem 5-4

.386
.model flat, stdcall
.stack 4096

Crlf PROTO
Clrscr PROTO
WaitMsg PROTO

p53 PROTO

.data

.code

p54 PROC
	; Use the solution from the preceding exercise as a starting point. Let this new program repeat the same steps three times, using a loop. Clear the screen after each loop iteration.
	mov ecx, 3

L1:
	call p53
	call Crlf
	call WaitMsg
	call Clrscr

	loop L1

	ret
p54 ENDP

end