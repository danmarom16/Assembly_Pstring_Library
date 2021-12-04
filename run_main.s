.section .rodata
    # main_run rodata
    format_d: .string "%d"
    format_s: .string "%s"
    format_c: .string "%c"
    format_str_print: .string "The user input is: %s\n"
    format_chr_print: .string "The user input is: %d\n"
    format_opt_print: .string "The user chosen option is: %d\n"


.section .text
    .globl run_main
    .type run_main, @function
    ## Function Execution:
    ##        p1:
    ##       -528(%rbp) = p1.len = 1st user input = length of p1.
    ##       -527(%rbp) = p1.str = 2st user input = the string itself.
    ##
    ##        p2:
    ##       -272(%rbp) = p2.len = 3rd user input = length of p2.
    ##       -271(%rbp) = p2.str = 4th user input = the string of p2 itself.
    ##        opt:
    ##        -16(%rbp) = opt equals 5th user input
    ##         adresses -12 <-> 0 are allignments.
    run_main:
        push %rbp                   # set-up
        movq %rsp, %rbp

        ## scan 1st argument p1.len
        subq $528, %rsp             # allocate 2*216 for Pstrings, 2*4 for integers, 8 for allignment
        movq $format_d, %rdi        # saves format "%d" to rdi - 1st parameter register.
        leaq -528(%rbp), %rsi       # takes the adress of p1.char
        xor %rax, %rax              # initiallize rax to zero
        call scanf

        ## scan 2nd argument p1.str
        movq $format_s, %rdi        # saves format "%s" to rdi.
        leaq -527(%rbp), %rsi       # takes adrerss of p1.str and puts it in rsi
        xor %rax, %rax
        call scanf

        ## scan 3rd argument p2.len
        movq $format_d, %rdi        # saves format "%d" to rdi - 1st parameter register.
        leaq -272(%rbp), %rsi       # takes the adress of p2.char
        xor %rax, %rax
        call scanf

        ## scan 4th argument p2.str
        movq $format_s, %rdi
        leaq -271(%rbp), %rsi
        xor %rax, %rax
        call scanf

        ## scan 5th argument opt
        movq $format_d, %rdi
        leaq -16(%rbp), %rsi
        xor %rax, %rax
        call scanf
        ##jmp test1

        # move &opt to rdi, &p1 to rsi, &p2 to rdx
        movzbl -16(%rbp), %edi      # takes the char 'opt' and puts it in edi with zero-fill for long
        leaq -528(%rbp), %rsi
        leaq -272(%rbp), %rcx
        call func_select

    end:
        xor %rax, %rax
        movq %rbp, %rsp
        pop %rbp
        ret



















    ## tests for debugg-------

    ## printf for debugg
    test1:
        movq $format_chr_print, %rdi
        movzbq -528(%rbp), %rsi         # takes the char (as byte) in the adress which is p1.len and puts it into 32-bit esi and fill empty spaces with-zero
        xor %rax, %rax
        call printf

        movq $format_str_print, %rdi
        leaq -527(%rbp), %rsi
        xor %rax, %rax
        call printf

        movq $format_chr_print, %rdi
        movzbq -272(%rbp), %rsi
        xor %rax, %rax
        call printf

        movq $format_str_print, %rdi
        leaq -271(%rbp), %rsi
        xor %rax, %rax
        call printf

        movq $format_opt_print, %rdi
        movzbq -16(%rbp), %rsi
        xor %rax, %rax
        call printf
    jmp end