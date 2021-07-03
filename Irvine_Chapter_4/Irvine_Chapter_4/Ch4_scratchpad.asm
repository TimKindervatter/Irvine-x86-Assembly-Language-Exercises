.data
	start QWORD $					; Store the address of the start of the data segment for comparison later
	BYTE 100 DUP(10h)				; Pad some memory with junk data so we can test the offset of a big array
	testOffset BYTE 42h				; We will use this with the OFFSET directive later to see that the directive produces an address offset one QWORD + 100 BYTEs after start
	ALIGN 8							; The following data will be aligned on an 8 byte boundary
	array BYTE 1, 2, 3, 4, 5
	ALIGN 2							; The following data will be aligned on a 2 byte boundary
	aligned DWORD "TEST"
	ALIGN 8
	double DWORD 12345678h

	array2 BYTE 1, 2, 3, 4, 5, 6, 7, 8
	saveflags BYTE ?
	BYTE 7 DUP(0)									; Padding

	count WORD 1
	signedVal SWORD -16
	signedDword DWORD -16
	byteVal BYTE 10001111b

	oneByte BYTE 78h
	oneWord WORD 1234h
	oneDword DWORD 12345678h
	incVar BYTE 127 
	BYTE 0											; Padding

	X SWORD 26
	Y SWORD 30
	Z SWORD 40
	result SWORD ?

	dup_dword_array DWORD 20 DUP(42)
	dup_word_array WORD 20 DUP(42)
	dup_and_extra QWORD 10 DUP(24), 3, 5
	dup_dup BYTE 5 DUP(3 DUP(?))
	string BYTE "Hello, World!", 0, 13, 10

	no_continue BYTE 10, 20, 30, 40, 50
	BYTE 60, 70, 80, 90, 100
	continue BYTE 10, 20, 30, 40, 50,
	60, 70, 80, 90, 100

	var1 LABEL WORD									; var1 is now an alias for var2, but var1 has a different size attribute
	var2 DWORD 12345678h
	longval LABEL DWORD
	var3 WORD 0BEEFh
	var4 WORD 0DEADh

	qarray QWORD 1, 2, 3, 4, 5, 6, 7, 8

	ALIGN 8
	myBytes BYTE 10h, 20h, 30h, 40h
	myWords WORD 8Ah, 3Bh, 72h, 44h, 66h
	myDoubles DWORD 1, 2, 3, 4, 5
	myPointer DWORD myDoubles

	outer_loop_count QWORD ?

	ALIGN 8
	source_string BYTE "This is a source string", 0			; Initialize a null-terminated string to be copied
	ALIGN 8
	destination_string BYTE SIZEOF source_string DUP(0)		; Allocate space with the same number of bytes as source_string so that the string can be copied here

	ALIGN 8
	source_string2 BYTE "This is a source string", 0			; Initialize a null-terminated string to be copied
	ALIGN 8
	destination_string2 BYTE SIZEOF source_string2 DUP(0)		; Allocate space with the same number of bytes as source_string so that the string can be copied here
	
.code

