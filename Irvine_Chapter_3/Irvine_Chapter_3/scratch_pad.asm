TITLE Irvine Chapter 3 Scratch Pad

COUNT = 500										; Define a symbol, all instances of COUNT will be replaced by 500 (until COUNT is reassigned)
PI EQU <3.1415926>								; Another way to define a symbol
SQUARE EQU 3 * 3								; EQU syntax can also be expanded to an integer expression
SQUARE2 EQU <3 * 3>								; This is subtly different, since SQUARE will be evaluated to 9 before being substituted while SQUARE2 will be substituted as 3 * 3, i.e. not evaluated before substitution
TEXT EQU <"Press any key to continue...", 0>	; EQU can also expand to text
; SQUARE EQU 7									; The main difference between EQU and = for defining syntax is that EQU does not allow symbol redifinition.The assembler will fail to assemble this line.

; TEXTEQU can be used to define text macros, which expand to the text the symbol represents
rowSize = 5
i TEXTEQU % (rowSize * 2)						; Text macros prefixed by% can represent constant integer expressions
move TEXTEQU <mov>								; Text macros can also expand to any text...
setupAL TEXTEQU <mov al, i>						; ... or combinations of text and other text macros
i TEXTEQU % (i + 1)								; Unlike regular symbols, text macros can be reassigned
; count TEXTEQU i								; However, text macros cannot be used to redefine non - text - macros symbols, so this line would not assemble

.data
start QWORD $									; The $ directive produces the current location, so this stores the address of start
BYTE 0											; It's possible to declare a region of memory with no identifier specified for it. In this case, one byte of zeros will immediately follow the data stored at the address represented by start.
X QWORD 16, 32, 48, 64, 80						; Array of 64 - bit values
QWORD 4 DUP("STACK")							; Duplicate "STACK" 4 times, padding to 64 bits
Y TBYTE 1.5										; Initialize 10 bytes with an extended floating point value of 1.5
BYTE 6 DUP('A')
R REAL8 PI										; Create a double precision floating point number initialized to PI
A QWORD 12345678h								; Can initialize values using hex literals also
val1 QWORD 10000h
val2 QWORD 40000h
val3 QWORD 30000h
final QWORD ?									; Declare space for a 64 bit value, but don't initialize it
S SDWORD 80000000h								; Initialize a signed 32 - bit value with the smallest value it can possibly hold
signedq SQWORD 8000000000000000h				; Initialize a signed 64 - bit value with the smallest value it can possibly hold
Color BYTE 'BLUE', 0h							; Initialize a null - terminated character array with the string 'BLUE'
sArray BYTE COUNT DUP('TEST')					; COUNT stands in for 500 here, so we duplicate 'TEST' 500 times
bArray BYTE 20h DUP('A')						; DUP can also use hex values
string BYTE "I'd rather not have"				; string refers to the base address of a long character array
BYTE "to count how many"						; string continues from here...
BYTE "characters are in"
BYTE "this long string"							; ... to here
ssize QWORD($ - string)							; $ gets the current address, and string is the base address, so($ - string) computes the length of the character array.Must be QWORD because x64 addresses are 64 - bit!
array WORD 100h, 200h, 300h, 400h				; An array of 16 - bit(2 - byte) values
arraysize QWORD($ - array) / 2					; Need to divide by 2 because($ - array) will be in bytes, so if we want length of array, we need to divide by number of bytes per element
darray DWORD 1000h, 2000h, 3000h				; Array of 32 - bit(4 - byte) values
darraysize QWORD($ - darray) / 4				; Similar to arraysize, but now we divide by 4 because darray has 4 - byte values

COUNT = 10h										; Reassign the COUNT symbol, now all further instances of COUNT will be replaced by 10h instead of 500 (note that MASM is not case sensitive, so count is equivalent to COUNT defined above)

.code
scratch proc
	mov rdx, COUNT								; 10h will be stored in rdx
	mov rdx, SQUARE
	mov rcx, ssize								; View the length of string in rcx
	mov rcx, arraysize							; View the length of array in rcx(should be 4)
	mov rcx, darraysize							; View te length of darray in rcx(should be 3)
	mov rax, 0
	lea rbx, BYTE PTR start						; Store the address of the start of the data segment in rbx.Type 'rbx' into the memory textbox to view the data segment.

	; Adding and subtracting a few of the values stored in the data segment
	mov rax, val1
	add rax, val2
	sub rax, val3
	mov final, rax								; Store the result of our computation back in memory at the address final(which was originally uninitialized)
	xor ecx, ecx								; Zero out the ecx register
	mov ecx, S
	call f										; Jump to the instruction labeled by 'f' and push the address of the next instruction onto the stack for later retrieval
	ret											; Return the value in rax(still 0xDEADBEEF from the call to f).This will cause main to exit with code 0xDEADBEEF.
scratch endp

f proc
	push rbp										; Push the base pointer(which currently holds the base address of main's stack frame) onto the stack for later retrieval
	mov rbp, rsp								; Set the current stack pointer as the base pointer of f's stack frame
	mov rax, 0DEADBEEFh							; Move the hex value 0xDEADBEEF into rax
	pop rbp										; Pop the base address of main's stack frame back into the base pointer register
	ret											; Returns the value in rax(currently 0xDEADBEEF) and pop the address of the instruction following 'call f' into the instruction pointer register
f endp
end