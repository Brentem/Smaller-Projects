; NASM (Intel) syntax used -> (destination, source)
bits 64

%include "src/conversion.asm"

section .data
msg:    db      "Correct input is given!", 10
.len:   equ     $ - msg

test_msg1: db "12345", 0
test_msg2: db "123456789", 0
test_msg3: db "987654321", 0

; TODO: Make variables underneath local to _start.
char_arr:	db 	16 dup (0)
char_arr_count:	dq 	0
operand1:	dq	0
operand2:	dq	0
result:		dq	0

section .text
        global _start

_start:
	pop rax	; Get argc from stack
	cmp rax, 3	; If argc != 3 go to exit
	jne .exit

	pop rbx ; Get arg1 from stack. In our casse this is ./build/main

	; TODO: Implement arg handling.
	pop rbx; Get arg2 from stack.
	pop rcx; Get arg3 from stack.

	mov [operand1], rbx
	mov [operand2], rcx

	mov rdi, [operand1]
	call convert_str_to_int
	mov [result], rax

	mov rdi, [operand2]
	call convert_str_to_int

	mov rbx, [result]
	add rbx, rax
	mov [result], rbx

	mov rdi, [result]
	mov rsi, char_arr
	mov rcx, char_arr_count
	call convert_int_to_str

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
