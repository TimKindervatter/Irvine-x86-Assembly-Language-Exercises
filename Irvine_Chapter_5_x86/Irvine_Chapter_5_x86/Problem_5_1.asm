TITLE Problem 5-1

.386
.model flat, stdcall
.stack 4096

SetTextColor PROTO
WriteString PROTO
Crlf PROTO

.data
	string BYTE "Colored String", 0
.code

p51 PROC
	; Write a program that displays the same string in four different colors using a loop. Requires the SetTextColor procedure from the Irvine32 library, which can only be run in 32 bit mode.
	mov ecx, 15
L1:
	mov eax, ecx
	call SetTextColor
	
	mov edx, OFFSET string
	call WriteString
	call Crlf

	loop L1

	ret
p51 ENDP

end