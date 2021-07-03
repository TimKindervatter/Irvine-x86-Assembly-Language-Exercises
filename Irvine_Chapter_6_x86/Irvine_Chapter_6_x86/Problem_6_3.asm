TITLE Problem 6-3

.386
.model flat, stdcall
.stack 4096

BetterRandomRange PROTO
WriteInt PROTO
WriteString PROTO
WriteChar PROTO
Crlf PROTO

.data
	sep BYTE ": "
.code

p63 PROC
	; Create a procedure named CalcGrade that receives an integer value between 0 and 100, and returns a single capital letter in the AL register.
	; Preserve all other register values between calls to the procedure. The letter returned should be according to the following ranges:
	;		Score Range		Letter Grade
	;		90 to 100			 A
	;		80 to 89			 B
	;		70 to 79			 C
	;		60 to 69			 D
	;		0 to 59				 F
	; Write a test program that generates 10 random integers between 50 and 100, inclusive. Each time an integer is generated, pass it to the CalcGrade procedure.

	mov ebx, 50
	mov esi, 101					; BetterRandomRange generates a number in the interval [N, M-1], so M needs to be 101 if we want values of 100 to be possible
	mov ecx, 50
loop_head:
	mov eax, esi					; eax gets overwritten each iteration, so refresh it to caontain 100 again
	call BetterRandomRange
	call WriteInt					; The random score produced by BetterRandomRange is in eax, which is also the argument for WriteInt, so we can call it directly

	mov edx, OFFSET sep				
	call WriteString				; Write a colon and a space after the score for nicer formatting

	call CalcGrade					; CalcGrade takes its input in eax, so the random score returned from BetterRandomRange, which is still in eax, is used here
	call WriteChar					; CalcGrade returns its result in al, which is also the input to WriteChar
	call Crlf

	loop loop_head
	ret

p63 ENDP

CalcGrade PROC
; -----------------------------------------------------------------------
; Args:
;	eax: Score between 0 and 100
; Returns:
;	al: Letter grade A through F corresponding the passed score
; -----------------------------------------------------------------------

	cmp eax, 90
	jae A_grade					; Scores can only go up to 100, so if 90 <= ebx, we know the score is an A
	cmp eax, 80				; If we've gotten here, we already know that ebx < 90
	jae B_grade					; If ebx >= 80, then 80 <= ebx < 90, which is a B
	cmp eax, 70
	jae C_grade					; Following the same logic, if we've gotten here 70 <= ebx < 80 which is a C
	cmp eax, 60
	jae D_grade					; Following the same logic, if we've gotten here 60 <= ebx < 70 which is a D
	jmp F_grade					; If we've gotten here, then ebx < 60, which is an F

A_grade:
	mov al, "A"
	ret
B_grade:
	mov al, "B"
	ret
C_grade:
	mov al, "C"
	ret
D_grade:
	mov al, "D"
	ret
F_grade:
	mov al, "F"
	ret
CalcGrade ENDP

end