IFDEF RAX
	END_IF_X64 EQU END
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

add3 MACRO destination, source1, source2
	mov eax, source1
	add eax, source2
	mov destination, eax
ENDM

sub3 MACRO destination, source1, source2
	mov eax, source1
	sub eax, source2
	mov destination, eax
ENDM

mul3 MACRO destination, source1, source2
	push ebx
	push edx

	mov eax, source1
	mov ebx, source2
	imul ebx
	mov destination, eax

	pop edx
	pop ebx
ENDM

div3 MACRO destination, source1, source2
	push ebx
	push edx

	mov eax, source1
	mov ebx, source2
	cdq
	idiv ebx
	mov destination, eax

	pop edx
	pop ebx
ENDM

.data
	result DWORD ?
	temp DWORD ?
	temp2 DWORD ?
.code

p1010 PROC
	; In the following macros, assume EAX is reserved for macro operations and is not preserved.
	; Other registers modified by the macro must be preserved.
	; All parameters are signed memory doublewords.
	; Write macros that simulate the following instructions:

	; a. add3 destination, source1, source2
	; b. sub3 destination, source1, source2		(destination = source1 - source2)
	; c. mul3 destination, source1, source2
	; d. div3 destination, source1, source2		(destination = source1/source2)

	; Write a program that tests your macros by implementing four arithmetic expressions, each involving multiple operations.

	; (1 + 2)*3 = 9
	add3 temp, 1, 2
	mul3 result, temp, 3

	; (20 - 10)/2 = 5
	sub3 temp, 20, 10
	div3 result, temp, 2

	; (10 - 20)/(5 + 5) = -1
	sub3 temp, 10, 20
	add3 temp2, 5, 5
	div3 result, temp, temp2
	
	; (-6/4)*(3 + 5) = -8 (because division is truncated to -1)
	div3 temp, -6, 4
	add3 temp2, 3, 5
	mul3 result, temp, temp2

	ret
p1010 ENDP

end