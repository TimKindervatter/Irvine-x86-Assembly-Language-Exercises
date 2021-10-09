.386
.model flat, stdcall
.stack 4096

.data
    var_A REAL4 1.0
    var_B REAL4 5.0
    var_C REAL4 2.0
    var_D REAL4 3.0
    var_E REAL4 4.0
.code

p124 PROC
    ; Write a program that evaluates the following arithmetic expression:
    ;   ((A + B)/C) * ((D - A) + E)
    ; Assign test values to the variables and display the resulting values.

    ; ((1 + 5)/2) * ((3 - 1) + 4) = (6/2) * (2 + 4) = 3 * 6 = 18 = 0x12

    fld var_A
    fadd var_B
    fdiv var_C

    fld var_D
    fsub var_A
    fadd var_E

    fmul
    
    ret
p124 ENDP

end