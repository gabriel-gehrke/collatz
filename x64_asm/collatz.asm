; collatz.asm

extern printf
extern scanf

section .data
    infmt       db  "%llu",0
    outfmt      db  "%llu",10,0

section .text

global main
main:
    mov rbp, rsp; for correct debugging

    ; get input with scanf, let scanf write value to stack (by passing rsp)
    xor eax, eax
    push rax ; make room on stack
    mov rdi, infmt
    mov rsi, rsp ; store value on stack
    call scanf
    
    pop r12 ; load scanned value from stack
    and r12, r12
    jz exit ; exit if loaded value was zero
    
    cmp r12, 1 ; exit if loaded value was one
    je exit
    
loop:
    mov rax, r12 ; copy current value
    
    and rax, 1  
    jnz odd ; handle odd number
    
    sar r12, 1 ; handle even number (div by 2)
    jmp print
    
odd:
    ; calc r12 = 3*r12 + 1
    mov rax, r12 ; copy r12
    mov rbx, r12 ; copy r12
    sal rbx, 1 ; = r12*2
    add rax, rbx ; = r12 + 2*r12 = 3*r12
    inc rax
    
    mov r12, rax

print:
    ; printf logic
    xor eax, eax ; no xmm used
    mov rdi, outfmt
    mov rsi, r12
    call printf
    
    cmp r12, 1
    jne loop

exit:
    ; close program
    mov rax, 60 ; = exit
    mov rdi, 0 ; = success
    
    ret
