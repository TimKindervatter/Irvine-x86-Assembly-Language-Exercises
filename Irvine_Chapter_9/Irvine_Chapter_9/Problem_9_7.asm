IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.686
.xmm
.model flat, stdcall
.stack 4096

sieve_of_Eratosthenes PROTO
validate_sieve PROTO
WriteString PROTO

.data
	sieve_array BYTE 100000 DUP(?)

	expected_results DWORD 100000 DUP(?)

	failed BYTE "Assertion Failed!", 0
	succeeded BYTE "All tests succeeded!", 0
.code

;----------------------------------------------------------------------------------------------------------------------------------------------
call_and_validate_sieve PROC
	sieve_array_pointer EQU [ebp + 8]	; Base address of the sieve array whose indices indicate whether a number is prime or not
	N EQU [ebp + 12]					; The sieve will find all the primes up to N

; Returns: Nothing, but the Zero flag will be set if the number of primes found by the sieve matches the expected value. 
;		   The Zero flag will be clear if the number of primes found by the sieve does not match the expected value.
;----------------------------------------------------------------------------------------------------------------------------------------------

	push ebp
	mov ebp, esp

	pushad

	mov ecx, N
	mov edi, sieve_array_pointer
	mov al, 0
	rep stosb

	push N
	push sieve_array_pointer
	call sieve_of_Eratosthenes

	push N
	push sieve_array_pointer
	call validate_sieve
	mov edi, OFFSET expected_results
	add edi, N
	cmp eax, [edi]
	
	popad

	mov esp, ebp
	pop ebp
	ret 8
call_and_validate_sieve ENDP


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

	mov DWORD PTR expected_results[10], 4
	mov DWORD PTR expected_results[100], 25
	mov DWORD PTR expected_results[1000], 168
	mov DWORD PTR expected_results[10000], 1229
	mov DWORD PTR expected_results[65000], 6493
	mov DWORD PTR expected_results[100000], 9592
	

	push 10
	push OFFSET sieve_array
	call call_and_validate_sieve
	jne assertion_failed

	push 100
	push OFFSET sieve_array
	call call_and_validate_sieve
	jne assertion_failed

	push 1000
	push OFFSET sieve_array
	call call_and_validate_sieve
	jne assertion_failed

	push 10000
	push OFFSET sieve_array
	call call_and_validate_sieve
	jne assertion_failed

	push 65000
	push OFFSET sieve_array
	call call_and_validate_sieve
	jne assertion_failed

	push 100000
	push OFFSET sieve_array
	call call_and_validate_sieve
	jne assertion_failed

	mov edx, OFFSET succeeded
	call WriteString
	jmp all_succeeded

assertion_failed:
	mov edx, OFFSET failed
	call WriteString
all_succeeded:
	ret
p97 ENDP

end