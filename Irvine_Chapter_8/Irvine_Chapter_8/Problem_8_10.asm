.386
.model flat, stdcall
.stack 4096

WriteHex PROTO
WriteString PROTO
Crlf PROTO

MySample PROTO,
	arg1: DWORD,
	arg2: DWORD,
	arg3: DWORD

ShowParams PROTO

.data
	show_params_message BYTE "Stack parameters:", 13, 10, "---------------------------", 13, 10, 0
	address_string BYTE "Address ", 0
	equals_string BYTE " = ", 0
.code

p810 PROC
; Write a prcedure named ShowParams that displays the address and hexadecimal value of the 32-bit parameters on the runtime stack of the procedure that called it.
; The parameters are to be displayed in order from lowest address to highest.
; Input to the procedure will be a single integer that indicates the number of parameters to display.
; For example, suppose the following statement in main calls MySample, passing three arguments:
;
;	INVOKE MySample, 1234h, 5000h, 6543h
;
; Next, inside MySample, you should be able to call ShowParams, passing the number of parameters you want to display:
;
;	MySample PROC first:DWORD, second:DWORD, third:DWORD
;	paramCount = 3
;	call ShowParams, paramCount
;
; ShowParams should display output in the following format:
;
;	Stack parameters:
;	---------------------------
;	Address 0012FF80 = 00001234
;	Address 0012FF84 = 00005000
;	Address 0012FF88 = 00006543

	INVOKE MySample, 1234h, 5000h, 6543h

	ret
p810 ENDP

MySample PROC,
	arg1: DWORD,
	arg2: DWORD,
	arg3: DWORD

	push 3
	call ShowParams

	ret
MySample ENDP

ShowParams PROC
	paramCount EQU [ebp + 8]

	push ebp
	mov ebp, esp

	pushad	

	lea esi, [ebp + 20]						; The first stack parameter is 20 bytes above ebp because:
											; the return address of ShowParams is at ebp + 4, 
											; paramCount is at ebp + 8, 
											; ebp for the calling function's stack frame is at ebp + 12, 
											; the return address of the function that called ShowParams is at ebp + 16

	mov edx, OFFSET show_params_message
	call WriteString

	mov ecx, paramCount
loop_head:
	mov edx, OFFSET address_string
	call WriteString

	mov eax, esi
	call WriteHex

	mov edx, OFFSET equals_string
	call WriteString

	mov eax, [esi]
	call WriteHex

	call Crlf
	add esi, TYPE DWORD
	loop loop_head

	popad

	mov esp, ebp
	pop ebp
	
	ret 4
ShowParams ENDP

end