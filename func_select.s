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

    format_c:       .string "%c"
    format_d:       .string "%d"
    format_s:       .string "%s"
    format_50_60:   .string "first pstring length: %d, second pstring length: %d\n"
    format_52:      .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
    format_53_54:   .string "length: %d, string: %s\n"
    format_55:      .string "compare result: %d\n"
    format_f:       .string "invalid option!\n"

.section .text
    .globl func_select
    .type func_select, @function
    func_select:                    # move &opt to rdi, &p1 to rsi, &p2 to rcx
        push %rbp
        movq %rsp, %rbp
        push %r14
        push %r15
        movq %rsi, %r14             # move &p1 to a calee saved register r14
        movq %rcx, %r15             # move &p2 to a calee saved register r15

        cmpl $50, %edi              # if equals 50, jump to 50.
        je .L50
        cmpl $60, %edi              # if equals 60, jump to 50.
        je .L50
        cmpl $51, %edi              # if equals 51, jump to Default.
        je .L1

        ## if values are betweem 0 and 5 - go to the matching lable
        leal -50(%edi), %edx        # normallize switch case values to 0-5
        cmpl $6, %edx               # compares 6 with opt (after normalization, valid values 0-5)
        ja .L1                      # if i > 6 not valid
        dec %edx
        jmp *.jump_table(,%edx,8)   # jumps to the matching lable
    .L60:
    .L50:
        xor %rax, %rax              # set-up call for pstrlen
        movq %r14, %rdi             # set-up call for pstrlen
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
        movq $format_s, %rdi        # move "%s" to rdi
        subq $16, %rsp              # allocate 16 bytes
        leaq -16(%rbp), %rsi        # move adress that will store oldChar to rsi.
        xor %rax, %rax
        call scanf                  # scans oldChar to 1st byte of rax

        movq $format_s, %rdi
        leaq -8(%rbp), %rsi         # move adress that will store newChar to rsi
        xor %rax, %rax
        call scanf                  # scans newChar to 1st byte of rax

        movq %r14, %rdi             # moves &p1 to rdi
        movzbq -16(%rbp), %rsi      # moves oldChar to rsi
        movzbq -8(%rbp), %rdx       # moves newChar to rdx
        xor %rax, %rax
        call replaceChar
        movq %rax, %r14             # store r14 after replacement back in r14

        movq %r15, %rdi             # moves &p1 to rdi
        movzbq -16(%rbp), %rsi      # moves oldChar to rsi
        movzbq -8(%rbp), %rdx       # moves newChar to rdx
        xor %rax, %rax
        call replaceChar
        movq %rax, %r15

        movq $format_52, %rdi       # moves matching format to rdi
        movzbq -16(%rbp), %rsi      # moves oldChar to rsi
        movzbq -8(%rbp), %rdx       # moves newChar to rdx
        leaq 1(%r14), %rcx          # moves &p1 to rcx
        leaq 1(%r15), %r8           # moves &p2 to r8
        xor %rax, %rax
        call printf
        jmp .done
    .L53:                           # &dst in rdi, &src in rsi, i in rdx, j in rcx
        movq $format_d, %rdi        # move "%d" to rdi
        subq $16, %rsp              # allocate 16 bytes
        leaq -16(%rbp), %rsi        # move adress that will store i to rsi.
        xor %rax, %rax
        call scanf                  # scans oldChar to 1st byte of rax

        movq $format_d, %rdi
        leaq -8(%rbp), %rsi         # move adress that will store j to rsi
        xor %rax, %rax
        call scanf                  # scans newChar to 1st byte of rax

        movq %r14, %rdi             # moves &dst to rdi
        movq %r15, %rsi             # moves &src to rsi
        movl -16(%rbp), %edx        # moves i to edx
        movl -8(%rbp), %ecx         # moves j to ecx
        xor %rax, %rax
        call pstrijcpy
        movq %rax, %r14

        movq $format_53_54, %rdi
        movzbq (%r14), %rsi
        leaq 1(%r14), %rdx
        xor %rax, %rax
        call printf

        movq $format_53_54, %rdi
        movzbq (%r15), %rsi
        leaq 1(%r15), %rdx
        xor %rax, %rax
        call printf
        jmp .done

    .L54:
        movq %r14, %rdi             # moves &p1 to rdi
        call swapCase
        movq %rax, %r14

        movq %r15, %rdi             # moves &p2 to rdi
        call swapCase
        movq %rax, %r15

        movq $format_53_54, %rdi
        movzbq (%r14), %rsi
        leaq 1(%r14), %rdx
        xor %rax, %rax
        call printf

        movq $format_53_54, %rdi
        movzbq (%r15), %rsi
        leaq 1(%r15), %rdx
        xor %rax, %rax
        call printf
        jmp .done
    .L55:
        movq $format_d, %rdi        # move "%d" to rdi
        subq $16, %rsp              # allocate 16 bytes
        leaq -16(%rbp), %rsi        # move adress that will store i to rsi.
        xor %rax, %rax
        call scanf                  # scans oldChar to 1st byte of rax

        movq $format_d, %rdi
        leaq -8(%rbp), %rsi         # move adress that will store j to rsi
        xor %rax, %rax
        call scanf                  # scans newChar to 1st byte of rax

        movq %r14, %rdi             # moves &p1 to rdi
        movq %r15, %rsi             # moves &p2 to rsi
        movl -16(%rbp), %edx        # moves i to esx
        movl -8(%rbp), %ecx         # moves j to ecx
        xor %rax, %rax
        call pstrijcmp

        movq %rax, %rsi
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
        pop %r15
        pop %r14
        movq %rbp, %rsp
        pop %rbp
    ret











