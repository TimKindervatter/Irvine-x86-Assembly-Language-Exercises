.386
.model flat, stdcall
.stack 4096

INCLUDE Irvine32.inc

.data
    var_a REAL4 1.0
    var_b REAL4 5.0
    var_c REAL4 6.0

    two REAL4 2.0
    four REAL4 4.0

    sqrt_discriminant REAL4 ?

    root1 REAL4 ?
    root2 REAL4 ?

    a_prompt BYTE "Enter a: ", 0
    b_prompt BYTE "Enter b: ", 0
    c_prompt BYTE "Enter c: ", 0

    imaginary_prompt BYTE "Roots are imaginary", 0
.code

p126 PROC
    ; Prompt the user for coefficients a, b, and c of a polynomial in the form ax^2 + bx + c = 0.
    ; Calculate and display the real roots of the polynomial using the quadratic formula.
    ; If any root is imaginary, display an appropriate message.

    ; x = (-b +- sqrt(b^2 - 4ac))/2a

    ; Ex: x^2 + 5x + 6 -> x = -2, -3
    ; Ex: x^2 + 1 -> Imaginary roots

    mov edx, OFFSET a_prompt
    call WriteString

    call ReadFloat
    fst var_a

    mov edx, OFFSET b_prompt
    call WriteString

    call ReadFloat
    fst var_b

    mov edx, OFFSET c_prompt
    call WriteString

    call ReadFloat
    fst var_c

    ; b^2
    fld var_b
    fmul ST(0), ST(0)
    
    ; 4ac
    fld four
    fmul var_a
    fmul var_c

    ; b^2 - 4ac
    fsub

    ; 0 > b^2 - 4ac ?
    fldz
    fcom
    
    fnstsw ax
    sahf
    jg imaginary            ; If 0 > b^2 - 4ac, roots are imaginary
    

    fsqrt                   ; If 0 <= b^2 - 4ac, roots are real

    ; sqrt(b^2 - 4ac)
    fstp sqrt_discriminant

    ; (-b + sqrt(b^2 - 4ac))/2a
    fld var_b
    fchs
    fadd sqrt_discriminant

    fld two
    fmul var_a

    fdiv
    fst root1


     ; (-b - sqrt(b^2 - 4ac))/2a
    fld var_b
    fchs
    
    fsub sqrt_discriminant

    fld two
    fmul var_a

    fdiv
    fst root2

imaginary:
    mov edx, OFFSET imaginary_prompt
    call WriteString

    ret
p126 ENDP

end