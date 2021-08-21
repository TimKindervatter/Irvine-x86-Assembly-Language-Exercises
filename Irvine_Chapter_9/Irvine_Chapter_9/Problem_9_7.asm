IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

.686
.model flat, stdcall
.stack 4096

.data
	sieve BYTE 65000 DUP(?)
	sentinel BYTE "!"
	sqrt_65000 DWORD 254
.code


sieve_of_Eratosthenes PROC
	sieve_pointer EQU [ebp + 8]
	N EQU [ebp + 12]

	push ebp
	mov ebp, esp

	mov eax, 2
	inc BYTE PTR sieve_pointer[0]			; 0 is not prime
	inc BYTE PTR sieve_pointer[1]			; 1 Is not prime
next_prime:
	mov esi, sieve_pointer
	add esi, eax					; Start this loop at the index of the next prime in the sequence.

inner_loop:
	; "Cross off" each multiple of the current prime
	add esi, eax
	mov ebx, sieve_pointer
	add ebx, N
	cmp esi, ebx
	jge break
	mov BYTE PTR [esi], 1

	jmp inner_loop

break:
	; Starting from 1 after the last prime, search for the next zero entry (i.e. the next prime)
	mov edi, sieve_pointer
	add edi, eax
	add edi, 1
	mov al, 0

	mov ecx, N						; Make sure scasb does not terminate early because ecx reaches 0
	cld
	repne scasb
	dec edi

	; Find the offset of the pointer to the zero that was found by scasb. This is exactly the next prime number, which will be used in the next iteration.
	mov eax, edi
	sub eax, sieve_pointer

	cmp eax, sqrt_65000				; The well-known optimization of the sieve lets us quit once we reach sqrt(N), and in this case, N = 65,000
	jb next_prime

	mov esp, ebp
	pop ebp

	ret 8
sieve_of_Eratosthenes ENDP


p97 PROC
	; The Sieve of Eratosthenes provides a quick way to find all prime numbers within a given range.
	; The algorimth involves creating an array of bytes in which positions are "marked" by inserting 1s in the following manner:
	;	Beginning with position 2 (which is a prime number), insert a 1 in each array position that is a multiple of 2.
	;	Then do the same thing for multiples of 3, the next prime number.
	;	Find the next prime number after 3, which is 5, and mark all positions that are multiples of 5.
	;	Proceed in this manner until all multiples of primes have been found.
	; The remaining positions of the array that are unmarked indicate which numbers are prime.

	; For this program, create a 65,000 element array and display all primes between 2 and 65,000.
	; Declare the array in an uninitialized data segment and use STOSB to fill it with zeros.
	
	push LENGTHOF sieve
	push OFFSET sieve
	call sieve_of_Eratosthenes

	mov ecx, LENGTHOF sieve
	xor edx, edx
	mov esi, OFFSET sieve
sum_primes:
	cmp BYTE PTR [esi], 0
	jne not_prime
	inc edx
not_prime:
	inc esi
	loop sum_primes

	mov ecx, LENGTHOF sieve
	sub ecx, edx				; Should be 0x0000195D, which is 6493 in decimal. This is the number of primes less than 65000

	ret
p97 ENDP

end