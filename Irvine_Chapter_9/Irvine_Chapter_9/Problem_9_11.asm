IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

Randomize PROTO
RandomRange PROTO
WriteChar PROTO
Crlf PROTO

generate_letter_matrix PROTO
is_character_in_set PROTO

.data
	consonants BYTE "BCDFGHJKLMNOPQRSTVWXYZ"
	vowels BYTE "AEIOU"
	letter_matrix BYTE 16 DUP(?), 0
.code

p911 PROC
	; Use the letter matrix generated in the prevous programming exercise as a starting point for this program.
	; Generate a single four-by-four letter matrix in which each letter has a 50% probability of being a vowel.
	; Traverse each matrix row, column, and diagonal, generating sets of letters.
	; Display only four-letter sits containing exactly two vowels.

	push OFFSET letter_matrix
	call generate_letter_matrix

	ret
p911 ENDP

end