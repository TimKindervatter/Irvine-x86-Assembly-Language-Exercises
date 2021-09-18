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
INCLUDE GraphWin.inc

.data
	console_handle HANDLE ?

	buffer_size = 100
	buffer BYTE buffer_size DUP(?), 0
	num_characters_read DWORD ?

	buffer_to_write BYTE "This string will be output", 0
	buffer_to_write_size = ($ - buffer_to_write)
	num_characters_written DWORD ?

	file_name BYTE "C:\Assembly\Irvine_Chapter_10\Irvine_Chapter_10\short_answer.asm", 0
	file_handle HANDLE ?
	file_buffer_size = 4096
	file_input_buffer BYTE file_buffer_size DUP(?)
	num_bytes_read_from_file DWORD ?

	output_file_name BYTE "C:\Assembly\Irvine_Chapter_11\Irvine_Chapter_11\test_output_file.txt", 0
	output_file_handle HANDLE ?
	output_file_buffer BYTE "This is a test of file output"
	output_file_buffer_size = ($ - output_file_buffer)
	num_bytes_written_to_file DWORD ?

	main_window_handle DWORD ?
	text BYTE "Has anyone really been far even as decided to use even go want to do look more like?", 0
	caption BYTE "Critical", 0

	className BYTE "?????", 0
	WindowName BYTE "Test Window", 0
	hInstance DWORD ?
.code

aw_111 PROC
	; Show an example of the ReadConsole function

	INVOKE GetStdHandle, STD_INPUT_HANDLE
	mov console_handle, eax

	INVOKE ReadConsole, console_handle, ADDR buffer, buffer_size, ADDR num_characters_read, 0

	mov esi, OFFSET buffer
	mov ecx, num_characters_read
	mov ebx, TYPE buffer
	call DumpMem

	ret
aw_111 ENDP


aw_112 PROC
	; Show an example call to the WriteConsole function

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov console_handle, eax

	INVOKE WriteConsole, console_handle, ADDR buffer_to_write, buffer_to_write_size, ADDR num_characters_written, 0

	ret
aw_112 ENDP


aw_113 PROC
	; Show an example call to the CreateFile function that will open an existing file for reading.

	INVOKE CreateFile, ADDR file_name, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0

	ret
aw_113 ENDP


aw_114 PROC
	; Show an example call to the CreateFile function that will create a new file with normal attributes, erasing any existing file with the same name.

	INVOKE CreateFile, ADDR output_file_name, GENERIC_WRITE, DO_NOT_SHARE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0

	ret
aw_114 ENDP


aw_115 PROC
	; Show an example call to the ReadFile function

	INVOKE CreateFile, ADDR file_name, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov file_handle, eax

	INVOKE ReadFile, file_handle, ADDR file_input_buffer, file_buffer_size, num_bytes_read_from_file, 0

	ret
aw_115 ENDP


aw_116 PROC
	; Show an example call to the WriteFile function

	INVOKE CreateFile, ADDR output_file_name, GENERIC_WRITE, DO_NOT_SHARE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov output_file_handle, eax

	INVOKE WriteFile, output_file_handle, ADDR output_file_buffer, output_file_buffer_size, ADDR num_bytes_written_to_file, 0

	ret
aw_116 ENDP


aw_117 PROC
	; Show an example call to the MessageBox function

	INVOKE CreateWindowEx, 0, ADDR className, ADDR WindowName, MAIN_WINDOW_STYLE, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInstance, NULL
	mov main_window_handle, eax

	INVOKE MessageBox, main_window_handle, ADDR text, ADDR caption, MB_YESNO + MB_ICONQUESTION

	ret
aw_117 ENDP

end