IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

.686
.model flat, stdcall
.stack 4096

.data
	array DWORD 1, 3, 2, 4, 5
.code

;-------------------------------------------------------
; BubbleSort
; Sort an array of 32-bit signed integers in ascending
; order, using the bubble sort algorithm.
; Receives: pointer to array, array size
; Returns: nothing
;-------------------------------------------------------
BubbleSort PROC
	pArray EQU [ebp + 8]
	Count EQU [ebp + 12]

	push ebp
	mov ebp, esp

	sub esp, 4
	exchanged? EQU [ebp - 4]

	pushad

	mov ecx, Count
	dec ecx								; decrement count by 1
outer_loop_head:
	mov exchanged?, DWORD PTR 0
	push ecx							; save outer loop count
	mov esi, pArray						; point to first value
inner_loop_head: 
	mov eax, [esi]						; get array value
	cmp [esi + 4], eax					; compare a pair of values
	jg skip_exchange					; if [ESI] <= [ESI + 4], no exchange
	xchg eax, [esi + 4]					; exchange the pair
	mov [esi], eax
	or exchanged?, DWORD PTR 1
	jmp exchange_performed
skip_exchange: 
	or exchanged?, DWORD PTR 0
exchange_performed:
	add esi, 4							; move both pointers forward
	loop inner_loop_head				; inner loop
	cmp exchanged?, DWORD PTR 0			; If no exchanges were performed this loop, terminate early
	pop ecx								; retrieve outer loop count
	je done
	loop outer_loop_head				; else repeat outer loop
done:
	popad

	mov esp, ebp
	pop ebp
	ret 8
BubbleSort ENDP

p98 PROC
	; Add a variable to the BubbleSort procedure in section 9.5.1 that is set to 1 whenever a pair of values is exchanged within the inner loop.
	; Use this variable to exit the sort before its normal completion if you discover that no exchanges took place during a complete pass through the array.

	push ebp
	mov ebp, esp

	push LENGTHOF array
	push OFFSET array
	call BubbleSort

	mov esp, ebp
	pop ebp
	ret
p98 ENDP

end