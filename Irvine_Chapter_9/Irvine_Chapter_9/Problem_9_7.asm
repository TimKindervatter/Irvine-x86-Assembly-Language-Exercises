IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

.686
.xmm
.model flat, stdcall
.stack 4096

.data
	sieve_array BYTE 65000 DUP(?)
	sentinel BYTE "!"
	sqrt_N DWORD ?
.code


sieve_array_of_Eratosthenes PROC
	sieve_array_pointer EQU [ebp + 8]
	N EQU [ebp + 12]

	push ebp
	mov ebp, esp

	; Indexing sieve_array_pointer doesn't work very well because it's just a macro that is just expanded to [ebp + 8]. 
	; This typically results in incorrect offsets. So save endpoints of sieve_array in registers instead.
	mov edx, sieve_array_pointer	; Save beginning of sieve array	
	mov ebx, sieve_array_pointer	
	add ebx, N						; Save end of sieve array

	; Compute the square root of N, which will be used as the stopping condition later. Store it to memory for later use.
	mov ecx, N
	cvtsi2ss xmm0, ecx
	sqrtss xmm1, xmm0
	cvtss2si ecx, xmm1
	mov DWORD PTR [sqrt_N], ecx

	mov eax, 2
	inc BYTE PTR [edx]				; 0 is not prime
	inc BYTE PTR [edx + 1]			; 1 Is not prime
next_prime:
	mov esi, sieve_array_pointer
	add esi, eax					; Start this loop at the index of the next prime in the sequence.

inner_loop:
	add esi, eax					; Point to the next multiple of the current prime

	cmp esi, ebx					; EBX points to the end of the array. Compare the pointer to the next multiple, and break if it is beyond the end of the array so that we don't write out of bounds.
	jge break

	mov BYTE PTR [esi], 1			; "Cross off" the next multiple of the current prime

	jmp inner_loop

break:
	; Starting from 1 after the last prime, search for the next zero entry (i.e. the next prime)
	lea edi, [edx + eax + 1]
	mov al, 0

	mov ecx, N						; Make sure scasb does not terminate early because ecx reaches 0
	cld
	repne scasb
	dec edi

	; Find the offset of the pointer to the zero that was found by scasb. This is exactly the next prime number, which will be used in the next iteration.
	mov eax, edi
	sub eax, sieve_array_pointer

	cmp eax, DWORD PTR [sqrt_N]				; The well-known optimization of the sieve_array lets us quit once we reach sqrt(N), and in this case, N = 65,000
	jb next_prime

	mov esp, ebp
	pop ebp

	ret 8
sieve_array_of_Eratosthenes ENDP


p97 PROC
	; The sieve_array of Eratosthenes provides a quick way to find all prime numbers within a given range.
	; The algorimth involves creating an array of bytes in which positions are "marked" by inserting 1s in the following manner:
	;	Beginning with position 2 (which is a prime number), insert a 1 in each array position that is a multiple of 2.
	;	Then do the same thing for multiples of 3, the next prime number.
	;	Find the next prime number after 3, which is 5, and mark all positions that are multiples of 5.
	;	Proceed in this manner until all multiples of primes have been found.
	; The remaining positions of the array that are unmarked indicate which numbers are prime.

	; For this program, create a 65,000 element array and display all primes between 2 and 65,000.
	; Declare the array in an uninitialized data segment and use STOSB to fill it with zeros.
	
	push LENGTHOF sieve_array
	push OFFSET sieve_array
	call sieve_array_of_Eratosthenes

	mov ecx, LENGTHOF sieve_array
	xor edx, edx
	mov esi, OFFSET sieve_array
sum_primes:
	cmp BYTE PTR [esi], 0
	jne not_prime
	inc edx
not_prime:
	inc esi
	loop sum_primes

	mov ecx, LENGTHOF sieve_array
	sub ecx, edx				; Should be 0x0000195D, which is 6493 in decimal. This is the number of primes less than 65000

	ret
p97 ENDP

end