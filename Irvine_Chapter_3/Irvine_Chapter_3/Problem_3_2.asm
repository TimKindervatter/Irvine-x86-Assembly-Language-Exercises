TITLE Problem 3-2

; Write a program that defines symbolic constants for all seven days of the week. Create an array variable that uses the symbols as initializers

Sunday = 1
Monday = 2
Tuesday = 3
Wednesday = 4
Thursday = 5
Friday = 6
Saturday = 7

.data
Week QWORD Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday

.code
p32 proc
	lea rax, [Week]
	ret
p32 endp

end