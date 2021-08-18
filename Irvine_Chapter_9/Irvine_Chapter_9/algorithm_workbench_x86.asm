IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

;-----------------------------------------------------------
Str_compare PROTO,
	string1: PTR BYTE,
	string2: PTR BYTE
;
; Compares two strings.
; Returns nothing, but the Zero and Carry flags are affected
; exactly as they would be by the CMP instruction.

; Relation					Carry Flag			Zero Flag		Branch If True
; string1 < string2			1					0				JB
; string1 = string2			0					1				JE
; string1 > string2			0					0				JA
;-----------------------------------------------------------

;------------------------------------------------------------
Str_trim PROTO,
	pString: PTR BYTE,
	char: BYTE

; Remove all occurrences of a given delimiter character from the end of a string.
; Returns: nothing
;------------------------------------------------------------

;-----------------------------------------------------------
WriteString PROTO

; Writes a null-terminated string to the console window.
; Pass the string's offset in the EDX register.
;-----------------------------------------------------------

;-----------------------------------------------------------
Crlf PROTO

; Writes a newline to the console
;-----------------------------------------------------------

.data
	array DWORD 00001000h, 20003000h, 40005000h, 60007000h, 80009000h, 0A000B000h, 0C000D000h, 0E000F000h
	array2 DWORD 10000000h, 30002000h, 50004000h, 70006000h, 90008000h, 0B000A000h, 0D000C000h, 0F000E000h

	two_dimensional_array DWORD 00001000h, 20003000h, 40005000h, 60007000h
	ROW_SIZE = ($ - two_dimensional_array)
						  DWORD 80009000h, 0A000B000h, 0C000D000h, 0E000F000h
						  DWORD 04201337h, 69694242h, 0DEADBEEFh, 0BADF00Dh

	sourcew WORD 0000h, 1000h, 2000h, 3000h, 4000h, 5000h, 6000h, 7000h
	targetw WORD 0000h, 1000h, 2000h, 3000h, 0DEADh, 0BEEFh, 6000h, 7000h

	wordArray WORD 0000h, 0000h, 0000h, 0000h, 0100h, 0000h, 0000h, 0000h

	first_string BYTE "First String", 0
	second_string BYTE "Second String", 0

	third_string BYTE "This string is longer", 0
	fourth_string BYTE "Short string"

	before_trimming BYTE "Before trimming: ", 0
	after_trimming BYTE "After trimming: ", 0

	string_to_trim1 BYTE "String to trim@@@@@@", 0
	string_to_trim2 BYTE "String @to trim@@@@@@", 0
	string_to_trim3 BYTE "@", 0
	string_to_trim4 BYTE "String to trim", 0
	string_to_trim5 BYTE "@String to trim"

	string_to_make_lowercase1 BYTE "THIS STRING WILL BE LOWERCASE", 0
	string_to_make_lowercase2 BYTE "tHis STrIng WiLL aLSo bE loWeRCasE", 0

	myArray DWORD 00001000h, 20003000h, 40005000h, 60007000h
	MY_ARRAY_ROW_SIZE = ($ - myArray)
			DWORD 80009000h, 0A000B000h, 0C000D000h, 0E000F000h

.code

aw_91 PROC
	; Show an example of a base-index operand in 32-bit mode

	push ebp
	mov ebp, esp

	mov esi, OFFSET array
	mov edi, TYPE array
	mov eax, [esi + 2*edi]

	mov esi, OFFSET array2
	mov edi, TYPE array2
	; mov eax, [esi + 5*edi]			; Invalid because scale factor must be 2, 4, or 8

	mov esp, ebp
	pop ebp
	ret
aw_91 ENDP


aw_92 PROC
	; Show an example of a base-index-displacement operand in 32-big mode

	push ebp
	mov ebp, esp

	mov esi, OFFSET array
	mov edi, TYPE array
	mov eax, [esi + 2*edi + 2]

	mov esi, OFFSET array2
	mov edi, TYPE array2
	mov eax, [esi + 2*edi + 2]

	mov esp, ebp
	pop ebp
	ret
aw_92 ENDP


aw_93 PROC
	; Suppose a two-dimensional array of doublewords has three logical rows and four logical columns.
	; Write an expression using esi and edi that addresses the third column in the second row (numbering for rows and columns starts at zero).

	push ebp
	mov ebp, esp

	mov eax, ROW_SIZE
	mov ebx, 1							; Row index
	mul ebx
	mov esi, eax
	mov edi, 2							; Column index
	mov eax, two_dimensional_array[esi + edi*TYPE two_dimensional_array]

	mov esp, ebp
	pop ebp
	ret
aw_93 ENDP


aw_94 PROC
	; Write instructions using CMPSW that compare two arrays of 16-bit values named sourcew and targetw

	push ebp
	mov ebp, esp

	mov esi, OFFSET sourcew
	mov edi, OFFSET targetw
	repe cmpsw

	mov ax, [esi]						; Will hold 5000h, since repe cmpsw increments esi even on the iteration where the source and target differ. For sanity check in debugger.
	mov bx, [edi]						; Will hold BEEFh, since repe cmpsw increments edi even on the iteration where the source and target differ. For sanity check in debugger.

	mov esp, ebp
	pop ebp
	ret
aw_94 ENDP


