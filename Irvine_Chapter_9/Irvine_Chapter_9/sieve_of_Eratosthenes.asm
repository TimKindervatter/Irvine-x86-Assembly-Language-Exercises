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
	sqrt_N DWORD ?
.code


sieve_of_Eratosthenes PROC
	sieve_array_pointer EQU [ebp + 8]
	N EQU [ebp + 12]

	push ebp
	mov ebp, esp

	pushad

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
	jg break

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
	jbe next_prime

	popad

	mov esp, ebp
	pop ebp

	ret 8
sieve_of_Eratosthenes ENDP


validate_sieve PROC
	sieve_array_ptr EQU [ebp + 8]
	sieve_array_length EQU [ebp + 12]

	push ebp
	mov ebp, esp

	push ecx
	push esi

	mov ecx, sieve_array_length				; Populate ecx with the length of the array, so we loop over the full array
	xor eax, eax							; Initialize counter to zero
	mov esi, sieve_array_ptr
sum_primes:
	cmp BYTE PTR [esi], 0					
	jne not_prime							; If the current element is nonzero, it's a not prime number, so skip incrementing the counter
	inc eax									; Otherwise it is prime, so increment the counter
not_prime:
	inc esi
	loop sum_primes

	pop esi
	pop ecx

	mov esp, ebp
	pop ebp
	ret 8
validate_sieve ENDP

end