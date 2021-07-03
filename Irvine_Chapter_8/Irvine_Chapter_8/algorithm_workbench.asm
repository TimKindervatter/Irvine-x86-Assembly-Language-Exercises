.386
.model flat, stdcall
.stack 4096

SetTextColor PROTO
WriteChar PROTO
WriteString PROTO
Crlf PROTO
DumpMem PROTO

DumpMemory PROTO,
	array_pointer:PTR DWORD,
	array_size:DWORD,
	array_type:DWORD

MultArray PROTO,
	array1_pointer:PTR DWORD,
	array2_pointer:PTR DWORD,
	num_elements:DWORD

.data
	Array DWORD 10 DUP(42h)
	wArray WORD 30h
	string BYTE "Colored String", 0

.code

aw_81 PROC
	; Here is a calling sequence for a procedure named AddThree that adds three doublewords (assume that the STDCALL calling convention is used):

	; push 10h
	; push 20h
	; push 30h
	; call AddThree

	; Draw the stack frame immediately after ebp has been pushed on the runtime stack

;--------------------------------------------------------------------------------------------------------
	; 10h
	; 20h
	; 30h
	; return address
	; ebp				<------------------- top of stack
;--------------------------------------------------------------------------------------------------------
aw_81 ENDP


aw_82 PROC
	; Create a procedure named AddThree that receives three integer parameters and calculates and returns their sum in the eax register

	push 30h					; arg3
	push 20h					; arg2
	push 10h					; arg1
	call AddThree

	push -30h					; arg3
	push -20h					; arg2
	push -10h					; arg1
	call AddThree	

	ret
aw_82 ENDP

AddThree PROC
;------------------------------------------------------------------------------------------------------
; AddThree(int arg1, int arg2, int arg3)
; Arguments are pushed onto the stack in the order arg3, arg2, arg1
; The sum arg1 + arg2 + arg3 is returned in the eax register
;------------------------------------------------------------------------------------------------------
	arg1 EQU [ebp + 8]
	arg2 EQU [ebp + 12]
	arg3 EQU [ebp + 16]

	push ebp
	mov ebp, esp

	xor eax, eax
	add eax, arg1			; arg1, offset is +8 because the return address for this function call is at +4
	add eax, arg2			; arg2
	add eax, arg3			; arg3
	
	pop ebp
	ret 12						; AddThree takes 3 parameters on the stack, so need to clean up 3*4 = 12 bytes upon return
AddThree ENDP


aw_83 PROC
	; Declare a local variable named pArray that is a pointer to an array of doublewords
	pArray EQU [ebp - 4]

	push ebp
	mov ebp, esp
	sub esp, 4					; In 32-bit app, pointer is 4 bytes so allocate 4 bytes of stack space for local variable
	
	lea esi, pArray
	mov [esi], OFFSET Array

	mov esp, ebp
	pop ebp
	ret
aw_83 ENDP


aw_84 PROC
	; Declare a local variable named buffer that is an array of 20 bytes
	buffer EQU [ebp - 1]
	BUFFER_SIZE = 20
	
	push ebp
	mov ebp, esp
	sub esp, BUFFER_SIZE		; Allocate 20 bytes of space for the local buffer

	lea esi, buffer
	mov ecx, BUFFER_SIZE
loop_head:
	mov [esi], cl
	sub esi, 1
	loop loop_head

	mov esp, ebp
	pop ebp
	ret
aw_84 ENDP


aw_85 PROC
	; Declare a local variable named pwArray that points to a 16-bit unsigned integer
	pwArray EQU [ebp - 4]

	push ebp
	mov ebp, esp
	sub esp, 4

	lea esi, pwArray
	mov [esi], OFFSET wArray

	mov esp, ebp
	pop ebp
	ret
aw_85 ENDP


aw_86 PROC
	; Declare a local variable myByte that holds an 8-bit signed integer
	myByte EQU [ebp - 1]

	push ebp
	mov ebp, esp
	sub esp, 4			; Even though myByte will only take up one byte, we allocate 4 bytes on the stack to make sure the stack remains aligned on a 4-byte boundary. Unaligned accesses can degrade runtime performance.

	lea esi, myByte
	mov BYTE PTR [esi], 42h

	mov esp, ebp
	pop ebp
	ret
aw_86 ENDP


aw_87 PROC
	; Declare a local variable myArray that is an array of 20 doublewords
	myArray EQU [ebp - 4]
	MYARRAY_LENGTH = 20
	MYARRAY_SIZE = SIZEOF DWORD * MYARRAY_LENGTH

	push ebp
	mov ebp, esp
	sub esp, MYARRAY_SIZE

	mov eax, 0FFFFFFFFh					; Save this constant to subtract from later
	mov ecx, MYARRAY_LENGTH
	lea esi, myArray
