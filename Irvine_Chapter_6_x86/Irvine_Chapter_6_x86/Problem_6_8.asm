TITLE Problem 6-8

.386
.model flat, stdcall
.stack 4096

WriteString PROTO
Crlf PROTO

.data
	unencrypted_prompt BYTE "Plaintext message: ", 0
	encrypted_prompt BYTE "Encrypted message: ", 0
	decrypted_prompt BYTE "Decrypted message: ", 0

	plain_text BYTE "This is a Plaintext message", 0
	encrypted BYTE LENGTHOF plain_text DUP(?)
	decrypted BYTE LENGTHOF plain_text DUP(?)
	key BYTE "ABXmv#7", 0
.code

p68 PROC
	; Revise the encryption program from Section 6.3.4 in the following manner:
	; Create an encryption key consisting of multiple characters. Use this key to encrypt and decrypt the plaintext by XORing each character of the key agains the corresponding byte in the message.
	; Repeat the key as many times as necessary until all plain text bytes are translated.
	mov edx, OFFSET unencrypted_prompt
	call WriteString
	mov edx, OFFSET plain_text
	call WriteString
	call Crlf

	mov esi, OFFSET plain_text
	mov edi, OFFSET encrypted
	mov edx, OFFSET key
	call encrypt

	mov edx, OFFSET encrypted_prompt
	call WriteString
	mov edx, OFFSET encrypted
	call WriteString
	call Crlf

	mov esi, OFFSET encrypted
	mov edi, OFFSET decrypted
	mov edx, OFFSET key
	call encrypt

	mov edx, OFFSET decrypted_prompt
	call WriteString
	mov edx, OFFSET decrypted
	call WriteString

	ret
p68 ENDP

encrypt PROC
; ----------------------------------------------------------------------------
; Args:
;	esi: Contains base address of string to encrypt
;	edi: Contains base address of where encrypted string will be stored
;	edx: Contains base address of encryption key
; Returns:
;	N/A
; ----------------------------------------------------------------------------

	push eax
	push ecx

	mov ecx, edx				; The encryption key pointer may need to be reset while encrypting the string, so store the base address to be restored later

loop_head:
	; Perform the encryption using XOR
	mov al, [esi]
	xor al, [edx]
	mov [edi], al
	
	inc edi						; Advance to the next character of the output string
	inc esi						; Advance to the next character of the input string
	cmp BYTE PTR [esi], 0
	jz done						; If the next character is the null terminator, we're done

	inc edx						; Advance to the next character of the encryption key
	cmp BYTE PTR [edx], 0
	jnz continue				; If we're not at the null terminator yet, move on to the next loop iteration
	mov edx, ecx				; If we've arrived at the null terminator, we need to start over. We restore the base pointer of the encryption key which was saved earlier.
continue:
	jmp loop_head

done:
	pop ecx
	pop eax
	ret
encrypt ENDP

decrypt PROC
; ----------------------------------------------------------------------------
; Args:
;	esi: Contains base address of string to decrypt
;	edi: Contains base address of where decrypted string will be stored
;	edx: Contains base address of encryption key
; Returns:
;	N/A
; ----------------------------------------------------------------------------

	; We're using symmetric key encryption with XOR, so we can just run the encrypted string back through the encrypt procedure to undo the encryption.
	call encrypt
	ret
decrypt ENDP

end