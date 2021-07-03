.386
.model flat, stdcall
.stack 4096

WriteInt PROTO
Crlf PROTO

.data

.code

p76 PROC
	; The greatest common divisor (GCD) of two integers is the largest integer that will evenly divide both integers.
	; The GCD algorithm involves integer division in a loop, described by the following pseudocode:

comment !
	int GCD(int x, int y)
	{
		x = abs(x) // absolute value
		y = abs(y)
		do {
			int n = x % y
			x = y
			y = n
		} while (y > 0)
		return x
	}
!

	; Implement this function in assembly language and write a test program that calls the function several times, passing it different values. Display all results on the screen.

	mov ebx, -3
	mov ecx, 6
	call gcd
	call WriteInt
	call Crlf

	mov ebx, 5
	mov ecx, 7
	call gcd
	call WriteInt
	call Crlf

	mov ebx, 0
	mov ecx, 10
	call gcd
	call WriteInt
	call Crlf

	mov ebx, 0
	mov ecx, 0
	call gcd
	call WriteInt
	call Crlf
p76 ENDP

gcd PROC
	; Args:
	;	ebx: int x
	;	ecx: int y
	; Returns:
	;	eax: gcd(x, y)

	push ebx
	push ecx
	push edx

	cmp ecx, 0
	je y_zero

	; x = abs(x)
	mov eax, ebx
	call abs
	mov ebx, eax

	; y = abs(y)
	mov eax, ecx
	call abs
	mov ecx, eax

loop_head:
	xor edx, edx				; Clear edx as setup for idiv
	mov eax, ebx
	idiv ecx					; edx contains the remainder n = x % y

	mov ebx, ecx				; x = y
	mov ecx, edx				; y = n

	cmp ecx, 0
	jg loop_head

y_zero:
	mov eax, ebx				; Return x in eax

	pop edx
	pop ecx
	pop ebx
	
	ret
gcd ENDP

abs PROC
	; Args:
	;	eax: Contains the value which will have its absolute value taken
	; Returns:
	;	eax: The absolute value of the argument passed in

	cmp eax, 0
	jge nonnegative
	neg eax
nonnegative:
	ret
abs ENDP

end