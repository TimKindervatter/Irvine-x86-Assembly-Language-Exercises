IFDEF RAX
	END_IF_NOT_X64 EQU <>
ELSE
	END_IF_NOT_X64 EQU end
ENDIF

END_IF_NOT_X64

;------------------------------------------------------------
Str_length PROTO
; Returns the length of a null-terminated string
; Input parameter: RCX points to the string
; Return value: RAX contains the string’s length
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
	before_trimming BYTE "Before trimming: ", 0
	after_trimming BYTE "After trimming: ", 0

	string_to_trim1 BYTE "String to trim@@@@@@", 0
	string_to_trim2 BYTE "String @to trim@@@@@@", 0
	string_to_trim3 BYTE "@", 0
	string_to_trim4 BYTE "String to trim", 0
	string_to_trim5 BYTE "@String to trim"

.code

; 32-bit implementation of Str_trim:

;------------------------------------------------------------
; Str_trim
; Remove all occurrences of a given delimiter character from the end of a string.
; Returns: nothing
;------------------------------------------------------------
; Str_trim PROC USES eax ecx edi,
; 	pString: PTR BYTE,
; 	char: BYTE

; 	mov edi, pString					; prepare to call Str_length
;	INVOKE Str_length, edi				; returns the length in EAX
;	cmp eax,0							; is the length equal to zero?
;	je L3								; yes: exit now
;	mov ecx, eax						; no: ECX = string length
;	dec eax
;	add edi, eax						; point to last character
; L1: 
;	mov al, [edi]						; get a character
;	cmp al, char						; is it the delimiter?
;	jne L2								; no: insert null byte
;	dec edi								; yes: keep backing up
;	loop L1								; until beginning reached
; L2: 
;	mov BYTE PTR [edi+1], 0 ; insert a null byte
; L3: 
;	ret
; Str_trim ENDP


;------------------------------------------------------------
; Str_trim_64
; Remove all occurrences of a given delimiter character from the end of a string.
; Args:
;	RCX: Pointer to a string to be trimmed.
;	RDX: Character to be trimmed from the end of the passed string.
; Returns: nothing
;------------------------------------------------------------
Str_trim_64 PROC
	; In Windows x64 calling convention, first integer argument is passed in rcx, second in rdx.
	; So rcx contains the pointer to a string to trim, and rdx contains the character to trim.

	push rbp
	mov rbp, rsp

	push rax
	push rcx
	push rdi

	; rcx already contains the pointer to the string
	call Str_length						; returns the length in RAX

	cmp rax, 0							; is the length equal to zero?
	je L3								; yes: exit now

	mov rdi, rax						; no: RDI = string length
	dec rax
	add rcx, rax						; point to last character
 L1: 
	mov al, [rcx]						; get a character
	cmp al, dl							; is it the delimiter?
	jne L2								; no: insert null byte
	dec rcx								; yes: keep backing up
	loop L1								; until beginning reached
 L2: 
	mov BYTE PTR [rcx + 1], 0			; insert a null byte
 L3: 
	pop rdi
	pop rcx
	pop rax
	
	mov rsp, rbp
	pop rbp

	ret
Str_trim_64 ENDP


;------------------------------------------------------------
; trim_at_symbol_64
; Trims the "@" symbol from the end of the passed string. Prints the string before and after trimming to the console.
; Args:
;	RCX: Pointer to a string to be trimmed.
; Returns: nothing
;------------------------------------------------------------
trim_at_symbol_64 PROC
	; Preamble
	push rbp
	mov rbp, rsp

	push rdx


	; Show the string before it is trimmed
	mov rdx, OFFSET before_trimming
	call WriteString

	mov rdx, rcx
	call WriteString
	call Crlf


	; Trim the @ symbol from the end of the string
	; rcx already contains the pointer to the string
	mov rdx, "@"
	call Str_trim_64


	; Show the trimmed string
	mov rdx, OFFSET after_trimming
	call WriteString

	mov rdx, rcx
	call WriteString
	call Crlf
	call Crlf


	; Clean up
	pop rdx
	
	mov rsp, rbp
	pop rbp
	ret
trim_at_symbol_64 ENDP


aw_99 PROC
	; Create a 64-bit version of the Str_trim procedure.

	push rbp
	mov rbp, rsp

	push rcx

	mov rcx, OFFSET string_to_trim1
	call trim_at_symbol_64

	mov rcx, OFFSET string_to_trim2
	call trim_at_symbol_64

	mov rcx, OFFSET string_to_trim3
	call trim_at_symbol_64

	mov rcx, OFFSET string_to_trim4
	call trim_at_symbol_64

	mov rcx, OFFSET string_to_trim5
	call trim_at_symbol_64

	pop rcx
	
	mov rsp, rbp
	pop rbp

	ret
aw_99 ENDP

end