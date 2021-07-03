TITLE Problem 5-9

.386
.model flat, stdcall
.stack 4096

WriteInt PROTO

.data

.code

p59 PROC
; Write a program that calls a recursive procedure. Inside this procedure, add 1 to a counter so you can verify the number of times it executes.
; Put a number in ECX that specifies the number of times you want to allow the recursion to continue.
; Using only the LOOP instruction and no other conditional statements from later chapters, find a way for the recursive procedure to call itself a fixed number of times.

	mov ecx, 3			; Loop counter
	mov eax, 0			; Recursion counter
	
	call recurse
	call WriteInt		; eax will contain the number of times that recurse was called, and that number will be printed
	
	ret
p59 ENDP

recurse PROC
	inc eax
	loop L1
	ret
L1:
	call recurse
	ret					; Needed because the call to recurse on the prior line pushes this line's address onto the stack to be returned to later
recurse ENDP

end