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

mReadInt MACRO out_param, data_type
	IF (data_type) EQ (TYPE WORD)
		call ReadInt
		mov out_param, ax
	ELSEIF (data_type) EQ (TYPE DWORD)
		call ReadInt
		mov out_param, eax
	ELSE
		ECHO Data type must be WORD or DWORD.
		EXITM
	ENDIF
ENDM

.data
	out_param_b BYTE ?
	out_param_w WORD ?
	out_param_d DWORD ?
.code

p105 PROC
	; Create a macro named mReadInt that reads a 16- or 32-bit signed integer from standard input and returns the value in an argument.
	; Use conditional operators to allow the macro to adapt to the size of the desired result.
	; Write a program that tests the macro, passing it operands of different sizes.

	mReadInt out_param_w, TYPE out_param_w
	mReadInt out_param_d, TYPE out_param_d
	mReadInt out_param_b, TYPE out_param_b

	ret
p105 ENDP

end