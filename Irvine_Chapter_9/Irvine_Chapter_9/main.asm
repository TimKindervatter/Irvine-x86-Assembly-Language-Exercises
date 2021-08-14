IFDEF RAX
	aw_99 PROTO
ELSE
	.386
	.model flat, stdcall
	.stack 4096

	aw_91 PROTO
	aw_92 PROTO
	aw_93 PROTO
	aw_94 PROTO
	aw_95 PROTO
	aw_96 PROTO
	aw_97 PROTO
	aw_98 PROTO
ENDIF

.data

.code

main PROC
	call aw_99
	ret
main ENDP

end