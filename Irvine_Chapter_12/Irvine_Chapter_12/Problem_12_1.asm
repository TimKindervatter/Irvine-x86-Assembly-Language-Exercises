.386
.model flat, stdcall
.stack 4096

INCLUDE Irvine32.inc

.data
    X REAL8 ?
    Y REAL8 ?
    
    x_lower_string BYTE "X is lower", 13, 10, 0
    x_not_lower_string BYTE "X is not lower", 13, 10, 0
.code

compare_X_and_Y PROC
    push ebp
    mov ebp, esp

    fld [X]
    fcom [Y]

    fnstsw ax
    sahf
    jb X_lower
    
    mov edx, OFFSET x_not_lower_string
    call WriteString
    jmp done

X_lower:
    mov edx, OFFSET x_lower_string
    call WriteString    

done:
    mov esp, ebp
    pop ebp
  
    ret
compare_X_and_Y ENDP

p121 PROC
    ; Implement the following C++ code in assembly language. Substitute calls to WriteString for the printf() calls.

    ; double X;
    ; double Y;
    ; if (X < Y)
    ;   printf("X is lower\n");
    ; else
    ;   printf("X is not lower\n");

    ; Run the program several times, assigning a range of values to X and Y that test your program's logic

    fldz
    fst [X]

    fld1
    fst [Y]

    call compare_X_and_Y


    fldpi
    fst [X]

    fldlg2
    fst [Y]

    call compare_X_and_Y


    fld1
    fchs
    fst [X]

    fld1
    fst [Y]

    call compare_X_and_Y

    ret
p121 ENDP

end