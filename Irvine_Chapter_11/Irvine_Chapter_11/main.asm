IFDEF RAX
	hello_world_64 PROTO
	hello_world EQU hello_world_64
ELSE
	.386
	.model flat, stdcall
	.stack 4096

	aw_111 PROTO
	aw_112 PROTO
	aw_113 PROTO
	aw_114 PROTO
	aw_115 PROTO
	aw_116 PROTO
	aw_117 PROTO

	p111 PROTO
	p112 PROTO
	p113 PROTO
	p114 PROTO
	p115 PROTO
	p116 PROTO
	p117 PROTO
	p118 PROTO
ENDIF

.data

.code

main PROC
	call p118
	ret
main ENDP

end