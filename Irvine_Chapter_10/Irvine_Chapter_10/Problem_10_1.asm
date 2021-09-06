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

mReadKey MACRO ascii_code, scan_code
	call ReadChar
	mov ascii_code, al
	mov scan_code, ah
ENDM

.data
	ascii BYTE ?
	scan BYTE ?
.code

p101 PROC
	; Create a macro that waits for a keystroke and returns the key that was pressed. The macro should include the parameters for the ASCII code and the keyboard scan code.

	mReadKey ascii, scan

	ret
p101 ENDP

end