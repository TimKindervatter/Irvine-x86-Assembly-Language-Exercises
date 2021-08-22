IFDEF RAX
	END_IF_NOT_X64 EQU <>
ELSEIF
	END_IF_NOT_X64 EQU end
ENDIF

END_IF_NOT_X64

.data
	array QWORD 10h, 20h, 30h, 40h, 50h, 60h, 70h, 80h, 90h
.code

;--------------------------------------------------------------
; BinarySearch
; Searches an array of signed integers for a single value.
; Receives: 
;	Pointer to array, array size, search value.
; Returns: 
;	If a match is found, RAX = the array position of the
;	matching element; otherwise, RAX = -1.
;--------------------------------------------------------------
binary_search PROC
	pArray EQU rcx					; pointer to array
	Count EQU rdx					; array size
	searchVal EQU r8				; search value

	first EQU r10
	mid EQU r11
	last equ r12

	mov first, 0				; first = 0
	mov rax, Count				; last = (count - 1)
	dec rax
	mov last, rax
	mov rdi, searchVal			; rdi = searchVal
	mov rbx, pArray				; rbx points to the array

	; while first <= last
loop_head:								
	mov rax, first
	cmp rax, last
	jg search_failed			; exit search

	; mid = (last + first) / 2
	mov rax, last
	add rax, first
	shr rax, 1
	mov mid, rax

	; r13 = values[mid]
	mov rsi, mid
	shl rsi, 3					; scale mid value by 8
	mov r13, [rbx + rsi]		; r13 = values[mid]

	; if ( r13 < searchval(rdi) )
	cmp r13, rdi
	jge value_in_lower_half
	; first = mid + 1
	mov rax, mid
	inc rax
	mov first, rax
	jmp value_in_upper_half

	; else if( r13 > searchVal(rdi) )
value_in_lower_half: 
	cmp r13, rdi				; optional
	jle value_is_mid
	; last = mid - 1
	mov rax, mid
	dec rax
	mov last, rax
	jmp continue

	; else return mid
value_is_mid: 
	mov rax, mid				; value found
	jmp done					; return (mid)
value_in_upper_half:
continue:
	jmp loop_head				; continue the loop
search_failed: 
	mov rax, -1					; search failed
done: 
	ret
binary_search ENDP

p99 PROC
	; Rewrite the binary search procedure shown in this chapter by using registers for mid, first, and last.
	; Add comments to clarify the registers' usage.

	mov rcx, OFFSET array
	mov rdx, LENGTHOF array
	mov r8, 30h
	call binary_search

	mov rcx, OFFSET array
	mov rdx, LENGTHOF array
	mov r8, 70h
	call binary_search

	mov rcx, OFFSET array
	mov rdx, LENGTHOF array
	mov r8, 100h
	call binary_search

	ret
p99 ENDP

end