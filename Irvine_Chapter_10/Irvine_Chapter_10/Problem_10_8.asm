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

DisplayLocation PROTO,
	x: BYTE, 
	y: BYTE

.data
	aWalk DrunkardWalk <>

	x_axis_is_forward BYTE 0
.code



;-------------------------------------------------------
TakeDrunkenWalkWithNonUniformProbability PROC
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

	mov eax, 100						; Roll a percentage
	call RandomRange

	.IF eax < 50						; Forward
		.IF x_axis_is_forward == 1
			inc currX
		.ELSE
			inc currY
		.ENDIF
	.ELSEIF eax >= 50 && eax < 70		; Left
		.IF x_axis_is_forward == 1
			inc currY
		.ELSE
			dec currX
		.ENDIF
	.ELSEIF eax >= 70 && eax < 90		; Right
		.IF x_axis_is_forward == 1
			dec currY
		.ELSE
			inc currX
		.ENDIF
	.ELSE								; Backward
		.IF x_axis_is_forward == 1
			dec currX
		.ELSE
			dec currY
		.ENDIF
	.ENDIF

	add edi, TYPE COORD			; point to next COORD
	dec ecx
	jnz Again

Finish:
	mov (DrunkardWalk PTR [esi]).pathsUsed, WalkMax
	popad
	ret
TakeDrunkenWalkWithNonUniformProbability ENDP

p108 PROC
	; When testing the DrunkardWalk program, you may have noticed that the professor doesn't seem to wander very far from the starting point.
	; This is no doubt caused by an equal probability of the professor moving in any direction.
	; Modify the program so there is a 50% probability that the professor will continue to walk in the same direction as on the previous step.
	; There should be a 10% probability that they will reverse direction, and a 20% probability that they will turn either left or right.
	; Assign a default starting direction before the loop begins.

	call Randomize

	mov eax, 2
	call RandomRange
	mov x_axis_is_forward, al

	mov esi, OFFSET aWalk
	call TakeDrunkenWalkWithNonUniformProbability

	ret
p108 ENDP

end