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

.data
	consonants BYTE "BCDFGHJKLMNOPQRSTVWXYZ"
	vowels BYTE "AEIOU"
	letter_matrix BYTE 16 DUP(?), 0
.code

generate_letter_matrix PROC
	matrix EQU [ebp + 8]

	push ebp
	mov ebp, esp	

	pushad

	call Randomize
	mov ecx, 16
	mov esi, matrix

loop_head:
	mov eax, 2
	call RandomRange
	cmp eax, 1
	je generate_vowel

generate_consonant:
	mov eax, LENGTHOF consonants
	call RandomRange
	mov bl, consonants[eax]
	jmp store_character

generate_vowel:
	mov eax, LENGTHOF vowels
	call RandomRange
	mov bl, vowels[eax]

store_character:
	mov BYTE PTR [esi], bl
	inc esi
	loop loop_head

	popad

	mov esp, ebp
	pop ebp

	ret 4
generate_letter_matrix ENDP


print_letter_matrix PROC
	matrix_pointer EQU [ebp + 8]

	push ebp
	mov ebp, esp

	pushad

	mov ecx, 16
	mov esi, matrix_pointer
	jmp no_newline			; Don't print a newline on the first loop

write_character:
	; Check if the current loop counter is a multiple of 4. 
	; Any multiple of 4 will have its two least significant bits as zeros, so AND-ing a value with 3 will produce 0 if it's a multiple of 4 and 1 otherwise.
	mov edx, ecx
	and edx, 3
	jnz no_newline
	call Crlf

no_newline:
	mov al, [esi]
	call WriteChar
	mov al, " "
	call WriteChar

	inc esi
	cmp BYTE PTR [esi], 0
	loop write_character

	popad

	mov esp, ebp
	pop ebp
	ret 4
print_letter_matrix ENDP

p910 PROC
	; Create a procedure that generates a four-by-four matrix of randomly chosen capital letters.
	; When choosing the letters, there must be a 50% probability that the chosen letter is a vowel.
	; Write a test program with a loop that calls your procedure five times and displays each matrix in the console window.
	; Following is an example output for the first three matrices:

	; D W A L
	; S I V W
	; U I O L
	; L A I I

	; K X S V
	; N U U O
	; O R Q O
	; A U U T

	; P O A Z
	; A E A U
	; G K A E
	; I A G D

	mov ecx, 5

loop_head:
	push OFFSET letter_matrix
	call generate_letter_matrix
	
	push OFFSET letter_matrix
	call print_letter_matrix
	call Crlf
	call Crlf
	
	loop loop_head

	ret
p910 ENDP

end