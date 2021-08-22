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
WriteString PROTO
Crlf PROTO

generate_letter_matrix PROTO
print_letter_matrix PROTO
is_character_in_set PROTO

.data
	consonants BYTE "BCDFGHJKLMNOPQRSTVWXYZ"
	vowels BYTE "AEIOU"
	letter_matrix BYTE 16 DUP(?), 0

	four_letter_set BYTE 4 DUP(?), 0

	rows_message BYTE "Rows with two vowels: ", 0
	columns_message BYTE "Columns with two vowels: ", 0
	diagonals_message BYTE "Diagonals with two vowels: ", 0
.code

count_vowels PROC
	push ebp
	mov ebp, esp

	pushad

	mov ebx, 0							; Keep track of number of vowels
	mov ecx, 4
	mov edi, OFFSET four_letter_set
inner_loop_head:
	mov eax, [edi]

	push eax
	push LENGTHOF vowels
	push OFFSET vowels
	call is_character_in_set
	jnz not_a_vowel
	inc ebx

not_a_vowel:
	inc edi
	loop inner_loop_head

	cmp ebx, 2

	popad

	mov esp, ebp
	pop ebp
	ret
count_vowels ENDP


print_set_if_it_has_two_vowels PROC
	push ebp
	mov ebp, esp

	pushad

	call count_vowels
	jnz set_does_not_have_two_vowels

	mov edx, OFFSET four_letter_set
	call WriteString
	call Crlf

set_does_not_have_two_vowels:
	popad

	mov esp, ebp
	pop ebp

	ret
print_set_if_it_has_two_vowels ENDP


populate_four_letter_set PROC
	pointer_to_first_element EQU [ebp + 8]
	inner_loop_increment EQU [ebp + 12]

	push ebp
	mov ebp, esp

	pushad

	mov esi, pointer_to_first_element
	mov edi, OFFSET four_letter_set
	mov ecx, 4
loop_head:
	mov dl, BYTE PTR [esi]
	mov BYTE PTR [edi], dl
	add esi, inner_loop_increment
	add edi, 1
	loop loop_head

	popad
	
	mov esp, ebp
	pop ebp
	ret 8
populate_four_letter_set ENDP


iterate_over_rows PROC
	push ebp
	mov ebp, esp

	pushad

	mov ecx, 4
outer_loop_head:
	mov ebx, 4
	sub ebx, ecx

	lea esi, [OFFSET letter_matrix + 4*ebx]

	push 1
	push esi
	call populate_four_letter_set

	call print_set_if_it_has_two_vowels
	loop outer_loop_head

	popad
	
	mov esp, ebp
	pop ebp
	ret
iterate_over_rows ENDP


iterate_over_columns PROC
	push ebp
	mov ebp, esp

	pushad

	mov ecx, 4
outer_loop_head:
	mov ebx, 4
	sub ebx, ecx

	lea esi, [OFFSET letter_matrix + ebx]

	push 4
	push esi
	call populate_four_letter_set

	call print_set_if_it_has_two_vowels
	loop outer_loop_head

	popad
	
	mov esp, ebp
	pop ebp
	ret
iterate_over_columns ENDP


iterate_over_diagonals PROC
	push ebp
	mov ebp, esp

	pushad

	; Upper left to lower right diagonal
	mov esi, OFFSET letter_matrix

	push 5
	push esi
	call populate_four_letter_set

	call print_set_if_it_has_two_vowels


	; Upper right to lower left diagonal
	lea esi, [OFFSET letter_matrix + 3]

	push 3
	push esi
	call populate_four_letter_set

	call print_set_if_it_has_two_vowels

	popad
	
	mov esp, ebp
	pop ebp
	ret
iterate_over_diagonals ENDP


p911 PROC
	; Use the letter matrix generated in the prevous programming exercise as a starting point for this program.
	; Generate a single four-by-four letter matrix in which each letter has a 50% probability of being a vowel.
	; Traverse each matrix row, column, and diagonal, generating sets of letters.
	; Display only four-letter sits containing exactly two vowels.

	push OFFSET letter_matrix
	call generate_letter_matrix

	push OFFSET letter_matrix
	call print_letter_matrix
	call Crlf
	call Crlf

	mov edx, OFFSET rows_message
	call WriteString
	call Crlf
	call iterate_over_rows

	call Crlf

	mov edx, OFFSET columns_message
	call WriteString
	call Crlf
	call iterate_over_columns

	call Crlf

	mov edx, OFFSET diagonals_message
	call WriteString
	call Crlf
	call iterate_over_diagonals

	ret
p911 ENDP

end