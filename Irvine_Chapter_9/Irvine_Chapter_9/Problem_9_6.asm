IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

.data
	target1 BYTE "AAEBDCFBBC",0
	freqTable1 DWORD 256 DUP(0)
.code

Get_frequencies PROC
	string EQU [ebp + 8]
	frequency_table EQU [ebp + 12]

	push ebp
	mov ebp, esp

	mov esi, string
	mov edi, frequency_table
	
continue:
	xor eax, eax
	mov al, BYTE PTR [esi]
	inc BYTE PTR [edi + eax]

	inc esi

	cmp BYTE PTR [esi], 0
	jne continue

	mov esp, ebp
	pop ebp
	ret 8
Get_frequencies ENDP

p96 PROC
	; Write a procedure named Get_frequencies that constructs a character frequency table. 
	; Input to the procedure should be a pointer to a string and a pointer to an array of 256 doublewords initialized to all zeros. Each array position is indexed by its corresponding ASCII code.
	; When the procedure returns, each entry in the array contains a count of how many times the corresponding character occurred in the string.

	; For example:
	; .data
	;	target BYTE "AAEBDCFBBC",0
	;	freqTable DWORD 256 DUP(0)
	; .code
	;	INVOKE Get_frequencies, ADDR target, ADDR freqTable

	push ebp
	mov ebp, esp

	push OFFSET freqTable1
	push OFFSET target1
	call Get_frequencies

	mov esp, ebp
	pop ebp
	ret
p96 ENDP

end