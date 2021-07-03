TITLE Problem 6-5

.386
.model flat, stdcall
.stack 4096

WriteString PROTO
ReadInt PROTO
ReadHex PROTO
WriteHex PROTO

.data
	Menu BYTE "Which operation would you like to perform?", 13, 10,
			  "1. x AND y", 13, 10, 
			  "2. x OR y", 13, 10, 
			  "3. NOT x", 13, 10, 
			  "4. x XOR y", 13, 10, 
			  "5. Exit program", 13, 10, 13, 10, 0
	op_table BYTE 1
			 DWORD do_and
	entry_size = ($ - op_table)
			 BYTE 2
			 DWORD do_or
			 BYTE 3
			 DWORD do_not
			 BYTE 4
			 DWORD do_xor
			 BYTE 5
			 DWORD do_exit
	table_length = ($ - op_table) / entry_size

	enter_prompt BYTE "Enter a menu item between 1 and 5: ", 0
	out_of_range_prompt BYTE "Invalid selection. ", 0

	first_op_prompt BYTE "Enter the first operand (in hex): ", 0
	second_op_prompt BYTE "Enter the second operand (in hex): ", 0
	
	first_op DWORD ?	
	second_op DWORD ?

	and_prompt BYTE "Performing AND operation...", 13, 10, 0
	or_prompt BYTE "Performing OR operation...", 13, 10, 0
	not_prompt BYTE "Performing NOT operation...", 13, 10, 0
	xor_prompt BYTE "Performing XOR operation...", 13, 10, 0
	exit_prompt BYTE "Exiting...", 13, 10, 0

	result_prompt BYTE "The result is: ", 0
.code

p65_66 PROC
	; Create a program that functions as a simple boolean calculator for 32-bit integers. It should display a menu that asks the user to make a selection from the following list:
	;	1. x AND y
	;	2. x OR y
	;	3. NOT x
	;	4. x XOR y
	;	5. Exit program
	; When the user makes a choice, call a procedure that displays the name of the operation about to be performed.
	; You must implement this procedure using the Table-Driven Selection technique outlined in Section 6.5.4.

	mov edx, OFFSET Menu
	call WriteString
select_item:
	mov edx, OFFSET enter_prompt
	call WriteString
	call ReadInt

	; Check whether user-entered value was in range. If so, move on. If not, inform the user that their selection was out of range and prompt them to re-enter their selection.
	cmp eax, 1
	jb invalid							; If user-entered value is less than 1, invalid
	cmp eax, 5
	ja invalid							; If user-entered value is greater than 5, invalid
	jmp valid							; If we're here, 1 <= eax <= 5, which is valid
invalid:
	mov edx, OFFSET out_of_range_prompt
	call WriteString
	jmp select_item

valid:
	mov esi, OFFSET op_table
	mov ecx, table_length
loop_head:
	mov bl, BYTE PTR [esi]
	cmp al, bl						; The user-entered menu selection is in eax after ReadInt. Compare that to the current table entry
	jne continue						; If this table entry was not the correct one, move on to the next one
	call NEAR PTR [esi + TYPE BYTE]		; If we found the correct table entry, call the process whose pointer is stored in this table entry

continue:
	add esi, entry_size					; Advance the table pointer to the next entry
	loop loop_head
	ret
p65_66 ENDP

do_and PROC
	mov edx, OFFSET first_op_prompt
	call WriteString
	call ReadHex
	mov [first_op], eax

	mov edx, OFFSET second_op_prompt
	call WriteString
	call ReadHex

	mov edx, OFFSET and_prompt
	call WriteString

	and eax, [first_op]
	mov edx, OFFSET result_prompt
	call WriteString
	call WriteHex

	ret
do_and ENDP

do_or PROC
	mov edx, OFFSET first_op_prompt
	call WriteString
	call ReadHex
	mov [first_op], eax

	mov edx, OFFSET second_op_prompt
	call WriteString
	call ReadHex

	mov edx, OFFSET or_prompt
	call WriteString

	or eax, [first_op]
	mov edx, OFFSET result_prompt
	call WriteString
	call WriteHex

	ret
do_or ENDP

do_not PROC
	mov edx, OFFSET first_op_prompt
	call WriteString
	call ReadHex

	mov edx, OFFSET not_prompt
	call WriteString

	not eax
	mov edx, OFFSET result_prompt
	call WriteString
	call WriteHex

	ret
do_not ENDP

do_xor PROC
	mov edx, OFFSET first_op_prompt
	call WriteString
	call ReadHex
	mov [first_op], eax

	mov edx, OFFSET second_op_prompt
	call WriteString
	call ReadHex

	mov edx, OFFSET xor_prompt
	call WriteString

	xor eax, [first_op]
	mov edx, OFFSET result_prompt
	call WriteString
	call WriteHex

	ret
do_xor ENDP

do_exit PROC
	mov edx, OFFSET exit_prompt
	call WriteString
	ret
do_exit ENDP

end