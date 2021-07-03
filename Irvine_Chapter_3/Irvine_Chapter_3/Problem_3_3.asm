TITLE Problem 3-3

; Write a program that contains a definition of each data type listed in Table 3-2 of section 3.4. Initialize each variable to a value that is consistent with its data type.

.data
var1 BYTE 255
BYTE 7 DUP(0)
var2 sbyte -128
BYTE 7 DUP(0)
var3 word 65535
BYTE 6 DUP(0)
var4 sword -32768
BYTE 6 DUP(0)
var5 dword 07ffffffh
BYTE 4 DUP(0)
var6 sdword 80000000h
BYTE 4 DUP(0)
var7 fword 7fffffffffffh
BYTE 2 DUP(0)
var8 qword 7fffffffffffffffh
var9 sqword 8000000000000000h
var10 TBYTE 193287450918237098
var11 REAL4 6.26e-34
var12 REAL8 10.0e+80
var13 REAL10 10.0e+4000

.code
p33 proc
	lea rax, [var1]
	ret
p33 endp

end