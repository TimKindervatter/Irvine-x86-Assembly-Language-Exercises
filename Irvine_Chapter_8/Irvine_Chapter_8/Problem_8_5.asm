.386
.model flat, stdcall
.stack 4096

DifferentInputs PROTO,
	arg1:DWORD,
	arg2:DWORD,
	arg3:DWORD

.data

.code

p85 PROC
; Write a procedure named DifferentInputs that returns EAX = 1 if the values of the three input parameters are all different, otherwise return with EAX = 0.
; Use the PROC directive with a parameter list when declaring the procedure. Create a PROTO declaration for your procedure and call it five times from a test program that passes different inputs.

	INVOKE DifferentInputs, 1, 2, 3
	INVOKE DifferentInputs, 1, 1, 3
	INVOKE DifferentInputs, 1, 3, 3
	INVOKE DifferentInputs, 1, 2, 1
	INVOKE DifferentInputs, 1, 1, 1

	ret
p85 ENDP

DifferentInputs PROC USES ebx ecx,
	arg1:DWORD,
	arg2:DWORD,
	arg3:DWORD

	mov eax, 1
	mov ebx, arg1
	mov ecx, arg2

	cmp ebx, ecx						; Compare arg1 and arg2
	je two_arguments_same				; If they're the same, then all 3 arguments are not different so return 0
	cmp ebx, arg3						; Compare arg1 and arg3
	je two_arguments_same				; If they're the same, then all 3 arguments are not different so return 0
	cmp ecx, arg3						; Compare arg2 and arg3
	jne all_arguments_different			; If we've gotten here then arg1 != arg2 and arg1 != arg3. So if arg2 != arg3, then all the arguments are different. EAX still equals 1 from the beginning, so just return
two_arguments_same:
	mov eax, 0
all_arguments_different:
	ret
DifferentInputs ENDP

end