TITLE Chapter 6 Problems

.386
.model flat, stdcall
.stack 4096

INCLUDE C:\Assembly\Irvine\irvine\Irvine32.inc

p61_test PROTO
p62_test PROTO
p63 PROTO
p64_test PROTO
p65_66 PROTO
p67 PROTO
p68 PROTO
p69_test PROTO
p610_test PROTO

.data

.code
main PROC
	call p610_test
	ret
main ENDP
end