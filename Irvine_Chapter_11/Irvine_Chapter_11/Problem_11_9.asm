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

.data
	file_name BYTE "C:\Assembly\Irvine_Chapter_11\Irvine_Chapter_11\student_records.txt", 0
	prompt BYTE " was last accessed on: "
	file_handle HANDLE ?

	invalid_handle_prompt BYTE "Invalid file handle"

	last_access_file_time FILETIME <>
	last_access_system_time SYSTEMTIME <>

	output_handle HANDLE ?
.code

LastAccessDate PROC
	file_name_pointer EQU [ebp + 8]

	push ebp
	mov ebp, esp

	pushad

	INVOKE CreateFile, ADDR file_name, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov file_handle, eax

	cmp file_handle, INVALID_HANDLE_VALUE
	je invalid_file

	INVOKE GetFileTime, file_handle, 0, ADDR last_access_file_time, 0
	INVOKE FileTimeToSystemTime, ADDR last_access_file_time, ADDR last_access_system_time

	INVOKE CloseHandle, file_handle
	clc
	jmp done

invalid_file:
	stc

done:
	popad

	mov esp, ebp
	pop ebp

	ret 4
LastAccessDate ENDP

p119 PROC
	; Write a procedure named LastAccessDate that fills a SYSTEMTIME structure with the date and time stamp of a file.
	; Pass the offset of a filename in EDX, and pass the offset of a SYSTEMTIME structure in ESI.
	; If the function failes to find the file, set the carry flag.
	; When you implement this function, you will need to open the file, get its handle, pass the handle to GetFileTime, pass its output to FileTimeToSystemTime, and close the file.
	; Write a test program that calls your procedure and prints out the date when a particular file was last accessed.
	; Sample: 
	;	ch11_09.asm was last accessed on: 6/16/2005

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov output_handle, eax

	push OFFSET file_name
	call LastAccessDate
	jc file_not_found

	INVOKE WriteConsole, output_handle, ADDR file_name, SIZEOF file_name, 0, 0
	INVOKE WriteConsole, output_handle, ADDR prompt, SIZEOF prompt, 0, 0
	
	mov ax, last_access_system_time.wMonth
	call WriteDec
	
	mov ax, "/"
	call WriteChar

	mov ax, last_access_system_time.wDay
	call WriteDec
	
	mov ax, "/"
	call WriteChar

	mov ax, last_access_system_time.wYear
	call WriteDec
	jmp done

file_not_found:
	INVOKE WriteConsole, output_handle, ADDR invalid_handle_prompt, SIZEOF invalid_handle_prompt, 0, 0

done:
	ret
p119 ENDP

end