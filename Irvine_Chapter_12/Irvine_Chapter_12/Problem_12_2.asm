.386
.model flat, stdcall
.stack 4096

INCLUDE Irvine32.inc

.data
    float1 REAL4 -1.75
    float2 REAL4 14.375
    float3 REAL4 0.625
    float4 REAL4 0.53125
    float5 REAL4 10.75
    float6 REAL4 -76.0625
    
    prefix BYTE "1.", 0
    exponent_string BYTE " E", 0

    sign_mask DWORD 10000000000000000000000000000000b
    exponent_mask DWORD 01111111100000000000000000000000b
    significand_mask DWORD 00000000011111111111111111111111b
.code

print_float PROC
    float EQU [ebp + 8]

    push ebp
    mov ebp, esp

    pushad

    mov eax, float
    shr eax, 31             ; Bit 31 is the sign bit, move it to the least-significant bit position for comparison

    cmp eax, 1              ; If the sign bit is 1, the number is negative. 
    je negative

    mov al, "+"             ; Otherwise, it's positive
    call WriteChar

    jmp write_prefix

negative:
    mov al, "-"
    call WriteChar

write_prefix:
    mov edx, OFFSET prefix
    call WriteString

    mov edx, float
    and edx, significand_mask   ; Bits 0-22 are the significand. Mask out bits 23-31 so we're just dealing with the relevant bits.
    shl edx, 9                  ; Shift the signficiand left 9 places so that the first bit of the significand is the most significant bit

    mov ecx, 23

; Loop over each bit one by one and print its value
loop_head:
    mov esi, edx
    and esi, 80000000h          ; Test whether the most significant bit (i.e. the bit currently being printed) is 0 or 1
    
    cmp esi, 0                  ; If the previous comparison resulted in 0, it means the most significant bit was 0
    je print_zero

    mov al, "1"                 ; Otherwise, the most significant bit was 1
    call WriteChar

    jmp continue

print_zero:
    mov al, "0"
    call WriteChar

continue:
    shl edx, 1                  ; Shift the significand left 1 so that the next bit of the significand moves into the MSB slot
    loop loop_head


    mov edx, OFFSET exponent_string
    call WriteString


    mov ebx, float
    and ebx, exponent_mask      ; Bits 23-30 are the biased exponent. Mask out all other bits so that we're just dealing with the exponent bits.
    shr ebx, 23                 ; Shift the exponent bits down so that they populate the least significant byte. This way we can treat it as just a regular integer.

    sub ebx, 127                ; The exponent is biased by 127, so subtract out the bias to get the actual exponent value.
    mov eax, ebx
    call WriteInt


    popad

    mov esp, ebp
    pop ebp

    ret 4
print_float ENDP

p122 PROC
    ; Write a procedure that receives a single-precision floating-point binary value and displays it in the following format:
    ; Sign: display + or -
    ; Significand: binary floating point, prefixed by 1
    ; Exponent: display in decimal, unbiased, preceded by the letter E and the exponent's sign.
    
    ; Sample:
    ; .data
    ; sample REAL4 -1.75
    
    ; Output: -1.11000000000000000000000 E+0

    push float1
    call print_float    ; Expected output: -1.11000000000000000000000 E+0
    call Crlf

    push float2
    call print_float    ; Expected output: +1.11001100000000000000000 E+3
    call Crlf

    push float3
    call print_float    ; Expected output: +1.01000000000000000000000 E-1
    call Crlf

    push float4
    call print_float    ; Expected output: +1.00010000000000000000000 E-1
    call Crlf

    push float5
    call print_float    ; Expected output: +1.01011000000000000000000 E+3
    call Crlf

    push float6
    call print_float    ; Expected output: -1.00110000010000000000000 E+6
    call Crlf

    ret
p122 ENDP

end