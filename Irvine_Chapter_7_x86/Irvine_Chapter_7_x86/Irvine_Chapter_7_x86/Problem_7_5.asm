.386
.model flat, stdcall
.stack 4096

WriteInt PROTO
Crlf PROTO

.data
	n = 1000
	upper_bound DWORD n
	A BYTE n DUP(1)				; Initialize all array values to true
	sqrt_n DWORD ?
.code

p75 PROC
	; Write a program that generates all prime numbers between 2 and 1000 using the Sieve of Eratosthenes

	call sieve
	
	mov ecx, LENGTHOF A
	mov eax, 0
loop_head:
	cmp BYTE PTR A[eax], 1
	jne not_prime
	call WriteInt
	call Crlf
not_prime:
	inc eax
	loop loop_head

	ret
p75 ENDP


sieve PROC
	fild upper_bound		; Push n on top of the stack
	fsqrt					; Compute square root and store it on top of the stack
	fistp [sqrt_n]			; Store the result in memory (as a 32-bit integer) and pop ST(0)

	mov ecx, [sqrt_n]
	mov esi, 2				; Start at A[2]
outer_loop:
	cmp A[esi], 1
	jne A_i_was_false
	mov eax, esi			; eax = i
	imul eax, eax			; eax = i^2
	mov ebx, esi			; ebx = i
inner_loop:
	mov A[eax], 0
	add eax, ebx			; Add another i to the contents of eax per iteration. This gives eax = i^2 on iteration 0, eax = i^2 + i on iteration 1, eax = i^2 + 2i on iteration 3, etc.
	cmp eax, n
	jge exit_inner_loop
	jmp inner_loop
exit_inner_loop:
A_i_was_false:
	inc esi
	loop outer_loop

	ret
sieve ENDP

end