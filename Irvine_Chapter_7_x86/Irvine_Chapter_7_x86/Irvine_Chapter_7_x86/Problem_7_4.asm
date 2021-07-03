.386
.model flat, stdcall
.stack 4096

.data
	plaintext1 BYTE "This message will be encrypted"
	LENGTH1 = LENGTHOF plaintext1
	key1 BYTE -2, 4, 1, 0, -3, 5, 2, -4, -4, 6
	KEYLENGTH1 = LENGTHOF key1
.code

p74 PROC
	; Write a procedure that performs simple encryption by rotating each plaintext byte a varying number of positions in different directions.
	; For example, in the following array that represents the encryption key, a negative value indicates rotation to the left and a positive value indicates rotation to the right.
	;	key BYTE -2, 4, 1, 0, -3, 5, 2, -4, -4, 6
	; Your procedure should loop through a plaintext message and align the key to the first 10 bytes of the message. Then align the key to the next 10 bytes of the message and repeat the process.
	; Write a program that tests your encryption procedure by calling it twice with different data sets.

	mov esi, OFFSET plaintext1
	mov edi, OFFSET key1
	mov ebx, LENGTH1 
	mov edx, KEYLENGTH1
	call rotate_encrypt
	call rotate_decrypt

	ret
p74 ENDP

rotate_encrypt PROC
	; Args:
	;	esi: base address of the plaintext message to encrypt
	;	edi: base address of encryption key
	;	ebx: size of message to encrypt
	;	edx: size of key

	push eax							; If eax has a value that the caller is relying upon, save it so it can be restored later
	push ecx							; If ecx has a value that the caller is relying upon, save it so it can be restored later

	push esi
	push ebx
	push edx							; Save the size of the key so that it can be restored later
	push edi							; Save the key base address so it can be restored later

	xor ecx, ecx

loop_head:
	mov cl, [edi]
	ror BYTE PTR [esi], cl				; Rotate the current byte of the plaintext message by the current byte of the key

	inc esi
	inc edi

	dec edx
	cmp edx, 0
	jnz do_not_reset_key_pointer
	mov edx, [esp + 4]					; Restore the size of the key, which is the second element on the stack
	mov edi, [esp]						; Restore the key's base address, which is on top of the stack

do_not_reset_key_pointer:
	dec ebx
	cmp ebx, 0
	jne loop_head

	pop edi
	pop edx
	pop ebx
	pop esi

	pop ecx
	pop eax
	ret
rotate_encrypt ENDP

rotate_decrypt PROC
	; Args:
	;	esi: base address of the plaintext message to encrypt
	;	edi: base address of encryption key
	;	ebx: size of message to encrypt
	;	edx: size of key

	push eax							; If eax has a value that the caller is relying upon, save it so it can be restored later
	push ecx							; If ecx has a value that the caller is relying upon, save it so it can be restored later

	push esi
	push ebx
	push edx							; Save the size of the key so that it can be restored later
	push edi							; Save the key base address so it can be restored later

	xor ecx, ecx

loop_head:
	mov cl, [edi]
	rol BYTE PTR [esi], cl				; Rotate the current byte of the plaintext message by the current byte of the key

	inc esi
	inc edi

	dec edx
	cmp edx, 0
	jnz do_not_reset_key_pointer
	mov edx, [esp + 4]					; Restore the size of the key, which is the second element on the stack
	mov edi, [esp]						; Restore the key's base address, which is on top of the stack

do_not_reset_key_pointer:
	dec ebx
	cmp ebx, 0
	jne loop_head

	pop edi
	pop edx
	pop ebx
	pop esi

	pop ecx
	pop eax
	ret
rotate_decrypt ENDP

end