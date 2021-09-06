IFDEF RAX
	END_IF_X64 EQU END
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

mShiftDoublewords MACRO arrayName, direction, numberOfBits
;; Parameters:
	;; arrayName Name of the array
	;; direction Right (R) or Left (L)
	;; numberOfBits Number of bit positions to shift

	LOCAL left_shift_loop_head
	LOCAL right_shift_loop_head

	IF direction EQ "L"
		mov ecx, LENGTHOF arrayName
		dec ecx
		mov esi, OFFSET arrayName

		add esi, SIZEOF arrayName
		sub esi, TYPE arrayName

	left_shift_loop_head:
		mov eax, [esi - TYPE DWORD]
		shld DWORD PTR [esi], eax, numberOfBits
		sub esi, TYPE arrayName
		loop left_shift_loop_head

		shl DWORD PTR [esi], numberOfBits
	ELSEIF direction EQ "R"
		mov ecx, LENGTHOF arrayName
		dec ecx
		mov esi, OFFSET arrayName

	right_shift_loop_head:
		mov eax, [esi + TYPE DWORD]
		shrd DWORD PTR [esi], eax, numberOfBits
		add esi, TYPE arrayName
		loop right_shift_loop_head

		shr DWORD PTR [esi], numberOfBits
	ENDIF
ENDM

.data
	array1 DWORD 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh
	array2 DWORD 0B0B0B0B0h, 0C0C0C0C0h, 0D0D0D0D0h, 0E0E0E0E0h, 0F0F0F0F0h
.code

p109 PROC
	; Create a macro that shifts an array of 32-bit integers a variable number of bits in either direction, suing the SHRD and SHLD instructions.
	; Write a test program that tests your macro by shifting the same array in both directions and displaying the resulting values.
	; You can assume that the array is in little-endian order.

	; Here is a sample macro declaration:

	; mShiftDoublewords MACRO arrayName, direction, numberOfBits

	mShiftDoublewords array1, "L", 1
	mShiftDoublewords array1, "R", 1

	mShiftDoublewords array2, "L", 4
	mShiftDoublewords array2, "R", 4

	ret
p109 ENDP

end