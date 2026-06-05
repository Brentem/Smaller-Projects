; NASM (Intel) syntax used -> (destination, source)
bits 64

section .data

msg:    db      "Correct input is given!", 10
.len:   equ     $ - msg

section .text
        global _start

_start:
        pop     rax ; Get argc from stack
        cmp     rax, 2 ; If argc != 2 go to exit
        jne     .exit

        pop     rbx ; Get arg1 from stack. In our casse this is ./build/main
        pop     rbx ; Get arg2 from stack. In our case this is @
        mov     rcx, [rbx] ; Write value which the memory address in rbx points to.
                           ; See rbx as a pointer that is dereferenced.

        cmp     cl, 0x40 ; Check the lowest byte in the rcx register if it contains a @ character (0x40).
        je     printTestOne

        .exit:
        mov     rax, 60 ; exit
        mov     rdi, 0
        syscall

; TODO: Jumping to this causes a segmentation fault, but the message does print.
printTestOne:
        mov     rax, 1 ; write
        mov     rdi, 1 ; stdout
        mov     rsi, msg
        mov     rdx, msg.len
        syscall
        ret
