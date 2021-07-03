TITLE Problem 3-4

; Write a program that defines symbolic names for several string literals. Use each symbolic name in a variable definition

hello TEXTEQU <"Hello World">
exitcode TEXTEQU <"The program exited with code 0">
asm TEXTEQU <hello, " from Assembly!">

.data
helloworld BYTE hello, "!"
labl BYTE exitcode
helloasm BYTE asm

.code
p34 proc
	lea rax, qword ptr [helloworld]
	ret
p34 endp

end