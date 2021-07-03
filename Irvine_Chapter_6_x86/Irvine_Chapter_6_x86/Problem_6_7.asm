TITLE Problem 6-7

.386
.model flat, stdcall
.stack 4096

Randomize PROTO
RandomRange PROTO
SetTextColor PROTO
WriteString PROTO
Crlf PROTO

.data
	test_string BYTE "Test String", 0
.code

p67 PROC
	; Write a program that randomly chooses among three different colors for displaying text on the screen. Use a loop to display 20 lines of text, each with a randomly chosen color.
	; The probabilities for each color are to be as follows: white = 30%, blue = 10%, and green = 60%.

	call Randomize
	mov ecx, 20
loop_head:
	mov eax, 10
	call RandomRange
	cmp eax, 2
	jbe white
	cmp eax, 3
	je blue
	cmp eax, 4
	jae green

white:
	mov eax, 15
	call SetTextColor
	jmp continue
blue:
	mov eax, 1
	call SetTextColor
	jmp continue
green:
	mov eax, 2
	call SetTextColor
	jmp continue
continue:
	mov edx, OFFSET test_string
	call WriteString
	call Crlf
	loop loop_head

	ret
p67 ENDP

end