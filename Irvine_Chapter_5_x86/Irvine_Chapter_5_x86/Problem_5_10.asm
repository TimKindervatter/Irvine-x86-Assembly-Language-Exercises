TITLE Problem 5-10

.386
.model flat, stdcall
.stack 4096

N EQU 47

.data
	fib_array DWORD N DUP(?)
.code

p510 PROC
; Write a procedure that produces the first N values in the fibonacci sequence and stores them in an array of DWORDs.
; Input parameters should be a pointer to an array of DWORDs and a counter of the number of values to generate.
; Write a test program that passes N = 47 (Hint: The first value will be 1 and the last value will by 2,971,215,073

	mov eax, OFFSET fib_array
	mov ecx, N
	call generate_fib

	ret
p510 ENDP

generate_fib PROC
;-------------------------------------------
; Args:
;	eax: Contains the base address of the array in which to write the fibonacci numbers
;	ecx: Number N of fibonacci numbers to generate
;-------------------------------------------

	push esi
	push edi
	push ebx

	mov esi, 1			; First fibonacci number
	mov edi, 1			; Second fibonacci number

	mov [eax], esi		; Write fib(1) to the array
	add eax, TYPE DWORD ; Increment array pointer
	mov [eax], edi		; Write fib(1) to the array
	add eax, TYPE DWORD ; Increment array pointer

	sub ecx, 2			; Manually handled the first two fibonacci numbers, so we only need to loop N-2 times
L1:
	mov ebx, edi		; Save the save fib(n-1), which will become fib(n-2) for the next iteration
	add edi, esi		; set edi = fib(n) = fib(n-1) + fib(n-1)
	mov [eax], edi		; Store the new fib(n) in the currently-pointed-to element of the array

	mov esi, ebx		; The previous f(n-1) value now becomes the fib(n-2) value
	add eax, TYPE DWORD
	loop L1

	pop ebx
	pop edi
	pop esi
	ret
generate_fib ENDP

end