ch4_scratchpad PROC
	mov rsi, OFFSET start			; Store the address of start, rather than the data that resides there (OFFSET works like the address-of operator (&)
	mov rdi, start					; Also store the address of start, because the data stored at start is $
	sub rdi, rsi					; Produces 0 because the addresses are the same

	mov rax, OFFSET testOffset		; Stores the address of testOffset, which is one QWORD (8 bytes) plus 100 bytes away from start (so 116 bytes total) 
	sub rax, rsi					; rax now contains 6Ch, which is 108 in hex
	mov rbx, SIZEOF start			; SIZEOF gets the number of bytes of its argument
	sub rax, rbx					; Produces 64h, which is 100 in hex because we've subtracted the size of start from 108. This makes sense because it's just the number of bytes in our array of junk data.

	xor rax, rax
	; mov rbx, array				; Not allowed because arguments have size mismatch (rbx is 8 bytes, array's first element is 1 byte)
	mov al, array					; Moves first element of array into cl, no size mismatch error
	mov rbx, QWORD PTR array		; rbx will not only contain the first element of array, but the whole 8 bytes starting at array's address. In our case, this includes all 5 bytes of array, but also the lowest two bytes ('ST') of aligned
	
	; Demonstration that data is stored in little-endian format
	xor rbx, rbx
	xor rcx, rcx
	mov bx, WORD PTR double			; Contains the lowest word of double, i.e. 5678h
	mov cx, WORD PTR double + 2		; contains the highest word of double, i.e. 1234h
	ret
ch4_scratchpad ENDP

ex1 proc
	xor rax, rax
	mov al, oneByte
	mov ax, oneWord
	mov eax, oneDword
	xor al, al
	ret
ex1 endp

ex2 proc
	mov rcx, 0
	mov cx, [count] ; Unsigned value 1 moved into cx is interpreted correctly because upper half of ecx is all 0s

	mov rax, 0
	mov eax, [signedDword] ; 16-bit signed value -16 moved into eax is not sign extended correctly

	mov rcx, 0
	mov cx, [signedVal] ; 16-bit signed value -16 moved into cx is not sign extended correctly

	mov rax, 0FFFFFFFFFFFFFFFFh
	movzx ax, [byteVal] ; Signed value 10001111b is zero - extended to 16 bits.Upper 48 bits are NOT zero extended nor zeroed out(x64 convention only applies to 32 bit register instructions)

	mov rbx, 0FFFFFFFFFFFFFFFFh
	movzx ebx, [signedVal] ; Signed value -16 is zero-extended to 32 bits, and upper 32 bits are zeroed out by x64 convention

	mov rcx, 0FFFFFFFFFFFFFFFFh
	movzx rcx, [signedVal] ; 16-bit signed value - 16 is zero-extended up to 64 bits.

	mov rax, 0
	movsx ax, [byteVal] ; 8-bit signed value 10001111b is sign - extended up to 16 bits.Upper 48 bits are not sign extended.

	mov rbx, 0FFFFFFFFFFFFFFFFh
	movsx ebx, [signedVal] ; 16-bit signed value -16 is sign-extended up to 32 bits. Upper 32 bits are zeroed out by x64 convention

	mov rcx, 0
	movsx rcx, [signedVal] ; 16-bit signed value -16 is sign-extended up to 64 bits.

	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx
	mov bx, 0A69Bh
	movzx eax, bx
	movzx edx, bl
	movzx cx, bl

	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx
	mov bx, 0A69Bh
	movsx eax, bx
	movsx edx, bl
	movsx cx, bl
	ret
ex2 endp

ex3 proc
	add rax, 0FFFFFFFFFFFFFFFFh ; Force a change in the flags register

	lahf ; Load lowest byte of status flags register (RFLAGS) into ah
	mov [saveflags], ah ; Store the low byte of status flags into memory

	xor rax, rax ; Force another change in the flags register
	mov ah, [saveflags] ; Load the previously-saved lowest flags byte from memory into ah
	sahf ; Store the loaded low flags byte into the flags register
	ret
ex3 endp

ex4 proc
	; Clear the registers we'll be using
	xor rax, rax
	xor rbx, rbx

	; Array starts as [1, 2, 3, 4, 5, 6, 7, 8]

	; Load the 0th and 3rd elements of array
	mov al, [array]
	mov bl, [array + 3]

	; Exchange them
	xchg rax, rbx

	; Write the swapped elements back to memory
	mov [array], al
	mov [array + 3], bl
	
	; Array ends as [4, 2, 3, 1, 5, 6, 7, 8]
	ret
ex4 endp

ex5 proc
	; This procedure accomplishes the same thing as ex4 but with fewer instructions

	; Clear the registers we'll be using
	xor rax, rax
	xor rbx, rbx

	; Array starts as [1, 2, 3, 4, 5, 6, 7, 8]

	mov al, array2			; Save the 0th element of the array in a register
	xchg al, [array2 + 3]	; Swap the saved 0th element with the 3rd element of the array
	mov array2, al			; Move the 3rd element, which is now stored in al, into the 0th index of array
	
	; Array ends as [4, 2, 3, 1, 5, 6, 7, 8]

	ret
ex5 endp

ex6 proc
	xor rax, rax
	mov al, [incVar]
	inc al
	dec [incVar]

	ret
ex6 endp

ex7 proc
	xor rax, rax

	; Compute result = -X + (Y - Z)
	mov ax, [X]
	neg ax
	mov bx, [Y]
	sub bx, [Z]
	add ax, bx
	mov [result], ax
	ret
ex7 endp

ex8 proc
	mov rax, 4
	sub rax, 5

	xor rax, rax
	mov ax, 8000h
	add ax, 1

	xor rax, rax
	mov ax, 7FFFh
	add ax, 1

	xor rax, rax
	mov ax, 7FF0h
	add al, 10h	; Result = 7F00h, CY = 1 (because al rolls over from FFh to 00h), PL = 0 (MSbit of al = 00h is 0), ZR = 1 (al contains 00h), OV = 0 (al went from -1 to 0)
	add ah, 1 ; Result = 8000h, CY = 0 (no carry because 7Fh becomes 80h, which fits in ah), PL = 1 (MSbit of ah = 80h is 1), ZR = 0 (80h != 00h), OV = 1 (7Fh = 127, 80h = -128, different sign)
	add ax, 2 ; Result = 8002h, CY = 0 (no carry out of ax), PL = 1 (MSbit of ax = 8002h is 1), ZR = 0 (8002h != 0000h), OF = 0 (8000h = -32768, 8002h = -32766, same sign)

	; Section 4.3.4
	xor rax, rax
	mov rax, TYPE start
	mov rax, TYPE oneByte
	mov rax, TYPE oneWord
	mov rax, TYPE oneDword

	xor rax, rax
	mov rax, LENGTHOF array				; array has 8 elements, so this returns 8
	mov rax, LENGTHOF dup_dword_array	; dup_byte_array has 20 elements, so this returns 14h (which is 20 dec)
	mov rax, LENGTHOF dup_word_array	; dup_word_array has 20 elements, so this returns 14h (which is 20 dec)
	mov rax, LENGTHOF dup_and_extra		; dup_and_extra is an array of 10 BYTEs followed by two extra BYTEs, for a total size of 12 (C in hex)
	mov rax, LENGTHOF dup_dup			; dup_dup is an 5-element array of 3-element arrays of BYTEs, for a total of 15 elements (F in hex)
	mov rax, LENGTHOF string			; string has 16 characters total (10h), including the null terminator, the new line, and the carriage return
	mov rax, LENGTHOF no_continue		; This is only 5 because the following line is marked with a new size attribute, so it's not considered a continuation of no_continue
	mov rax, LENGTHOF continue			; This is 10 because continue's line ends with a comma and the following line is not marked with a size attribute, so it's considered a continuation of continue

	xor rax, rax
	mov rax, SIZEOF array				; array has 8 elements of type BYTE so this returns 8
	mov rax, SIZEOF dup_dword_array		; dup_byte_array has 20 elements of type DWORD, so this returns 50h (which is 80 dec)
	mov rax, SIZEOF dup_word_array		; dup_word_array has 20 elements of type WORD, so this returns 28h (which is 40 dec)
	mov rax, SIZEOF dup_and_extra		; dup_and_extra is an array of 10 QWORDs followed by two extra QWORDs, for a total size of 8*10 + 8 + 8 = 96 (60h in hex)
	mov rax, SIZEOF dup_dup				; dup_dup is an 5-element array of 3-element arrays of BYTEs, for a total of 15 bytes (F in hex)
	mov rax, SIZEOF string				; string is comprised of WORDs, so there is 1 byte per character, or a total of 16 bytes (10h)

	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx
	mov ax, [var1]						; Contains 5678h, because var1 is of size WORD, so it only contains the low address of the data
	mov bx, [var1 + 2]					; Contains 1234h
	mov ecx, [var2]						; Contains 12345678h because var2 is of size DWORD and can hold both bytes of the data

	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx
	mov ax, [var3]						; Contains 0xBEEF
	mov bx, [var4]						; Contains 0xDEAD
	mov ecx, [longval]					; Contains 0xDEADBEEF because longval is of size DWORD and can hold both bytes of the data

	; The PTR directive produces an address
	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx
	lea rax, QWORD PTR [var3]			; Full 64-bit address
	lea ebx, QWORD PTR [var3]			; Only the lower 32 bits of the address are stored, this does not lead to the address of var3, it instead leads to junk in memory
	lea cx, QWORD PTR [var3]			; Only the lowest 16 bits of the address are stored, this does not lead to the address of var3, it instead leads to junk in memory
	
	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx
	mov al, array + 4					; Moves contents of array + 4 into rax
	mov al, [array + 4]					; Does the same thing as the previous line
	mov rbx, OFFSET [array + 4]			; Moves the address of array + 4 into rbx
	; mov [array + 4], 7				; Will not compile because assembler doesn't know what size the literal 7 should be when written to memory
	mov cl, 42h
	mov [array + 4], cl					; Moving froma register directly into memory works
	mov BYTE PTR [array + 4], 9			; Or you can specify the size of the literal by interpreting it as a BYTE PTR (i.e. only one byte should be written starting at address array + 4)

	; Iterate over array by getting pointer to first element and then incrementing pointer
	xor rax, rax
	xor rsi, rsi
	mov rsi, OFFSET array				; rsi = &array;
	mov al, [rsi]						; al = *rsi; // al = 1
	inc rsi								; rsi++
	mov al, [rsi]						; al = *rsi; // al = 2
	inc rsi								; rsi++
	mov al, [rsi]						; al = *rsi; // al = 3

	xor rax, rax
	xor rsi, rsi
	mov rsi, 3
	mov al, array[rsi - 1]				; Move 2nd element of array into al (requires Project Properties -> Linker -> System -> Enable Large Addresses to be set to /LARGEADDRESSAWARE:NO)
	mov al, [array + rsi - 1]			; Equivalent to above (requires Project Properties -> Linker -> System -> Enable Large Addresses to be set to /LARGEADDRESSAWARE:NO)

	xor rsi, rsi
	mov rsi, 3*TYPE qarray				; *TYPE qarray is required because qarray's elements are each 8 bytes long
	mov rax, qarray[rsi]				; Move 3rd element of array into rax (requires Project Properties -> Linker -> System -> Enable Large Addresses to be set to /LARGEADDRESSAWARE:NO)
	mov rax, [qarray + rsi]				; Equivalent to above (requires Project Properties -> Linker -> System -> Enable Large Addresses to be set to /LARGEADDRESSAWARE:NO)

	xor rsi, rsi
	xor rdi, rdi
	xor rax, rax
	xor rbx, rbx
	xor rdx, rdx
	mov rsi, OFFSET myBytes
	mov al, [rsi]						; AL = 10h (dereference address of myBytes, which is stored in esi)
	mov al, [rsi + 3]					; AL = 40h (dereference the address 3 bytes after myBytes)
	mov rsi, OFFSET myWords + 2
	mov ax, [rsi]						; AX = 003Bh (dereference the address two bytes, i.e. one WORD, after myWords)
	mov rdi, 8
	mov edx, [myDoubles + rdi]			; EDX = 00000003h (dereference the address 8 bytes, i.e. two DWORDs, after myDoubles)
	mov edx, myDoubles[rdi]				; EDX = 00000003h (alternate syntax, equivalent to previous line)
	mov ebx, myPointer					
	mov eax, [rbx + 4]					; EAX = 00000002h (dereference the address 4 bytes, i.e. one DWORD, after myPointer, which points to the base address of myDoubles)

	xor rsi, rsi
	xor rdi, rdi
	xor rax, rax
	xor rbx, rbx
	xor rdx, rdx
	mov rsi, OFFSET myBytes
	mov ax, [rsi]						; AX = 2010h (address of myBytes is dereferenced, but moved into ax which is 16-bit register, so the first two elements of myBytes are moved into ax, little-endian)
	mov eax, DWORD PTR myWords			; EAX = 003B008Ah (address of myWords is dereferenced as a DWORD PTR, which is 32 bits, so the first 4 bytes of myWords are moved into eax, little-endian)
	mov esi, myPointer
	xor rax, rax
	mov ax, [esi + 2]					; AX = 0000h (myPointer points to halfway through the first element of myDoubles so we get the upper half of myDoubles[0], which is 00000001h)
	mov ax, [esi + 6]					; AX = 0000h (same as above, but upper half of myDoubles[1], which is 000000002h)
	mov ax, [esi - 4]					; AX = 0044h (myWords is directly before myDoubles in memory, so backing up 4 bytes gives us the second-to-last element of myWords)

	; Loop that counts down from 3 to 0 before terminating
	xor rax, rax
	mov rax, 3
top:
	dec rax
	jnz top


; Double loop (5 outer loops of 3 inner loops for a total of 15 inner loops)
	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx
	mov rax, 0
	mov rcx, 5
L1:
	inc rax
	mov outer_loop_count, rcx			; Save number of outer loop iterations so it isn't overwritten by number of inner loop iterations
	mov rcx, 3							; Number of inner loops to be performed
L2:
	inc rbx
	loop L2								; The loop instruction implicitly uses rcx as the counter for the loop. rcx is decremented every time loop is called, and when rcx becomes zero, the loop terminates.

	mov rcx, outer_loop_count			; Restore the number of outer loop iterations
	loop L1								; Decrement the number of outer loop iterations and jup to L1
										; At this point, rax is 5 and rbx is Fh (15 dec)

; Sum all the elements in myBytes
	xor rax, rax
	xor rcx, rcx
	xor rsi, rsi
	mov rsi, OFFSET myBytes				; Move the base address of myBytes into rsi
	mov rcx, LENGTHOF myBytes			; Set the loop counter to the number of elements in myBytes (which is 4)
L3:
	add rax, [rsi]						; Dereference the address stored in rsi and store the contents of that address in al
	add rsi, TYPE myBytes				; Increment the address pointed to by rsi. TYPE myBytes is used to get the number of bytes per element programmatically, rather than hard-coding the value.
	loop L3
										; Here the count should be A0h because the sum of the elements of myBytes is 10h + 20h + 30h + 40h

; Copy a string
	xor rax, rax
	xor rcx, rcx
	xor rsi, rsi
	xor rdi, rdi
	mov rsi, OFFSET source_string		; Move the base address of source_string into rsi
	mov rdi, OFFSET destination_string	; Move the base address of destination_string into rdi
	mov rcx, LENGTHOF source_string		; Move the size of the source_string (in bytes) into the loop counter register
L4:
	mov al, [rsi]						; Can't do memory-to-memory move, so move the currently-pointed-to character of source string into a register
	mov [rdi], al						; Next, move the character from the register to the currently-pointed-to location in the destination string
	add rsi, TYPE source_string			; Point to the next character in the source string
	add rdi, TYPE destination_string	; Point to the next location in the destination string
	loop L4

; Alternate, more efficient way to copy a string
	xor rax, rax
	xor rcx, rcx
	xor rsi, rsi
	mov rsi, 0							; Move the starting index into rsi
	mov rcx, LENGTHOF source_string2	; Move the size of the source_string (in bytes) into the loop counter register
L5:
	mov al, source_string2[rsi]			; Can't do memory-to-memory move, first index the string using the index in rsi, and move the character at that index into a register
	mov destination_string2[rsi], al	; Next, move the character from the register to the same index in the destination_string
	inc rsi								; Increment the index
	loop L5

; Exercise 4.5-10
	mov eax,0
	mov ecx,10 ; outer loop counter
L6:
	mov eax,3
	mov rbx, rcx
	mov ecx,5 ; inner loop counter
L7:
	add eax,5
	loop L7 ; repeat inner loop
	mov rcx, rbx
	loop L6

	ret
ex8 endp

end
