; NASM (Intel) syntax used -> (destination, source)
bits 64

%include "src/conversion.asm"
%include "src/str_cmp.asm"

section .data
add_msg:	db	"ADD", 0
sub_msg:	db	"SUB", 0
mul_msg:	db	"MUL", 0
div_msg:	db	"DIV", 0

char_arr:	db	16 dup (0)
char_arr_count:	dq	0
operator_str:	dq	0		; NOTE: This is a pointer to a string.
operand1_str:	dq	0		; NOTE: This is a pointer to a string.
operand2_str:	dq	0		; NOTE: This is a pointer to a string.
result:		dq	0
operand1:	dq	0
operand2:	dq	0

section .text
        global _start

_start:
	pop rax ; Get argc from stack
	cmp rax, 4 ; If argc != 4 go to exit
	jne .exit

	pop rbx ; Get arg1 from stack. In our casse this is ./build/main
	pop rbx ; Get arg2 from stack. ADD, SUB, MUL, DIV
	pop rcx ; Get arg3 from stack.
	pop rdx ; Get arg4 from stack.

	mov [rel operator_str], rbx
	mov [rel operand1_str], rcx
	mov [rel operand2_str], rdx

	mov rdi, [rel operand1_str]
	call convert_str_to_int
	mov [rel operand1], rax

	mov rdi, [rel operand2_str]
	call convert_str_to_int
	mov [rel operand2], rax

.check_add_operator:
	; NOTE: The label operator_str references a memory location. In that memory location, the address of the string is stored.
	; NOTE: Which is why it needs to be dereferenced first to get the address of the string.
	mov rsi, [rel operator_str]

	; NOTE: The label add_msg references a memory location where a string is stored.
	; NOTE: Which is why it doesn't need to be dereferenced first.
	mov rdi, add_msg
	call str_cmp_equal
	cmp rax, 1
	je .do_add_operation

.check_sub_operator:
	; NOTE: The label operator_str references a memory location. In that memory location, the address of the string is stored.
	; NOTE: Which is why it needs to be dereferenced first to get the address of the string.
	mov rsi, [rel operator_str]

	; NOTE: The label sub_msg references a memory location where a string is stored.
	; NOTE: Which is why it doesn't need to be dereferenced first.
	mov rdi, sub_msg
	call str_cmp_equal
	cmp rax, 1
	je .do_sub_operation

.check_mul_operator:
	; NOTE: The label operator_str references a memory location. In that memory location, the address of the string is stored.
	; NOTE: Which is why it needs to be dereferenced first to get the address of the string.
	mov rsi, [rel operator_str]

	; NOTE: The label mul_msg references a memory location where a string is stored.
	; NOTE: Which is why it doesn't need to be dereferenced first.
	mov rdi, mul_msg
	call str_cmp_equal
	cmp rax, 1
	je .do_mul_operation

.check_div_operator:
	; NOTE: The label operator_str references a memory location. In that memory location, the address of the string is stored.
	; NOTE: Which is why it needs to be dereferenced first to get the address of the string.
	mov rsi, [rel operator_str]

	; NOTE: The label div_msg references a memory location where a string is stored.
	; NOTE: Which is why it doesn't need to be dereferenced first.
	mov rdi, div_msg
	call str_cmp_equal
	cmp rax, 1
	je .do_div_operation

.check_no_valid_operator:
	jmp .exit
	
.do_add_operation:
	mov rax, [rel operand1]
	mov rbx, [rel operand2]
	add rax, rbx
	mov [rel result], rax
	jmp .result_to_str

.do_sub_operation:
	mov rax, [rel operand1]
	mov rbx, [rel operand2]
	sub rax, rbx
	mov [rel result], rax
	jmp .result_to_str

.do_mul_operation:
	mov rax, [rel operand1]
	mov rbx, [rel operand2]
	mul rbx
	mov [rel result], rax
	jmp .result_to_str

.do_div_operation:
	mov rax, [rel operand1]
	mov rbx, [rel operand2]
	div rbx
	mov [rel result], rax
	jmp .result_to_str

.result_to_str:
	mov rdi, [rel result]
	mov rsi, char_arr
	mov rcx, char_arr_count
	call convert_int_to_str

	; Print result with '\n' added to the end.
	mov rdx, [rel char_arr_count]
	mov [char_arr + rdx], 0x0A ; Line feed
	inc rdx
	mov [rel char_arr_count], rdx
	call print

.exit:
        mov rax, 60 ; exit
        mov rdi, 0
        syscall

; Print function
; rsi - Coints pointer to character array, which will be used in syscall.
; rdx - Cointains amount of elements in array, which will be used in syscall.
print:
        mov rax, 1 ; write
        mov rdi, 1 ; stdout
        syscall
	ret
