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

; rdi- Contains pointer to string that will be converted to integer.
; rax - [Return] The converted integer value.
convert_str_to_int:
	push rbx ; Function uses callee-save registers that should be saved.
	push r12 ; Function uses callee-save registers that should be saved.
	push r13 ; Function uses callee-save registers that should be saved.

	; Empty out registers that will be used
	xor rax, rax
	xor rbx, rbx ; Register will keep str length
	xor rcx, rcx
	xor rdx, rdx
	xor r8, r8 ; Index for HeadLoop;
	xor r9, r9 ; Index for SubLoop;
	xor r10, r10
	xor r12, r12
	xor r13, r13

	mov r11, 10 ; Multiplier

	StrLenLoop:
	mov cl, [rdi + rbx] ; Copy character of string in register.
	inc rbx
	cmp cl, 0
	jnz StrLenLoop
	EndStrLenLoop:

	dec rbx ; Null terminator was counted as well so remove it.

	mov r12, rbx ; Set str length as exponent
	dec r12
	
	HeadLoop:
	mov cl, [rdi + r8]
	sub cl, 0x30 ; Subtract value to make it the number the ASCII character represents.

	mov rax, 1
	xor r9, r9 ; Index for SubLoop;

	cmp r12, 0
	cmovz rax, rcx

	cmp r12, 0
	jz SkipPowerOf

	SubLoop:
	mul r11
	inc r9
	cmp r9, r12
	jb SubLoop
	EndSubLoop:

	dec r12
	mul rcx
	SkipPowerOf:

	add r10, rax

	inc r8
	cmp r8, rbx
	jb HeadLoop
	EndHeadLoop:

	mov rax, r10

	pop r13
	pop r12
	pop rbx
	ret