.section .rodata
format_f:       .string "invalid option!\n"

.section .data
PSTR_STRT_IDX:  .word 49
UPP_CHR_STRT:   .word 65
UPP_CHR_END:    .word 90
LTL_CHR_STRT:   .word 97
LTL_CHR_END:    .word 122

.section .text
.globl pstrlen
.type pstrlen, @function        # *pstr is in rdi
pstrlen:
    push %rbp
    movq %rsp, %rbp
    movzbq (%rdi), %rcx         # moves 1st byte (pstr.len) of the value stored in the adress of rdi to ecx.
    movq %rcx, %rax             # move length of pstr1 as int to eax (return val register)
    movq %rbp, %rsp
    pop %rbp
    ret

.globl replaceChar
.type replaceChar, @function        # p is in rdi, oldChar is in sil, newChar is in cl
replaceChar:
    push %rbp                       #set-up
    push %rbx
    movq %rsp, %rbp
    xor %rbx, %rbx                  # i = 0
    xor %r8, %r8                    # initiallize r8 to 0

    movzbl (%rdi), %r8d               # moves p.len to rb8 (value)
    leaq 1(%rdi), %r9               # moves p.str to r9 (adress)
    checkFor:
        cmp %rbx, %r8               # compare i and p.len
        ja Done                     # if i > p.len (even if i is negative) terminate for loop
    forLoop:
        movzbl (%r9, %rbx), %r10d  # temp = *(p + i*1)
        cmp %r10d, %r8d             # compares temp and oldChar
        je True                     # if temp == oldChar goto "True"
    inc:
        inc %rbx                    # i++
        jmp checkFor
    True:
        movb %cl, (%r9, %rbx, 1)     #*(p + i*1) = newChar
        jmp inc
    Done:
        leaq (%rdi), %rax
        pop %rbx
        movq %rbp, %rsp
        pop %rbp
        ret
