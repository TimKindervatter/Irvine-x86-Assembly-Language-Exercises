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

insert_null_terminator PROTO
Crlf PROTO

mWriteStringToConsole MACRO string
	INVOKE WriteConsole, output_handle, ADDR string, SIZEOF string, ADDR num_characters, 0
ENDM

mReadStringFromConsole MACRO string_buffer
	INVOKE ReadConsole, input_handle, ADDR string_buffer, SIZEOF string_buffer, ADDR num_characters, 0

	push OFFSET string_buffer
	call insert_null_terminator
ENDM

.data
	output_handle HANDLE ?
	input_handle HANDLE ?

	num_characters DWORD ?

	first_name_prompt BYTE "Please enter first name: ", 0
	last_name_prompt BYTE "Please enter last name: ", 0
	age_prompt BYTE "Please enter age: ", 0
	phone_number_prompt BYTE "Please enter phone number: ", 0

	first_name_string BYTE "First Name: ", 0
	last_name_string BYTE "Last Name: ", 0
	age_string BYTE "Age: ", 0
	phone_number_string BYTE "Phone Number: ", 0

	string_buffer_size = 80
	first_name BYTE string_buffer_size DUP(?)
	last_name BYTE string_buffer_size DUP(?)
	age BYTE string_buffer_size DUP(?)
	phone_number BYTE string_buffer_size DUP(?)
.code

p112 PROC
	; Write a program that inputs the follwing information from the user, using the Win32 ReadConsole function: first name, last name, age, phone number.
	; Redisplay the same information with labels and attractive formatting, using the Win32 WriteConsole function.
	; Do not use any procedures from the Irvine32 library.

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov output_handle, eax
	
	INVOKE GetStdHandle, STD_INPUT_HANDLE
	mov input_handle, eax

	mWriteStringToConsole first_name_prompt
	mReadStringFromConsole first_name

	mWriteStringToConsole last_name_prompt
	mReadStringFromConsole last_name

	mWriteStringToConsole age_prompt
	mReadStringFromConsole age

	mWriteStringToConsole phone_number_prompt
	mReadStringFromConsole phone_number
	
	call Crlf
	call Crlf

	mWriteStringToConsole first_name_string
	mWriteStringToConsole first_name

	mWriteStringToConsole last_name_string
	mWriteStringToConsole last_name

	mWriteStringToConsole age_string
	mWriteStringToConsole age

	mWriteStringToConsole phone_number_string
	mWriteStringToConsole phone_number
	
	ret
p112 ENDP

end