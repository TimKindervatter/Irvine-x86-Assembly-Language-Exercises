.386
.model flat, stdcall
.stack 4096

Randomize PROTO
RandomRange PROTO
Crlf PROTO

aw_713 PROTO

p71 PROTO
p72 PROTO
p73 PROTO
p74 PROTO
p75 PROTO
p76 PROTO
p77 PROTO
p78 PROTO

.data

.code
main PROC
	call p78

	ret
main ENDP

test_aw_713 PROC
	call Randomize

	xor eax, eax
	mov ecx, 30
loop_head:
	mov eax, 100
	call RandomRange
	
	call aw_713
	call Crlf
	loop loop_head

	ret
test_aw_713 ENDP

end