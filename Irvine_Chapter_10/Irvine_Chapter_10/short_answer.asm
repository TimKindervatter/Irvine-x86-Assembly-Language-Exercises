; 1. What is the purpose of the STRUCT directive
	; To define a named custom data type which contains fields of other types (either primitive or other structs)


; 2. Assume that the following structure has been defined:
; RentalInvoice STRUCT
;	invoiceNum BYTE 5 DUP(' ')
;	dailyPrice WORD ?
;	daysRented WORD ?
; RentalInvoice ENDS
; State whether or not each of the following declarations is valid:

; a. rentals RentalInvoice <>
; b. RentalInvoice rentals <>
; c. march RentalInvoice <'12345',10,0>
; d. RentalInvoice <,10,0>
; e. current RentalInvoice <,15,0,0>

; a. Valid
; b. Invalid, variable name must precede type name
; c. Valid
; d. Valid, first field remains default-initialized
; e. Invalid, too many values in initializer list


; 3. True/False: A macro cannot contain data definitions
;	False


; 4. What is the purpose of the LOCAL directive
;	Macros are expanded inline at assembly-time, similar to a dumb text replacement.
;	Normally, this means that variable names and labels would just be duplicated in each place the macro is called.
;	The LOCAL directive indicates that a unique name/label should be generated for each invocation of the macro, to avoid duplicates.


; 5. Which directive displays a message on the console during the assembly step?
;	ECHO


; 6. Which directive marks the end of a conditional block of statements?
;	ENDIF


; 7. List all the relational operators that can be used in constant boolean expressions.
;	GT, GE, EQ, NE, LE, LT


; 8. What is the purpose of the & operator in a macro definition
;	(AKA Substitution Operator) It replaces the name of a variable with its value.


; 9. What is the purpose of the ! operator in a macro definition?
;	 (AKA Literal-Character Operator) It escapes the following character (similar to \ in most languages)


; 10. What is the purpose of the % operator in a macro definition?
;	(AKA Expansion Operator) It evaluates the following constant expression/text macro and replaces the expression with the result.


end