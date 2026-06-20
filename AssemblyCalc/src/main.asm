; NASM (Intel) syntax used -> (destination, source)
bits 64

section .data
msg:    db      "Correct input is given!", 10
.len:   equ     $ - msg

; TODO: Make variables underneath local to _start.
char_arr:	db 	16 dup (0)
char_arr_count:	dq 	0

section .text
        global _start

_start:
	; pop	rax	; Get argc from stack
	; cmp	rax, 3	; If argc != 3 go to exit
	; jne	.exit

	; pop     rbx ; Get arg1 from stack. In our casse this is ./build/main

	; TODO: Implement arg handling.
        ; pop     rbx ; Get arg2 from stack.
	; pop	rcx ; Get arg3 from stack.

	mov rbx, 719
	add rbx, 200

	mov rdi, rbx
	mov rsi, char_arr
	mov rcx, char_arr_count
	call convert_str_to_int

	; TODO: Add newline to char_arr.

.print:
        mov rax, 1 ; write
        mov rdi, 1 ; stdout
        mov rsi, char_arr
        mov rdx, [char_arr_count]
        syscall

.exit:
        mov rax, 60 ; exit
        mov rdi, 0
        syscall

; rdi - Contains integer value that should be converted to string.
; rsi - Contains pointer to byte buffer where string will be placed.
; rcx - Contains pointer to variable where count of elements in buffer will be saved.
convert_str_to_int:
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