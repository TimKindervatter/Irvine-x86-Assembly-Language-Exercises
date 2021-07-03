.386
.model flat, stdcall
.stack 4096

WriteChar PROTO

.data

.code

aw_713 PROC
	; Write a procedure that displays an unsigned 8-bit binary value in decimal format. Pass the binary value in AL. The input range is limited to 0 to 99, decimal. 
	; The only procedure you can call from the book’s link library is WriteChar. The procedure should contain approximately eight instructions. 
	; Here is a sample call:
	;	mov al, 65 ; range limit: 0 to 99
	;	all showDecimal8

	mov bl, 10
	div bl						; The input is in al, so the remainder of this division will be stored in ah and the quotient will be in al
	
	add al, 30h					; Adding 30h to the quotient gives its ascii representation. We are guaranteed that the quotient is in [0, 9] because the input is in [0, 99]
	call WriteChar
	
	add ah, 30h					; Adding 30h to the remainder gives its ascii representation. The character 30h is the ascii character 0. 31h is the ascii character for 1, etc.
	ror ax, 8					; Swap ah and al so the remainder can be used in WriteChar (which expects its input in al)
	call WriteChar
	
	ret
aw_713 ENDP

end