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

Crlf PROTO

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

	mWriteStringToConsole first_name_prompt, num_characters
	mReadStringFromConsole first_name, num_characters

	mWriteStringToConsole last_name_prompt, num_characters
	mReadStringFromConsole last_name, num_characters

	mWriteStringToConsole age_prompt, num_characters
	mReadStringFromConsole age, num_characters

	mWriteStringToConsole phone_number_prompt, num_characters
	mReadStringFromConsole phone_number, num_characters
	
	call Crlf
	call Crlf

	mWriteStringToConsole first_name_string, num_characters
	mWriteStringToConsole first_name, num_characters

	mWriteStringToConsole last_name_string, num_characters
	mWriteStringToConsole last_name, num_characters

	mWriteStringToConsole age_string, num_characters
	mWriteStringToConsole age, num_characters

	mWriteStringToConsole phone_number_string, num_characters
	mWriteStringToConsole phone_number, num_characters
	
	ret
p112 ENDP

end