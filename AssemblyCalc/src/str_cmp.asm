; Code taken from: https://www.daniweb.com/programming/software-development/threads/58667/assembly-language-comparing-strings
; RSI -> userInput (zero-terminated)
; RDI -> expected (zero-terminated)
; Preserves nothing; ZF set if equal
str_cmp_equal:
	cld
	push rdi                 ; save start of expected
	mov  rcx, -1
	xor  rax, rax
	repne scasb              ; scan expected for 0 (AL=0), updates EDI
	not  rcx                 ; ECX = len(expected) + 1 (includes terminator)
	pop  rdi                 ; restore start of expected
	repe cmpsb               ; compare up to ECX bytes
	sete al
	ret