loop_head:
	mov ebx, eax
	sub ebx, ecx						; Subtract loop counter from 0xFFFFFFFF to get a unique value on every loop. Just want a value that fills 4 bytes for easy viewing in the memory window.
	mov DWORD PTR [esi], ebx			; Write the value in ebx to the currently-pointed-to array element on every iteration.
	sub esi, SIZEOF DWORD
	loop loop_head

	mov esp, ebp
	pop ebp
	ret
aw_87 ENDP


aw_88 PROC
	; Create a procedure named SetColor that receives two stack parameters: fore_color and back_color and calls the SetTextColor procedure from the Irvine32 library
	
	push 4				; Background color is red
	push 10				; Foreground color is green
	call SetColor

	mov edx, OFFSET string
	call WriteString
	call Crlf
	
	ret
aw_88 ENDP

SetColor PROC
;------------------------------------------------------------------------------------------------------
; SetColor(int fore_color, int back_color)
; Arguments are pushed onto the stack in the order back_color, fore_color
; Call SetTextColor from Irvine32 library with the passed arguments
;------------------------------------------------------------------------------------------------------

fore_color EQU [ebp + 8]
back_color EQU [ebp + 12]

	push ebp
	mov ebp, esp

	push eax
	push ebx

	mov eax, fore_color
	mov ebx, back_color
	shl ebx, 4					; Multiply background color by 16
	add eax, ebx				; Add the multiplied background color to the foreground color
	call SetTextColor			; As documented in the Irvine32 library manual, the foreground and background colors are passed in the eax register using eax = (4 * back_color) + fore_color

	pop ebx
	pop eax

	mov esp, ebp
	pop ebp

	ret 8						; Two arguments are passed on the stack, need to clean up 2*4 = 8 bytes
SetColor ENDP


aw_89 PROC
	; Create a procedure named WriteColorChar that receives three stack parameters: char, fore_color, and back_color

	push ebp
	mov ebp, esp


; Nested loop over all foreground and background colors
	mov ecx, 16
outer_loop_head:
	mov ebx, ecx			; Store outer loop counter
	dec ebx					; Colors are zero indexed, so subtract 1 from loop counter
	push ecx
	mov ecx, 16
inner_loop_head:
	mov eax, ecx			; Store inner loop counter
	dec eax					; Colors are zero indexed, so subtract 1 from loop counter

	push ebx				; Background color
	push eax				; Foreground color
	push "A"
	call WriteColorChar

	loop inner_loop_head
	pop ecx
	loop outer_loop_head

; Restore output colors to white foreground and black background
	push 0				; Background color
	push 15				; Foreground color
	call SetColor

	mov esp, ebp
	pop ebp
	ret
aw_89 ENDP

WriteColorChar PROC
;------------------------------------------------------------------------------------------------------
; SetColor(char character, int fore_color, int back_color)
; Arguments are pushed onto the stack in the order back_color, fore_color, character
; Call SetColor from above and WriteChar from Irvine32 library with the passed arguments
;------------------------------------------------------------------------------------------------------

character EQU [ebp + 8]
foreground_color EQU [ebp + 12]
background_color EQU [ebp + 16]

	push ebp
	mov ebp, esp

	push eax
	push esi

	push background_color
	push foreground_color
	call SetColor
	
	lea esi, character
	mov al, BYTE PTR [esi]
	call WriteChar

	pop esi
	pop eax

	mov esp, ebp
	pop ebp

	ret 12						; Three arguments are passed on the stack, so 3*4 = 12 bytes need to be cleaned up
WriteColorChar ENDP


aw_810 PROC
	; Write a procedure named DumpMemory that encapsulates the DumpMem procedure in the Irvine32 library. Use declared parameters and the USES directive.
	; The following is an example of how it should be called:
	;	INVOKE DumpMemory, OFFSET array, LENGTHOF array, TYPE array

	push ebp
	mov ebp, esp

	INVOKE DumpMemory, OFFSET Array, LENGTHOF Array, TYPE Array

	mov esp, ebp
	pop ebp
	ret
aw_810 ENDP

DumpMemory PROC USES esi ecx ebx,
	array_pointer:PTR DWORD,
	array_size:DWORD,
	array_type:DWORD

	mov esi, array_pointer
	mov ecx, array_size
	mov ebx, array_type
	call DumpMem

	ret

DumpMemory ENDP


aw_811 PROC
	; Declare a procedure named MultArray that receives two pointers to arrays of doublewords, and a third parameter indicating the number of array elements.
	; Also, create a PROTO declaration for this procedure.
aw_811 ENDP

MultArray PROC,
	array1_pointer:PTR DWORD,
	array2_pointer:PTR DWORD,
	num_elements:DWORD
MultArray ENDP

end