aw_95 PROC
	; Write instructions that use SCASW to scan for the 16-bit value 0100h in an array named wordArray and copy the offset of the matching member into the EAX register.

	push ebp
	mov ebp, esp

	mov edi, OFFSET wordArray
	mov ax, 0100h
	repne scasw

	sub edi, TYPE wordArray					; Need to decrement the wordArray pointer by 1 element, since repne scasw will point one past the element that matched
	mov eax, edi
	mov bx, [edi]							; Will hold 0100h, for sanity check in debugger

	mov esp, ebp
	pop ebp
	ret
aw_95 ENDP


print_longer_string PROC
	string_1 EQU [ebp + 8]
	string_2 EQU [ebp + 12]

	; Preamble
	push ebp
	mov ebp, esp

	push edx								; Registers that are to be preserved should be pushed after the standard preamble so that argument offsets from ebp are not messed up


	; Compare the length of the two strings passed on the stack
	push string_2
	push string_1
	call Str_compare

	jb string2_greater

string1_greater:
	mov edx, string_1
	jmp print_string

string2_greater:
	mov edx, string_2

print_string:
	call WriteString
	call Crlf


	; Clean up
	pop edx

	mov esp, ebp
	pop ebp
	ret 8
print_longer_string ENDP


aw_96 PROC
	; Write a sequence of instructions that use the Str_compare procedure to determine the larger of two input strings and write it to the console window
	
	push ebp
	mov ebp, esp

	push OFFSET second_string
	push OFFSET first_string
	call print_longer_string

	push OFFSET fourth_string
	push OFFSET third_string
	call print_longer_string

	mov esp, ebp
	pop ebp
	ret
aw_96 ENDP


trim_at_symbol PROC
	string_to_trim EQU [ebp + 8]

	; Preamble
	push ebp
	mov ebp, esp

	push edx


	; Show the string before it is trimmed
	mov edx, OFFSET before_trimming
	call WriteString

	mov edx, string_to_trim
	call WriteString
	call Crlf


	; Trim the @ symbol from the end of the string
	push "@"
	push string_to_trim
	call Str_trim


	; Show the trimmed string
	mov edx, OFFSET after_trimming
	call WriteString

	mov edx, string_to_trim
	call WriteString
	call Crlf
	call Crlf

	; Clean up
	pop edx
	
	mov esp, ebp
	pop ebp
	ret 4
trim_at_symbol ENDP


aw_97 PROC
	; Show how to call the Str_trim procedure and remove all trailing "@" characters from a string.

	push ebp
	mov ebp, esp

	push OFFSET string_to_trim1
	call trim_at_symbol

	push OFFSET string_to_trim2
	call trim_at_symbol

	push OFFSET string_to_trim3
	call trim_at_symbol

	push OFFSET string_to_trim4
	call trim_at_symbol

	push OFFSET string_to_trim5
	call trim_at_symbol

	mov esp, ebp
	pop ebp
	ret
aw_97 ENDP


Str_lcase PROC
	;-------------------------------------------------------
	; Str_lcase
	; Converts a null-terminated string to lowercase.
	; Returns: nothing
	;-------------------------------------------------------

	string_to_make_lowercase EQU [ebp + 8]

	push ebp
	mov ebp, esp

	push eax
	push esi

	mov esi, string_to_make_lowercase
L1:
	mov al, [esi]					; get char
	cmp al, 0						; end of string?
	je L3							; yes: quit

	cmp al, 'A'						; below "A"?
	jb L2

	cmp al, 'Z'						; above "Z"?
	ja L2

	or BYTE PTR [esi], 00100000b	; convert the char
L2: 
	inc esi							; next char
	jmp L1
L3: 
	pop esi
	pop eax

	mov esp, ebp
	pop ebp
	ret 4
Str_lcase ENDP


; Str_ucase as defined in Irvine32:

;-------------------------------------------------------
; Str_ucase
; Converts a null-terminated string to uppercase.
; Returns: nothing
;-------------------------------------------------------

; Str_ucase PROC USES eax esi,
; pString:PTR BYTE

;	 mov esi,pString
; L1:
;	 mov al, [esi]					; get char
;	 cmp al, 0						; end of string?
;	 je L3							; yes: quit

;	 cmp al, 'a'					; below "a"?
;	 jb L2

;	 cmp al,'z'						; above "z"?
;	 ja L2

;	 and BYTE PTR [esi], 11011111b	; convert the char
; L2: 
;	inc esi							; next char
;	jmp L1
; L3: 
;	ret
; Str_ucase ENDP


aw_98 PROC
	; Show how to modify the Str_ucase procedure from the Irvine32 library so it changes all characters to lower case.

	push ebp
	mov ebp, esp

	push edx

	push OFFSET string_to_make_lowercase1
	call Str_lcase

	mov edx, OFFSET string_to_make_lowercase1
	call WriteString
	call Crlf

	push OFFSET string_to_make_lowercase2
	call Str_lcase

	mov edx, OFFSET string_to_make_lowercase2
	call WriteString
	call Crlf

	pop edx

	mov esp, ebp
	pop ebp

	ret
aw_98 ENDP


aw_911 PROC
	; Assuming that EBX contains a row index into a two-dimensional array of 32-bit integers named myArray and EDI contains the index of a column, 
	; write a single statement that moves the content of the given array element into the EAX register.

	push ebp
	mov ebp, esp

	mov esi, MY_ARRAY_ROW_SIZE
	mov ebx, 1
	imul ebx, esi
	mov edi, 3
	mov eax, myArray[ebx + edi*TYPE myArray]

	mov esp, ebp
	pop ebp
	ret
aw_911 ENDP

end