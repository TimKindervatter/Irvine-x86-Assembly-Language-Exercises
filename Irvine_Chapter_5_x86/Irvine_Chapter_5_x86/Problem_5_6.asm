TITLE Problem 5-6

.386
.model flat, stdcall
.stack 4096

BetterRandomRange PROTO
RandomRange PROTO
WriteString PROTO
Crlf PROTO

L EQU 120
ARRAY_SIZE EQU 20*L

.data
	random_string BYTE ARRAY_SIZE DUP(?)
.code

p56 PROC
	; Create a procedure that generates a random string of length L, containing all capital letters.
	; Pass the value of L in EAX and pass a pointer to an array of BYTEs that will hold the random string.
	; Write a test program that calls your procedure 20 times and displays the strings in the console window

	mov ecx, 20							; Loop 20 times
	mov edx, OFFSET random_string
L1:
	mov esi, edx						; Every loop, reset esi to point to the base address of the string array
	mov eax, [L]						
	call RandomRange					; Every loop, create a string of random length between 0 and 120 characters long

	call generate_random_string			; The random length L is already in rax from the previous call
	call WriteString					; The base address of the string is already stored in edx
	call Crlf

	loop L1

	ret
p56 ENDP

generate_random_string PROC
; ----------------------------------------------------------------
; Args: 
;	eax: Holds the length L of the random string to generate
;	esi: Holds a pointer to the base address of an array of BYTES, which will be used to store the generated string
; ----------------------------------------------------------------

	push ecx						; Save ecx so we don't overwrite the calling function's value for it

	mov ecx, eax					; Move L into ecx so it can be used as the loop counter
L1:
	mov ebx, "A"					; The lower range of the random range is the ascii character 'A'
	mov eax, "Z"					; The upper range of the random range is the ascii character 'Z'
	inc eax							; Recall that BetterRandomRange produces a value in the interval [M, N-1], so in order to get random strings that includes 'Z', we need to make N the ascii value one past 'Z'.
	call BetterRandomRange
	mov [esi], al					; Move the randomly produced character into the current element of the array
	
	inc esi							; Array of BYTEs, so we only need to increment the pointer by 1
	loop L1

	mov BYTE PTR [esi], 0			; Null terminate the string

	pop ecx							; Restore the caller's ecx value
	ret
	
generate_random_string ENDP

end