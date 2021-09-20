IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

INCLUDE Irvine32.inc
INCLUDE console_string_macros.inc

Str_length PROTO

mWriteFile MACRO file_handle, string, num_characters
	INVOKE Str_length, ADDR string
	INVOKE WriteFile, file_handle, ADDR string, eax, ADDR num_characters, 0
ENDM

.data
	filename byte "student_records.txt"

	file_handle HANDLE ?
	output_handle HANDLE ?
	input_handle HANDLE ?

	student_ID_number_prompt BYTE "Enter Student ID Number: ", 0
	last_name_prompt BYTE "Enter last name: ", 0
	first_name_prompt BYTE "Enter first name: ", 0
	date_of_birth_prompt BYTE "Enter date of birth: ", 0

	string_buffer_size = 100
	student_ID BYTE string_buffer_size DUP(?)
	last_name BYTE string_buffer_size DUP(?)
	first_name BYTE string_buffer_size DUP(?)
	date_of_birth BYTE string_buffer_size DUP(?)

	newline BYTE 13, 10, 0

	characters_read DWORD ? 
.code

p116 PROC
	; Write a program that creates a new text file.
	; Prompt the user for a student identification number, last name, first name, and date of birth.
	; Write this information to the file.
	; Input several more records in the same manner and close the file.

	INVOKE CreateFile, ADDR filename, GENERIC_WRITE, DO_NOT_SHARE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov file_handle, eax

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov output_handle, eax

	INVOKE GetStdHandle, STD_INPUT_HANDLE
	mov input_handle, eax

	mov ecx, 5
loop_head:
	push ecx

	mWriteStringToConsole student_ID_number_prompt, characters_read
	mReadStringFromConsole student_ID, characters_read

	mWriteFile file_handle, student_ID_number_prompt, characters_read
	mWriteFile file_handle, student_ID, characters_read
	mWriteFile file_handle, newline, characters_read

	mWriteStringToConsole last_name_prompt, characters_read
	mReadStringFromConsole last_name, characters_read

	mWriteFile file_handle, last_name_prompt, characters_read
	mWriteFile file_handle, last_name, characters_read
	mWriteFile file_handle, newline, characters_read

	mWriteStringToConsole first_name_prompt, characters_read
	mReadStringFromConsole first_name, characters_read

	mWriteFile file_handle, first_name_prompt, characters_read
	mWriteFile file_handle, first_name, characters_read
	mWriteFile file_handle, newline, characters_read

	mWriteStringToConsole date_of_birth_prompt, characters_read
	mReadStringFromConsole date_of_birth, characters_read
	
	mWriteFile file_handle, date_of_birth_prompt, characters_read
	mWriteFile file_handle, date_of_birth, characters_read
	mWriteFile file_handle, newline, characters_read

	call Crlf
	call Crlf

	mWriteFile file_handle, newline, characters_read
	mWriteFile file_handle, newline, characters_read

	pop ecx

	dec ecx
	cmp ecx, 0
	jne loop_head

	ret
p116 ENDP

end