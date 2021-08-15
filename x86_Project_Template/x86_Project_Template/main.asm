IFDEF RAX
	hello_world_64 PROTO
	hello_world EQU hello_world_64
ELSE
	.386
	.model flat, stdcall
	.stack 4096

	hello_world_32 PROTO
	hello_world EQU hello_world_32
ENDIF

.data

.code

main PROC
	call hello_world
	ret
main ENDP

end