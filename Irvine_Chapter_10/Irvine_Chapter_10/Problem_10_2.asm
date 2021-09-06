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

mWriteStringWithColor MACRO string, color
	mov eax, color
	call SetTextColor

	mov edx, OFFSET string
	call WriteString
ENDM

.data
	myString BYTE "Here is my string", 0
.code

p102 PROC
	; Create a macro that writes a null-terminated string to the console with a given text color.
	; The macro parameters should include the string name and the color.

	mWriteStringWithColor myString, white
	call Crlf
	mWriteStringWithColor myString, lightBlue
	call Crlf

	mov ecx, 15
loop_head:
	mWriteStringWithColor myString, ecx
	call Crlf
	loop loop_head

	ret
p102 ENDP

end