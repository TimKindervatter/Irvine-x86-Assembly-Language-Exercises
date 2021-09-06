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

mWriteInt MACRO integer, data_type
	xor eax, eax

	IF (data_type) EQ (TYPE SBYTE) OR (data_type) EQ (TYPE SWORD) OR (data_type) EQ (TYPE SDWORD)
		mov eax, integer
		call WriteInt
	ELSE
		ECHO Data type must be BYTE, WORD, or DWORD.
	ENDIF
ENDM

.data

.code

p106 PROC
	; Create a macro named mWriteInt that writes a signed integer to standard output by calling the WriteInt library procedure.
	; The argument passed to the macro can be a byte, word, or doubleword.
	; Use conditional operators in the macro so it adapts to the size of the argument.
	; Write a program that tests the macro, passing it arguments of different sizes.

	mWriteInt -1, TYPE SBYTE
	call Crlf
	mWriteInt 1337, TYPE SWORD
	call Crlf
	mWriteInt -1234567, TYPE SDWORD
	call Crlf

	ret
p106 ENDP

end