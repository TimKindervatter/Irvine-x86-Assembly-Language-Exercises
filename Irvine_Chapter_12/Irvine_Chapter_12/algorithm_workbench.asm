.386
.model flat, stdcall
.stack 4096

.data
    aw_121_number DWORD 01000001011001100000000000000000b
    aw_122_number DWORD 00111111001000000000000000000000b
    aw_123_number DWORD 00111111000010000000000000000000b
    aw_124_number DWORD 01000001001011000000000000000000b
    aw_125_number DWORD 11000010100110000010000000000000b

    aw_129_B REAL8 7.8
    aw_129_M REAL8 3.6
    aw_129_N REAL8 7.1
    aw_129_P REAL8 ?

    aw_1210_B DWORD 7
    aw_1210_N REAL8 7.1
    aw_1210_P REAL8 ?
.code

aw_121 PROC
    ; Show the IEEE single-precision encoding of binary +1110.011b = +14.375dec

    ; Single precision float has 1 sign bit, 8 exponent bits, and 23 mantissa bits
    ; Sign = + = 0
    ; Exponent = 3, biased exponent = 127 + 3 = 130 = 1000 0010b
    ; Mantissa = 11001100000000000000000b

    ; Full representation = 0 10000010 11001100000000000000000

    fld aw_121_number

    ret
aw_121 ENDP


aw_122 PROC
    ; Convert the fraction 5/8 (0.625) to a binary real

    ; 0.101b = 1.01b x 2^(-1)

    ; Sign = + = 0
    ; Exponent = -1, biased exponent = 127 + (-1) = 126 = 01111110b
    ; Mantissa = 01000000000000000000000b

    fld aw_122_number

    ret
aw_122 ENDP


aw_123 PROC
    ; Convert the binary fraction 17/32 (0.53125) to a binary real

    ; 0.10001b = 1.0001b x 2^(-1)

    ; Sign = + = 0
    ; Exponent = -1, biased exponent = 127 + (-1) = 126 = 01111110b
    ; Mantissa = 00010000000000000000000b

    fld aw_123_number

    ret
aw_123 ENDP


aw_124 PROC
    ; Convert the decimal value +10.75 to IEEE single-precision real

    ; 10.75dec = 1010.11b = 1.01011 x 2^3

    ; Sign = + = 0
    ; Exponent = 3, biased exponent = 127 + 3 = 130 = 10000010b
    ; Mantissa = 01011000000000000000000b

    fld aw_124_number

    ret
aw_124 ENDP


aw_125 PROC
    ; Convert the decimal value -76.0625 to IEEE single-precision real

    ; -76.0625dec = -1001100.0001b = -1.0011000001b x 2^6

    ; Sign = - = 1
    ; Exponent = 5, biased exponent = 127 + 6 = 133 = 10000101b
    ; Mantissa = 00110000010000000000000b

    fld aw_125_number

    ret
aw_125 ENDP


aw_126 PROC
    ; Write a two-instruction sequence that moves the FPU status flags into the EFLAGS register

    fnstsw ax
    lahf
    
    ret
aw_126 ENDP


aw_127 PROC
    ; Given a precise result of 1.010101101, round it to an 8-bit significand using the FPU's default rounding method.

    ; Default rounding method = round to nearest even
    ; Significand = 010101101b = 9 bits
    ; Rounded significand = 010101110b
aw_127 ENDP


aw_128 PROC
    ; Given a precise result of -1.010101101, round it to an 8-bit significand using the FPU's default rounding method.

    ; Default rounding method = round to nearest even
    ; Significand = 010101101b = 9 bits
    ; Rounded significand = 010101110b
aw_128 ENDP


aw_129 PROC 
    ; Write instructions that implement the following C++ code:

    ; double B = 7.8;
    ; double M = 3.6; 
    ; double N = 7.1;
    ; double P = -M * (N + B)

    fld aw_129_B
    fld aw_129_N
    fadd

    fld aw_129_M
    fchs
    fmul

    fst aw_129_P

    ret
aw_129 ENDP


aw_1210 PROC
    ; Write instructions that implement the following C++ code:

    ; int B = 7;
    ; double N = 7.1
    ; double P = sqrt(N) + B;

    fld aw_1210_N
    fsqrt
    
    fild aw_1210_B
    fadd

    fst aw_1210_P

    ret
aw_1210 ENDP


aw_1211 PROC
    ; Provide opcodes for the following mov instructions (opcodes looked up from table 12-25, R/M bytes looked up from table 12-24):

    ; mov [di], bx              
    
    ; move word register into EA word, i.e. mov ew, rw
    ; Opcode for mov ew, rw = 89/r, where /r means R/M byte
    ; Mod R/M byte:
        ; Mod = 00
        ; Reg = 011 (bx)
        ; R/M = 101 (di)
        ; Total = 00 011 101 = 0001 1101 = 0x1D
    ; Opcode = 89 D1
    
aw_1211 ENDP

end