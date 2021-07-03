TITLE Problem 5-2

.386
.model flat, stdcall
.stack 4096

Clrscr PROTO
GetMaxXY PROTO
Gotoxy PROTO
WriteString PROTO
ReadInt PROTO
WriteInt PROTO
Crlf PROTO

.data
	prompt BYTE "Input two integers: ", 0
	prompt2 BYTE "The sum of these two integers is ", 0
.code

p53 PROC
	; Write a program that clears the screen, locates the cursor near the middle of the screen, prompts the user for two integers, adds the integers, and displays their sum.
	call Clrscr

	xor eax, eax
	xor edx, edx
	call GetMaxXY
	shr al, 1		; Divide number of rows by 2
	mov dl, 0		; Set the column number to 0

	mov dh, al		; Move the number of rows into dh for use by Gotoxy. dl already has number of columns
	call Gotoxy

	mov edx, OFFSET prompt
	call WriteString

	call ReadInt
	mov ebx, eax

	call ReadInt
	add eax, ebx

	mov edx, OFFSET prompt2
	call WriteString
	call WriteInt

	ret
p53 ENDP

end