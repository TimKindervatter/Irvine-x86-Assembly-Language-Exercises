IFDEF RAX
	
ELSE
	.386
	.model flat, stdcall
	.stack 4096

	aw_101 PROTO
	aw_102 PROTO
	aw_103 PROTO
	aw_104 PROTO
	aw_105 PROTO
	aw_106 PROTO
	aw_107 PROTO
	aw_108 PROTO
	aw_1011 PROTO
	aw_1012 PROTO
	aw_1013 PROTO
	aw_1014 PROTO
	aw_1015 PROTO
ENDIF

.data

.code

main PROC
	call aw_1015
	ret
main ENDP

end