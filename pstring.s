.section .rodata
format_f:       .string "invalid input!\n"

.section .text
.globl validation
.type validation, @function
validation:                                         # &dst in rdi, &src in rsi, i in rdx, j in rcx
    push %rbp
    movq %rsp, %rbp

    # validation
    cmpq %rcx, %rdx                                 # comare j and i
    ja notVal                                       # if i > j -> not valid
    movzbq (%rdi), %r8                              # moves dst.len tp r8
    movzbq (%rsi), %r9                              # moves src.len to r9
    cmpq %r8, %rdx                                  # compares dst.len with i
    jae notVal                                      # if i >= src.len goto not valid (includes the case when i<0 because unsigned)
    cmpq %r8, %rcx                                  # compares dst.len with j
    jae notVal                                      # if j >= dst.len goto not valid (includes the case when i<0 because unsigned)
    cmpq %r9, %rdx                                  # compares src.len with i
    jae notVal                                      # if i >= src.len goto not valid (includes the case when i<0 because unsigned)
    cmpq %r9, %rcx                                  # compares src.len with j
    jae notVal
    cmpq %rdx, %rcx                                 # compare i and j
    js notVal                                       # if j < i not valid

    Valid:
        movq $1, %rax
        movq %rbp, %rsp
        pop %rbp
        ret
    notVal:
        # bacup register before calling printf, calls printf and restore them
        push %rdi
        push %rsi
        push %rdx
        push %rcx
        movq $format_f, %rdi
        call printf
        pop %rcx
        pop %rdx
        pop %rsi
        pop %rdi
        # end of printf block

        movq $0, %rax
        movq %rbp, %rsp
        pop %rbp
        ret
.globl pstrlen
.type pstrlen, @function                            # *pstr is in rdi
pstrlen:
    push %rbp
    movq %rsp, %rbp
    movzbq (%rdi), %rcx                             # moves 1st byte (pstr.len) of the value stored in the adress of rdi to ecx.
    movq %rcx, %rax                                 # move length of pstr1 as int to eax (return val register)
    movq %rbp, %rsp
    pop %rbp
    ret

.globl replaceChar
.type replaceChar, @function                        # &p is in rdi, oldChar is in sil, newChar is in dl
replaceChar:
    push %rbp                                       #set-up
    movq %rsp, %rbp
    push %rbx
    xor %rbx, %rbx                                  # i = 0
    xor %r8, %r8                                    # initiallize r8 to 0
    movzbq (%rdi), %r8                              # moves p.len to rb8 (value)
    leaq 1(%rdi), %r9                               # moves p.str to r9 (adress)
    checkFor:
        cmp %r8, %rbx                               # compare i and p.len
        ja r_Done                                   # if i > p.len (even if i is negative) terminate for loop
    forLoop:
        movzbl (%r9, %rbx), %r10d                   # temp = *(p + i*1)
        cmp %r10b, %sil                             # compares temp and oldChar
        je True                                     # if temp == oldChar goto "True"
    inc:
        inc %rbx                                    # i++
        jmp checkFor
    True:
        movb %dl, (%r9, %rbx, 1)                    # *(p + i*1) = newChar
        jmp inc
    r_Done:
        movq %rdi, %rax
        pop %rbx
        movq %rbp, %rsp
        pop %rbp
        ret

.globl pstrijcpy
.type pstrijcpy, @function
pstrijcpy:                                          # &dst in rdi, &src in rsi, i in rdx, j in rcx
    push %rbp                                       # check if i,j >=0, and i<=dst.len-1, j<= src.len-1
    movq %rsp, %rbp
    push %r12
    push %r13

    ## backup caller saved registers, call validation and restore them
    push %rdi
    push %rsi
    push %rdx
    push %rcx
    call validation
    pop %rcx
    pop %rdx
    pop %rsi
    pop %rdi
    cmp $0, %rax                                    # if validation returned 0, there is an e-validation
    je p_Done
    ##

    leaq 1(%rdi), %r12                              # moves dst->str to r12
    leaq 1(%rsi), %r13                              # moves src->str to r13
    loop:
        movb (%r13, %rdx, 1), %r8b                  # moves src->str[i] to r8
        movb %r8b, (%r12, %rdx, 1)                  # moves r8 to dst->str[i]
        inc %rdx
        cmp %rdx, %rcx                              # compares j and i (does i-j)
        js p_Done                                   # if i > j done
        jmp loop
    p_Done:
        movq %rdi, %rax
        pop %r13
        pop %r12
        movq %rbp, %rsp
        pop %rbp
        ret

