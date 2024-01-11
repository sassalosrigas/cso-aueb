# -----------------------------------------------------------
# file: cso-project-01.asm
# author: Rigas Sassalos (3220178)
# -----------------------------------------------------------
.data
str: .asciiz "Enter number of objects in the set (n): "
str2: .asciiz "Enter number to be chosen (k): "
str3_1: .asciiz "C("
str3_2: .asciiz ", "
str3_3: .asciiz ") = "
str3_4: .asciiz "\n"
str4: .asciiz "Please enter n >=k >=0\n"
str5: .asciiz "Attention! n and k must be less than 12\n"
str6: .asciiz "Sorry, n and k must be less than 12. Program will now exit.\n"
Factorial_n: .word 1
Factorial_k: .word 1
Factorial_n_k: .word 1

.text
.globl main
main:
    li $v0, 4
    la $a0, str5 # System.out.println("Attention! n and n must be less than 12")
    syscall

    li $v0, 4
    la $a0, str # System.out.print("Enter number of objects in the set (n): ")
    syscall

    li $v0, 5 # int n = in.nextInt();
    syscall
    move $t0, $v0

    li $v0, 4
    la $a0, str2 # System.out.print("Enter number to be chosen (k): ")
    syscall

    li $v0, 5 # int k = in.nextInt();
    syscall
    move $t1, $v0

    bgt $t0, 12, else_factorial # checks if (n <= 12) *the max factorial that can be stored in a 32-bit register*

    bgt $t1, 12, else_factorial # checks if (k <= 12) *the max factorial that can be stored in a 32-bit register*

    blt $t0, $t1, else_label # checks if (n >= k) 

    blt $t1, $zero, else_label # checks if (k >= 0)

    lw $t2, Factorial_n # int Factorial_n = 1;
    li $t3, 1 # int i = 1;
    loop1:
        bgt $t3, $t0, end_loop1 # for (i = 1; i <= n; i++)
        mul $t2, $t2, $t3 # Factorial_n *= i;

        addi $t3, $t3, 1 # i++;

        j loop1
    end_loop1:

    lw $t4, Factorial_k # int Factorial_k = 1;
    li $t3, 1 # i = 1;
    loop2:
        bgt $t3, $t1, end_loop2 # for (i = 1; i <= k; i++)
        mul $t4, $t4, $t3 # Factorial_k *= i;

        addi $t3, $t3, 1 # i++;

        j loop2
    end_loop2:

    lw $t5, Factorial_n_k # int Factorial_n_k = 1;
    li $t3, 1 # i = 1;
    sub $t6 $t0, $t1 # n - k
    loop3:
        bgt $t3, $t6, end_loop3 # for (i = 1; i <= (n - k); i++)
        mul $t5, $t5, $t3 # Factorial_n_k *= i;

        addi $t3, $t3, 1 # i++;

        j loop3
    end_loop3:

    mul $t4, $t4, $t5 # (Factorial_k * Factorial_n_k);
    div $t2, $t2, $t4 # Factorial_n / (Factorial_k * Factorial_n_k);

    li $v0, 4
    la $a0, str3_1 # prints "C("
    syscall

    li $v0, 1
    move $a0, $t0 # prints n
    syscall

    li $v0, 4
    la $a0, str3_2 # prints ", "
    syscall

    li $v0, 1
    move $a0, $t1 # prints k
    syscall

    li $v0, 4
    la $a0, str3_3 # prints ") = "
    syscall

    li $v0, 1
    move $a0, $t2 # prints result
    syscall

    li $v0, 4
    la $a0, str3_4 # prints "\n"
    syscall

    li $v0, 10 # exit
    syscall

    else_label:
        li $v0, 4
        la $a0, str4 # System.out.println("Please enter n >=k >=0")
        syscall

    li $v0, 10 # exit
    syscall

    else_factorial:
        li $v0, 4
        la $a0, str6 # System.out.println("Sorry, n and k must be less than 12. Program will now exit.")
        syscall

    li $v0, 10 # exit
    syscall
        

        