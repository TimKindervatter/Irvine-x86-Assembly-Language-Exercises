insert_null_terminator PROTO

mWriteStringToConsole MACRO string, num_characters_written
	INVOKE WriteConsole, output_handle, ADDR string, SIZEOF string, ADDR num_characters_written, 0
ENDM

mReadStringFromConsole MACRO string_buffer, num_characters_written
	INVOKE ReadConsole, input_handle, ADDR string_buffer, SIZEOF string_buffer, ADDR num_characters_written, 0

	push OFFSET string_buffer
	call insert_null_terminator
ENDM