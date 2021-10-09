.386
.model flat, stdcall
.stack 4096

INCLUDE Irvine32.inc

.data
    prompt BYTE "Enter the radius of the circle: ", 0
.code

p125 PROC
    ; Write a program the prompts the user for the radius of a circle.
    ; Calculate and display the circle's area.
    ; Use the ReadFloat and WriteFloat procedures from the book's library.
    ; Use the FLDPI instruction to load pi onto the register stack.

    mov edx, OFFSET prompt
    call WriteString

    INVOKE ReadFloat

    fmul ST(0), ST(0)
    fldpi
    fmul
    
    INVOKE WriteFloat

    ret
p125 ENDP

end