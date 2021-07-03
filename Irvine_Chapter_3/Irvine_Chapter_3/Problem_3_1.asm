TITLE Integer Expression Calculation

; Write a program that calculates the following expression using register: A = (A + B) - (C + D). Assign integer values to the EAX, EBX, ECX, and EDX registers.

.data
start QWORD $
A SQWORD 1
B SQWORD 2
C SQWORD 3
D SQWORD 4

.code
p31 proc
	mov r8, start
	mov rax, A
	add rax, B

	mov rcx, C
	add rcx, D

	sub rax, rcx
	mov A, rax
	ret
p31 endp
end