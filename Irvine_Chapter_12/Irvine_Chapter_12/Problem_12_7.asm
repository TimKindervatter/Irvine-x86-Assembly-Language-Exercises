.386
.model flat, stdcall
.stack 4096

INCLUDE Irvine32.inc

.data
    float1 REAL4 1.5
    float2 REAL4 2.0

    tag_word FPU_ENVIRON <>
    st0_register WORD ?

    is_valid BYTE " is valid", 0
    is_zero BYTE "is zero", 0
    is_special BYTE " is invalid, infinity, or denormal", 0
    is_empty BYTE " is empty", 0

    st0_string BYTE "ST(0) = R", 0
.code

p127 PROC
    ; The tag register (Section 12.2.1) indicates the type of contents in each FPU register, using 2 bits for each (Fig. 12-7).
    ; You can load the Tag word by calling the FSTENV instruction, which fills in the following protected-mode structure (defined in Irvine32.inc):
    ; FPU_ENVIRON STRUCT
    ;   controlWord WORD ?
    ;   ALIGN DWORD
    ;   statusWord WORD ?
    ;   ALIGN DWORD
    ;   tagWord WORD ?
    ;   ALIGN DWORD
    ;   instrPointerOffset DWORD ?
    ;   instrPointerSelector DWORD ?
    ;   operandPointerOffset DWORD ?
    ;   operandPointerSelector WORD ?
    ;   WORD ? ; not used
    ; FPU_ENVIRON ENDS

    ; Write a program that pushes two or more values onto the FPU stack, displays the stack by calling ShowFPUStack, 
    ; displays the Tag value of each FPU data register, and displays the register number that corresponds to ST(0).
    ; For the latter, call FSTSW instruction to save the status word in a 16-bit integer variable, and extract the TOP indicator from bits 11 through 13.

    ; FPU Tag Word:
    ;   15                                                                                      0
    ;   ----------------------------------------------------------------------------------------
    ;   |  Tag(7) |  Tag(6)  |  Tag(5)  |  Tag(4)  |  Tag(3)  |  Tag(2)  |  Tag(1)  |  Tag(0)  |
    ;   ----------------------------------------------------------------------------------------
    ; Tag Values:
    ;   00 = Valid
    ;   01 = Zero
    ;   10 = Special: invalid (NaN, unsupported), infinity, or denormal
    ;   11 = Empty

    ; The 16-bit tag word indicates the contents of the 8 registers in the FPU stack (2 bits per register).

    fld float1
    fld float2

    fstenv tag_word

    call ShowFPUStack

    mov bx, tag_word.tagWord
    mov ecx, 0    

loop_head:
    mov al, "R"
    call WriteChar

    mov eax, ecx
    call WriteDec

    mov dx, bx
    and dx, 3
    
    cmp dx, 0
    je valid
    cmp dx, 1
    je zero
    cmp dx, 2
    je special
    jmp empty

valid:
    mov edx, OFFSET is_valid
    jmp write_status
zero:
    mov edx, OFFSET is_zero
    jmp write_status
special:
    mov edx, OFFSET is_special
    jmp write_status
empty:
    mov edx, OFFSET is_empty

write_status:
    call WriteString
    call Crlf

    shr bx, 2
    inc ecx
    cmp ecx, 8
    jb loop_head

    mov edx, OFFSET st0_string
    call WriteString

    xor eax, eax
    fstsw ax
    and ax, 0011100000000000b
    shr ax, 11

    call WriteDec

    ret    
p127 ENDP

end