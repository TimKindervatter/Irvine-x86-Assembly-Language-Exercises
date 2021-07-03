.386
.model flat, stdcall
.stack 4096

INCLUDE C:\Assembly\Irvine\irvine\Irvine32.inc

ExitProcess PROTO

p51 PROTO
p53 PROTO
p54 PROTO
p55 PROTO
p56 PROTO
p57 PROTO
p58 PROTO
p59 PROTO
p510 PROTO
p511 PROTO

.data

.code
main PROC
	call p511
	call ExitProcess
main ENDP
end