IFDEF RAX
	END_IF_X64 EQU END
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

INCLUDE Irvine32.inc
INCLUDE Macros.inc

.386
.model flat, stdcall
.stack 4096

.data

.code

WalkMax = 50
StartX = 25
StartY = 25

DrunkardWalk STRUCT
	path COORD WalkMax DUP(<0,0>)
	pathsUsed WORD 0
DrunkardWalk ENDS

.data
	aWalk DrunkardWalk <>

.code

DisplayLocation PROC,
	x: BYTE, 
	y: BYTE

	pushad

	mGotoxy x, y

	mov al, "*"	
	call WriteChar

	popad
	ret
DisplayLocation ENDP

;-------------------------------------------------------
TakeDrunkenWalkAndDropPhone PROC
LOCAL currX: BYTE, currY: BYTE
;
; Takes a walk in random directions (north, south, east,
; west).
; Receives: ESI points to a DrunkardWalk structure
; Returns: the structure is initialized with random values
;-------------------------------------------------------
	pushad

	; Use the OFFSET operator to obtain the address of the
	; path, the array of COORD objects, and copy it to EDI.
	mov edi, esi
	add edi, OFFSET DrunkardWalk.path
	mov ecx, WalkMax						; loop counter
	mov currX, StartX						; current X-location
	mov currY, StartY						; current Y-location

	; Choose a random step along the random walk as the one where the professor drops his phone
	mov eax, WalkMax
	call RandomRange
	mov ebx, eax

	mov eax, gray
	call SetTextColor

	xor eax, eax
Again:
	.IF ecx == ebx
		mov eax, red
		call SetTextColor

		INVOKE DisplayLocation, currX, currY

		mov eax, gray
		call SetTextColor
	.ELSE
		INVOKE DisplayLocation, currX, currY
	.ENDIF


	push ecx
	INVOKE Sleep, 100
	pop ecx
	
	; Insert current location in array.
	mov al, currX
	mov (COORD PTR [edi]).X, ax
	mov al, currY
	mov (COORD PTR [edi]).Y, ax

	mov eax, 4					; choose a direction (0-3)
	call RandomRange

	.IF eax == 0				; North
		dec currY
	.ELSEIF eax == 1			; South
		inc currY
	.ELSEIF eax == 2			; West
		dec currX
	.ELSE						; East (EAX = 3)
		inc currX
	.ENDIF

	add edi, TYPE COORD			; point to next COORD
	loop Again

Finish:
	mov (DrunkardWalk PTR [esi]).pathsUsed, WalkMax
	popad
	ret
TakeDrunkenWalkAndDropPhone ENDP


p107 PROC
	; When the professor took the drunkard's walk around campus in Section 10.1.6, we discovered that he lost his cell phone somewhere along the path.
	; When you simulate the drunken walk, your program must drop the phone wherever the professor is standing at some random time interval.
	; Each time you run the program, the cell phone will be lost at a different time interval (and location).

	mov esi, OFFSET aWalk
	call TakeDrunkenWalkAndDropPhone

	ret
p107 ENDP

end