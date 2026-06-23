; rdi - Contains integer value that should be converted to string.
; rsi - Contains pointer to byte buffer where string will be placed.
; rcx - Contains pointer to variable where count of elements in buffer will be saved.
convert_int_to_str:
	push rbx ; Function uses callee-save registers that should be saved.
	mov rax, rdi ; Put rdi input in rax register as dividend.
	mov rbx, 10 ; Source operand for divisor.
	mov r10, [rcx]

LoopHead1:
	xor rdx, rdx ; Zero out the rdx register, where remainder will be placed.

	div rbx

	add rdx, 0x30 ; Add value to remainder to make it the printable character equivalent in ASCII.
	inc r10

	xor r8, r8 ; Index
LoopHead2:
	mov r9, [rsi + r8] ; Copy original value of array with certain index.

	mov [rsi + r8], dl

	mov rdx, r9

	inc r8
	cmp r8, r10
	jl LoopHead2

	cmp rax, 0
	jne LoopHead1

	mov [rcx], r10

	pop rbx ; Pop original value at start of function back into rbx.
	ret

convert_str_to_int:
	ret