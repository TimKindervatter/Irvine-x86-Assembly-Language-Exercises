TITLE Chapter 5

ExitProcess PROTO

AW1 PROTO
AW2 PROTO
AW3 PROTO
AW4 PROTO
AW5 PROTO

p52 PROTO

.data

.code
main PROC
	; call AW2		; Would loop infinitely due to implementation, which intentionally manipulates the return address pushed onto the stack
	call p52

	call ExitProcess
main ENDP
end