.globl swapCase
.type swapCase, @function
swapCase:                # &p is in rdi
    push %rbp
    movq %rsp, %rbp
    push %rbx
    push %r12
    push %r13

    leaq 1(%rdi), %r13                              # moves &p1->str to r13
    xor %rbx, %rbx                                  # i = 0
    xor %r12, %r12                                  # initialize r12 to 0
    xor %r8, %r8                                    # initialoze r8 to 0. (temp = 0)
    movb (%rdi), %r12b                              # moves p.len to r12
    for_con:
        cmpb %r12b, %bl                             # compares p.len and i
        je s_done
    s_loop:
       movb (%r13, %rbx, 1), %r8b                   # temp =  p->str[i]
       check_upper:
           cmpb $65, %r8b                           # compare temp to 65
           jge eq_big_65                            # if temp >= 65, he may be upperCase Char
           jmp next_iter                            # if temp < 65 he is not a char
       eq_big_65:                                   # if got here, temp >= 65
           cmpb $90, %r8b                           # compare temp and 90
           jle is_upper_case                        # if temp <= 90 than he is uppercase
       check_lower:                                 # if got here, temp > 90.
            cmpb $97, %r8b                          # compares temp to 97
            jge eq_bigger_than_97                   # if bigger than 97, continue checking
            jmp next_iter
       eq_bigger_than_97:
            cmpb $122, %r8b                         # compares temp to 122
            jle is_lower_case                       # if temp <= 122 than he is lower case char
            jmp next_iter
       next_iter:
            inc %rbx
            jmp for_con
       s_done:
            movq %rdi, %rax
            pop %r13
            pop %r12
            pop %rbx
            movq %rbp, %rsp
            pop %rbp
            ret
       is_lower_case:
            subb $32, %r8b
            movb %r8b,(%r13, %rbx, 1)
            jmp next_iter
       is_upper_case:
            addb $32, %r8b
            movb %r8b,(%r13, %rbx, 1)
            jmp next_iter

.globl pstrijcmp                                    # &p1 in rdi, &p2 in rsi, i in edx, j in ecx
.type pstrijcmp, @function
pstrijcmp:
    push %rbp                                       # check if i,j >=0, and i<=dst.len-1, j<= src.len-1
    movq %rsp, %rbp
    push %r12
    push %r13

    ## backup caller saved registers, call validation and restore them
    push %rdi
    push %rsi
    push %rdx
    push %rcx
    call validation
    pop %rcx
    pop %rdx
    pop %rsi
    pop %rdi
    cmp $0, %rax    ## if validation returned 0, there is an e-validation
    movq $-2, %rax
    je func_done
    ##

    leaq 1(%rdi), %r12                              # moves dst->str to r12
    leaq 1(%rsi), %r13                              # moves src->str to r13
    p_loop:
        movb (%r12, %rdx, 1), %r8b                  # moves p1->str[i] to r8b
        movb (%r13, %rdx, 1), %r9b                  # moves p2->str[i] to r9b
        cmpb %r9b, %r8b                             # compares p1->str[i] : p2->str[i]
        jg first_is_bigger                          # if r8b > r9b
        jl second_is_bigger
    equal_chars:                                    # if we got here, that means that
        inc %rdx
        cmp %rdx, %rcx                              # compares j and i (does i-j) p1->str[i] == p2->str[i]
        js equals                                   # if i > j done
        jmp p_loop
    equals:
        movq $0, %rax
        jmp func_done
    first_is_bigger:
        movq $1, %rax
        jmp func_done
    second_is_bigger:
        movq $-1, %rax
        jmp func_done                               # for readabillity
    func_done:
        pop %r13
        pop %r12
        movq %rbp, %rsp
        pop %rbp
        ret

