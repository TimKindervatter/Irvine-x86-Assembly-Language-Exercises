.386
.model flat, stdcall
.stack 4096

WriteChar PROTO
Crlf PROTO

.data
	decimal_one BYTE "100123456789765"
	DECIMAL_OFFSET_ONE = 5

	decimal_two BYTE "38972407198"
	DECIMAL_OFFSET_TWO = 0	
	
	decimal_three BYTE "31415926"
	DECIMAL_OFFSET_THREE = LENGTHOF decimal_three - 1

.code

p71 PROC
	; Write a procedure named WriteScaled that outputs a decimal ASCII number with an implied decimal point.
	; When calling WriteScaled, pass the number's offset in EDX, the number length in ECX and the decomal offset in EBX.
	; Write a test program that passes 3 numbers of different sizes to the procedure.
	
	mov edx, OFFSET decimal_one
	mov ecx, LENGTHOF decimal_one
	mov ebx, DECIMAL_OFFSET_ONE
	call WriteScaled
	call Crlf

	mov edx, OFFSET decimal_two
	mov ecx, LENGTHOF decimal_two
	mov ebx, DECIMAL_OFFSET_TWO
	call WriteScaled
	call Crlf

	mov edx, OFFSET decimal_three
	mov ecx, LENGTHOF decimal_three
	mov ebx, DECIMAL_OFFSET_THREE
	call WriteScaled
	call Crlf

	ret
p71 ENDP

WriteScaled PROC
	push eax
loop_head:
	cmp ecx, ebx
	jne no_decimal_point
	
	mov al, "."
	call WriteChar

no_decimal_point:
	mov al, [edx]
	call WriteChar

	inc edx
	loop loop_head

	pop eax
	ret
WriteScaled ENDP

end