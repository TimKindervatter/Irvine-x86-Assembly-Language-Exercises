IFDEF RAX
	aw_99 PROTO
	aw_910 PROTO
	aw_912 PROTO

	p99 PROTO
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
	aw_911 PROTO

	p91 PROTO
	p92 PROTO
	p93 PROTO
	p94 PROTO
	p95 PROTO
	p96 PROTO
	p97 PROTO
	p98 PROTO
	p910 PROTO
	p911 PROTO
	p912 PROTO
	p913 PROTO

	test_is_character_in_set PROTO
ENDIF

.data

.code

main PROC
	call p913
	ret
main ENDP

end