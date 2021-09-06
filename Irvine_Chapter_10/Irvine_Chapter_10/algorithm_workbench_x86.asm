IFDEF RAX
	END_IF_X64 EQU END
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

INCLUDE	Irvine32.inc
INCLUDE Macros.inc

SampleStruct STRUCT
	field1 WORD ?
	field2 DWORD 20 DUP(?)
SampleStruct ENDS

Triangle STRUCT
	Vertex1 COORD <>
	Vertex2 COORD <>
	Vertex3 COORD <>
Triangle ENDS

mPrintChar MACRO character, num_repetitions
	LOCAL loop_head
	mov al, character
	mov ecx, num_repetitions
loop_head:
	call WriteChar
	loop loop_head
ENDM

mGenRandom MACRO n
	mov eax, n
	call RandomRange
ENDM

mPromptInteger MACRO prompt, integer
	LOCAL string
.data 
	string BYTE prompt

.code
	mov edx, OFFSET string
	call WriteString
	
	call ReadDec
	mov integer, eax
ENDM


mWriteAt MACRO text, x, y
	LOCAL string
.data
	string BYTE text

.code
	mGotoxy x, y
	mWriteString string
ENDM


mDumpMemx MACRO var
	mDumpMem OFFSET var, LENGTHOF var, TYPE var
ENDM


mDefaultInitializerExample MACRO parameter := <42h>
	mov eax, parameter
ENDM

mConditional MACRO number
	LOCAL GT_10
	LOCAL LE_10
.data
	GT_10 BYTE "More than 10", 0
	LE_10 BYTE "10 or less", 0

.code
	call Crlf

	IF number GT 10
		mWriteString GT_10
	ELSE
		mWriteString LE_10
	ENDIF
ENDM

isPositive MACRO Z
	LOCAL warning
.data
	warning BYTE "Z is invalid", 0

.code
	IF Z LT 0
		mWriteString warning
	ENDIF
ENDM


mDisplayRegisterContents MACRO regName
	LOCAL text
.data
	text BYTE "&regName = ", 0

.code
	mWriteString text
	mov eax, regName
	call WriteDec
ENDM

.data
	sample_struct1 SampleStruct <42h, 20 DUP(10h)>
	sys_time SYSTEMTIME <>

	triangle1 Triangle <{0, 0}, {5, 0}, {7, 6}>
	triangles Triangle 10 DUP(<>)

	random_array BYTE 100 DUP(?)

	minVal DWORD ?

	array DWORD 1000h, 2000h, 3000h, 4000h
.code

aw_101 PROC
	; Create a structure named SampleStruct containing two fields: field1, a single 16-bit WORD, and field2, an array of 20 32-bit DWORDs. The initial values of the fields may be left undefined.

	mov eax, OFFSET sample_struct1

	ret
aw_101 ENDP


aw_102 PROC
	; Write a statement that retrieves the wHour field of a SYSTEMTIME structure

	INVOKE GetLocalTime, ADDR sys_time

	movzx eax, sys_time.wMinute
	call WriteDec
	
	ret
aw_102 ENDP


aw_103 PROC
	; Using the Triangle structure, declare a structure variable and initialize its vertices to (0,0), (5,0), and (7,6)

	mov eax, OFFSET triangle1

	ret
aw_103 ENDP


aw_104 PROC
	; Declare an array of Triangle structures. Write a loop that initializes Vertex1 of each triangle to random coordinates in the range (0...10, 0...10)

	mov esi, OFFSET triangles
	mov ecx, LENGTHOF triangles

	; ebx will contain the offset to the second element of a coordinate
	mov ebx, TYPE COORD
	shr ebx, 1
loop_head:
	mov eax, 10
	call RandomRange

	mov (Triangle PTR [esi]).Vertex1.X, ax

	mov eax, 10
	call RandomRange
	mov (Triangle PTR [esi]).Vertex1.Y, ax

	add esi, TYPE Triangle
	loop loop_head

	ret
aw_104 ENDP


aw_105 PROC
	; Write a macro named mPrintChar that displays a single character on the screen. 
	; It should have two parameters: the first specifies the character to be displayed and the second specifies how many times the character should be repeated.

	mPrintChar 'X', 20
	
	ret
