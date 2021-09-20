IFDEF RAX
	END_IF_X64 EQU end
ELSE
	END_IF_X64 EQU <>
ENDIF

END_IF_X64

.386
.model flat, stdcall
.stack 4096

INCLUDE Irvine32.inc

HEAP_START = 2000000
HEAP_MAX = 40000000

BUFFER_SIZE = 80

Node STRUCT
	buffer BYTE BUFFER_SIZE DUP(?)
	next_node DWORD NULL ; Pointer to a Node object
Node ENDS

.data
	heap_handle HANDLE ?
	input_handle HANDLE ?
	output_handle HANDLE ?

	starting_prompt BYTE "Input integers to append to the list. Enter the value 0 to finish.", 13, 10
	next_value_prompt BYTE "Enter the next value: "

	list_pointer DWORD NULL
	this_node_pointer DWORD NULL

	characters_read DWORD ?
.code

p1111 PROC
	; Implement a singly linked list, using the dynamic memory allocation functions presented in this chapter.
	; Each link should be a structure named Node containing an integer value and a pointer to the next link in the list.
	; Using a loop, prompt the user for as many integers as they want to enter.
	; As each integer is entered, allocate a Node object, insert the integer in the Node, and append the Node to the linked list.
	; When a value of 0 is entered, stop the loop.
	; Finally, display the loop from beginning to end.

	INVOKE GetProcessHeap
	cmp eax, NULL
	je quit

	mov heap_handle, eax

	INVOKE GetStdHandle, STD_INPUT_HANDLE
	mov input_handle, eax

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov output_handle, eax

	INVOKE WriteConsole, output_handle, ADDR starting_prompt, SIZEOF starting_prompt, 0, 0

loop_head:
	INVOKE WriteConsole, output_handle, ADDR next_value_prompt, SIZEOF next_value_prompt, 0, 0

	INVOKE HeapAlloc, heap_handle, HEAP_ZERO_MEMORY, SIZEOF Node
	cmp eax, NULL
	je quit

	cmp this_node_pointer, NULL
	jne assign_next_node
	
	mov list_pointer, eax
	jmp continue

assign_next_node:
	mov esi, this_node_pointer
	mov (Node PTR [esi]).next_node, eax

continue:
	mov this_node_pointer, eax
	INVOKE ReadConsole, input_handle, [this_node_pointer], BUFFER_SIZE, ADDR characters_read, 0

	; Compare buffer contents to "0" and quit if match
	xor ebx, ebx
	mov ecx, [this_node_pointer]
	mov bl, BYTE PTR [ecx]
	cmp bl, "0"
	jne loop_head

	mov esi, [list_pointer]
print_list_loop_head:
	mov edi, (Node PTR [esi]).next_node

	INVOKE WriteConsole, output_handle, esi, BUFFER_SIZE, 0, 0

	cmp edi, NULL
	je quit

	mov esi, edi
	jmp print_list_loop_head

quit:
	ret
p1111 ENDP

end