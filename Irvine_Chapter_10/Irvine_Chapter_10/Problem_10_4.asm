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

mMult32 MACRO factor1, factor2
	mov eax, factor1
	mul factor2
ENDM

.data
	my_factor1 DWORD 2000h
	my_factor2 DWORD 4000h
.code

p104 PROC
	; Create a macro named mMult32 that multiplies two 32-bit memory operands and produces a 32-bit product.

	mMult32 my_factor1, my_factor2

	ret
p104 ENDP

end