aw_105 ENDP


aw_106 PROC
	; Write a macro named mGenRandom that generates a random integer between 0 and n-1. 
	; Let n be the only parameter

	mov esi, OFFSET random_array
	mov ecx, LENGTHOF random_array

loop_head:
	mGenRandom 255
	mov BYTE PTR [esi], al
	add esi, TYPE random_array
	loop loop_head

	ret
aw_106 ENDP


aw_107 PROC
	; Write a macro named mPromptInteger that displays a prompt and inputs an integer from the user. Pass it a string literal and the name of a doubleword variable.

	mPromptInteger "Enter the minimum value: ", minVal

	ret
aw_107 ENDP


aw_108 PROC
	; Write a macro named mWriteAt that locates the cursor and writes a string literal to the console window.

	mWriteAt "Writing at 50, 50", 50, 50

	ret
aw_108 ENDP


aw_109 PROC
	; Show the expanded code produced by the following statement that invokes the mWriteString macro from Section 10.2.5:
	; mWriteStr namePrompt

	; push edx
	; mov edx, OFFSET namePrompt
	; call WriteString
	; pop edx
aw_109 ENDP


aw_1010 PROC
	; Show the expanded code produced by the following statement that invokes the mReadString macro from Section 10.2.5:
	; mReadStr customerName
	
	; push ecx
	; push edx
	; mov edx, OFFSET customerName
	; mov ecx, SIZEOF customerName
	; call ReadString
	; pop edx
	; pop ecx
aw_1010 ENDP


aw_1011 PROC
	; Write a macro named mDumpMemx that receives a single parameter, the name of a variable.
	; Your macro must call the mDumpMem macro from the book's library, passing it the variable's offset, number of units, and unit size.
	; Demonstrate a call to the mDumpMemx macro

	mDumpMemx array

	ret
aw_1011 ENDP


aw_1012 PROC
	; Show an example of a parameter having a default argument initializer.

	mDefaultInitializerExample

	ret
aw_1012 ENDP


aw_1013 PROC
	; Write a short example that uses the IF, ELSE, and ENDIF directives

	mConditional 4
	mConditional 25
	mConditional -5

	ret
aw_1013 ENDP


aw_1014 PROC
	; Write a statement using the IF directive that checks teh value of the constant macro parameter Z.
	; If Z is less than 0, display a message during assembly indicating that Z is invalid.

	isPositive 10
	isPositive 0
	isPositive -3

	ret
aw_1014 ENDP


aw_1015 PROC
	; Write a short macro that demonstrates the use of the & operator when the macro parameter is embedded in a literal string

	mov ebx, 10
	mDisplayRegisterContents ebx

	ret
aw_1015 ENDP


aw_1016 PROC
	; Assume the following mLocate macro definition:

	; mLocate MACRO xval,yval
	; 	IF xval LT 0		;; xval < 0?
	; 		EXITM			;; if so, exit
	; 	ENDIF

	; 	IF yval LT 0		;; yval < 0?
	; 		EXITM			;; if so, exit
	; 	ENDIF

	; 	mov bx, 0			;; video page 0
	;	mov ah, 2			;; locate cursor
	;	mov dh, yval
	;	mov dl, xval
	;	int 10h				;; call the BIOS
	; ENDM

	; Show the source code generated by the preprocessor when the macro is expanded by each of the following statements:

	; .data
	; row BYTE 15
	; col BYTE 60
	; .code
	; mLocate -2,20
	; mLocate 10,20
	; mLocate col,row


; ------------------------------------------------------
; mLocate -2,20
; ------------------------------------------------------

	; No code generated, since xval = -2, so macro exits in first conditional

; ------------------------------------------------------
; mLocate 10,20
; ------------------------------------------------------

	; 	mov bx, 0			;; video page 0
	;	mov ah, 2			;; locate cursor
	;	mov dh, 20
	;	mov dl, 10
	;	int 10h				;; call the BIOS

; ------------------------------------------------------
; mLocate col,row
; ------------------------------------------------------

	; 	mov bx, 0			;; video page 0
	;	mov ah, 2			;; locate cursor
	;	mov dh, row
	;	mov dl, col
	;	int 10h				;; call the BIOS

aw_1016 ENDP

end