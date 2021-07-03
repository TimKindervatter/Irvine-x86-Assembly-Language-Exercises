TITLE Problem 4-5

; Write a program that uses a loop to calculate the first seven values of the Fibonacci number equence.

.data
	fibn QWORD 0

.code

p45 PROC
	mov rax, 1					; Fib(1) = 1
	mov rbx, 1					; Fib(2) = 1
	mov rcx, 5					; Only need 5 iterations because we already have the first 2 fibonacci numbers
	xor rsi, rsi
L1:
	mov rsi, rbx				; Temporarily store the contents of rbx (which is currently Fib(n-1)
	add rbx, rax				; rbx = Fib(n) = Fib(n-1) + Fib(n-2)
	mov [fibn], rbx
	
	mov rax, rsi				; For next iteration, Fib(n-1) becomes Fib(n-2), so store in rax the value that used to be stored in rbx
	loop L1

	ret

p45 ENDP

end