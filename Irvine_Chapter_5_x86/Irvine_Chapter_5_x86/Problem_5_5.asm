TITLE Problem 5-5

.386
.model flat, stdcall
.stack 4096

RandomRange PROTO
WriteInt PROTO
Crlf PROTO

.data

.code

p55 PROC
	; Crate an improved version of the RandomRange procedure that generates an integer between M and N-1.
	; Write a short test program that calls BetterRandomRange from a loop that repeats 50 times.

	mov ecx, 50000
L1:
	mov ebx, -300
	mov eax, 100
	call BetterRandomRange
	call WriteInt
	call Crlf
	
	loop L1

	ret
p55 ENDP

BetterRandomRange PROC
; ------------------------------------------------
; Args:
;	eax: Upper bound N of the interval from which to draw random integers
;	ebx: Lower bound M of the interval from which to draw random integers
; Returns:
;	eax: The random integer produced by in the interval
; ------------------------------------------------

	sub eax, ebx				; Shift the interval to [0, N-M] so that we can piggyback on RandomRange
	call RandomRange			; Will produce an integer between 0 and N-M-1
	add eax, ebx				; Add M back to the produced random number, which will put it between M and N-1, as desired

skip:
	ret
BetterRandomRange ENDP

end