.386
.model flat, stdcall
.stack 4096

.data
	minuend1 DWORD 4, 7, 1
	subtrahend1 DWORD 0, 8, 2
	difference1 DWORD LENGTHOF minuend1 DUP(?)

	minuend2 DWORD 7, 1
	subtrahend2 DWORD 0, 2
	difference2 DWORD LENGTHOF minuend2 DUP(?)

	minuend3 DWORD 8, 0, 3, 8, 6
	subtrahend3 DWORD 8, 0, 2, 8, 6
	difference3 DWORD LENGTHOF minuend3 DUP(?)

.code

p72 PROC
	; Create a procedure named Extended_Sub that subtracts two binary integers of arbitrary size. The storage size of the two integers must be the same and must be a multiple of 32 bits.
	; Write a test program that passes several pairs of integers, each at least 10 bytes long.

	mov esi, OFFSET minuend1
	mov edi, OFFSET subtrahend1
	mov ebx, OFFSET difference1
	mov ecx, LENGTHOF minuend1
	call Extended_Sub

	mov esi, OFFSET minuend2
	mov edi, OFFSET subtrahend2
	mov ebx, OFFSET difference2
	mov ecx, LENGTHOF minuend2
	call Extended_Sub

	mov esi, OFFSET minuend3
	mov edi, OFFSET subtrahend3
	mov ebx, OFFSET difference3
	mov ecx, LENGTHOF minuend3
	call Extended_Sub

	ret
p72 ENDP

Extended_Sub PROC
	; Args:	
	;	esi: base address of minuend
	;	edi: base address of subtrahend
	;	ebx: base address of result
	;	ecx: length of integers to subtract

	push eax
	push edx

	dec ecx							; If the number of bytes in the integers to subtract is n, then only n-1 sbb instructions is required, because each sbb will use neighboring pairs of bytes
loop_head:
	mov edx, [esi]
	mov eax, [esi + SIZEOF DWORD]

	sub eax, [edi + SIZEOF DWORD]
	sbb edx, [edi]

	mov [ebx], edx

	add esi, SIZEOF DWORD
	add edi, SIZEOF DWORD
	add ebx, SIZEOF DWORD
	loop loop_head

	mov [ebx], eax
	
	pop edx
	pop eax

	ret
Extended_Sub ENDP

end