.section .rodata
 #jump table
    .align 8
    .jump_table:
        .quad .L50  #and 60
        .quad .L52
        .quad .L53
        .quad .L54
        .quad .L55
        .quad .L1   #default
        .quad .done

 #func_select rodata
    format_2c:       .string "%c %c"
    format_2d:       .string "%d %d"
    format_50_60:   .string "first pstring length: %d, second pstring length: %d\n"
    format_52:      .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
    format_53_54:   .string "length: %d, string: %s\n"
    format_55:      .string "compare result: %d\n"
    format_f:       .string "invalid option!\n"

    ## test for func_select
    format_50_60y:   .string "Hi from Lable 50 and 60\n"
    format_52y:      .string "Hi from Lable 52\n"
    format_53y:      .string "Hi from Lable 53\n"
    format_54y:      .string "Hi from Lable 54\n"
    format_55y:      .string "Hi from Lable 55\n"
    format_fy:       .string "Hi from Lable 1 - Default\n"
###



.section .text
    .globl func_select
    .type func_select, @function
    func_select:            # move &opt to rdi, &p1 to rsi, &p2 to rcx
        push %rbp
        movq %rsp, %rbp
        leaq (%rsi), %r14     # move &p1 to a calee saved register r14
        leaq (%rcx), %r15     # move &p2 to a calee saved register r15

        cmpl $50, %edi      # if equals 50, jump to 50.
        je .L50
        cmpl $60, %edi      # if equals 60, jump to 50.
        je .L50
        cmpl $51, %edi      # if equals 51, jump to Default.
        je .L1

        ## if values are betweem 0 and 5 - go to the matching lable
        leal -50(%edi), %edx       # normallize switch case values to 0-5
        cmpl $6, %edx              # compares 6 with opt (after normalization, valid values 0-5)
        ja .L1
        dec %edx
        jmp *.jump_table(,%edx,8)   # jumps to the matching lable
    .L60:
    .L50:
        xor %rax, %rax              # set-up call for pstrlen
        leaq (%r14), %rdi             # set-up call for pstrlen
        call pstrlen

        movq %rax, %rbx             # saves p1.len in ebx calee saved
        xor %rax, %rax              # set-up 2nd call for pstrlen
        leaq (%r15), %rdi             # move &p2 to rdi
        call pstrlen

        movq %rax, %rdx             # saves p2.len in 3rd register argument rcx
        movq %rbx, %rsi             # move p1.len to 2nd register argument
        movq $format_50_60, %rdi    # moves format to 1st register argument/
        xor %rax, %rax
        call printf
        jmp .done
    .L52:
        call replaceChar
        movq $format_52, %rdi
        xor %rax, %rax
        call printf
        jmp .done
    .L53:
        movq $format_53_54, %rdi
        xor %rax, %rax
        call printf
        jmp .done
    .L54:
        movq $format_53_54, %rdi
        xor %rax, %rax
        call printf
        jmp .done
    .L55:
        movq $format_55, %rdi
        xor %rax, %rax
        call printf
        jmp .done
    .L1:
        movq $format_f, %rdi
        xor %rax, %rax
        call printf
        jmp .done
    .done:
        xor %rax, %rax
        movq %rbp, %rsp
        pop %rbp
    ret











