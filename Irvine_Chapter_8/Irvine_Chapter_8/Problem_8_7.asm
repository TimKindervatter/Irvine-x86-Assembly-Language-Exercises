.386
.model flat, stdcall
.stack 4096

WriteDec PROTO

gcd PROTO,
	a: DWORD,
	b: DWORD

.data
	
.code

p87 PROC
; Write a recursive implementation of Equclid's GCD algorithm.
; Write a test program that calls your GCD procedure five times using the following pairs of integers: (5, 20), (24, 18), (11, 7), (432, 226), (26, 13).
; After each call, display the GCD

	INVOKE gcd, 5, 20
	INVOKE gcd, 24, 18
	INVOKE gcd, 11, 7
	INVOKE gcd, 432, 226
	INVOKE gcd, 26, 13

	ret
p87 ENDP

gcd PROC USES ebx edx,
	a: DWORD,
	b: DWORD
;-----------------------------------------------------------------------------------------------------------------
; gcd(int a, int b)
; The recursive implementation of gcd is as follows:
;
;	int gcd(int a, int b)
;	{
;		if b = 0
;			return a
;		else
;			return gcd(b, a mod b)
;	}
;-----------------------------------------------------------------------------------------------------------------
	
	mov eax, a
	xor ebx, ebx
	cmp b, ebx
	je done

	xor edx, edx
	div b					; After this, Quotient is in EAX and Remainder is in EDX
	INVOKE gcd, b, edx
done:
	ret
gcd ENDP

end