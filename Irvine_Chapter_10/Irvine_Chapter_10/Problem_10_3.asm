IFDEF RAX
	END_IF_X64 EQU END
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096

mMove32 MACRO source, destination
	push eax
	mov eax, source
	mov destination, eax
	pop eax
ENDM

.data
	source1 DWORD 0DEADBEEFh
	destination1 DWORD ?
.code

p103 PROC
	; Write a macro named mMove32 that receives two 32-bit memory operands.
	; The macro should move the source operand to the destination operand.

	mMove32 source1, destination1

	ret
p103 ENDP

end