.386
.model flat, stdcall
.stack 4096

INCLUDE Irvine32.inc

to_lower MACRO string
    LOCAL non_lowercase_string
    LOCAL loop_head
    LOCAL continue

.data
    non_lowercase_string BYTE string, 0
.code
    push esi
    push ecx

    mov esi, OFFSET non_lowercase_string
    mov ecx, LENGTHOF non_lowercase_string
loop_head:
    cmp BYTE PTR [esi], "A"
    jb continue
    cmp BYTE PTR [esi], "Z"
    ja continue

    add BYTE PTR [esi], 32
continue:
    inc esi
    loop loop_head

    mov eax, OFFSET non_lowercase_string

    pop ecx
    pop esi
ENDM

mRound MACRO rounding_mode
    LOCAL round_even
    LOCAL round_down
    LOCAL round_up
    LOCAL round_zero
    LOCAL done

.code
    fstcw control_word
    
    to_lower rounding_mode

    INVOKE Str_compare, eax, ADDR re
    je round_even

    INVOKE Str_compare, eax, ADDR rd
    je round_down

    INVOKE Str_compare, eax, ADDR ru
    je round_up

    INVOKE Str_compare, eax, ADDR rz
    je round_zero

    jmp done

round_even:
    and control_word, 001111111111b
    jmp done
round_down:
    and control_word, 001111111111b
    or control_word, 010000000000b
    jmp done
round_up:
    and control_word, 001111111111b
    or control_word, 100000000000b
    jmp done
round_zero:
    or control_word, 110000000000b
done:
    fldcw control_word
ENDM

.data
    control_word WORD ?

    number REAL4 1.4375
    rounded_number DWORD ?

    re BYTE "re", 0
    rd BYTE "rd", 0
    ru BYTE "ru", 0
    rz BYTE "rz", 0
.code

p123 PROC
    ; Write a macro that sets the FPU rounding mode. The single input parameter is a two-letter code:
    ;   RE: Round to nearest even
    ;   RD: Round down toward negative infinity
    ;   RU: Round up toward positive infinity
    ;   RZ: Round toward zero (truncate)
    ; Case should not matter.

    ; Sample calls:
    ;   mRound Re
    ;   mRound rd
    ;   mRound RU
    ;   mRound rZ

    ; Write a short test program that uses the FIST (store integer) instruction to test each of the possible rounding modes.

    fld number

    mRound "Re"
    fist rounded_number

    mRound "rd"
    fist rounded_number

    mRound "RU"
    fist rounded_number

    mRound "rZ"
    fist rounded_number

    ret
p123 ENDP

end