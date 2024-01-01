    .text
    .globl main

main:

    jal readOption
    move $a0,$v0    # returns the chosen option of the user




readOption:

    la $a0,filler
    li $v0,4
    syscall

    la $a0,option1
    li $v0,4
    syscall

    la $a0,option2
    li $v0,4
    syscall

    la $a0,option3
    li $v0,4
    syscall

    la $a0,option4
    li $v0,4
    syscall

    la $a0,option5
    li $v0,4
    syscall

    la $a0,option6
    li $v0,4
    syscall

    la $a0,option7
    li $v0,4
    syscall

    la $a0,option8
    li $v0,4
    syscall

    la $a0,option0
    li $v0,4
    syscall

    la $a0,filler
    li $v0,4
    syscall

    la $a0,choice
    li $v0,4
    syscall
    
    li $v0,5    # read user input 
    syscall

    sw $v0,Answer   # int Answer = in.nextInt();

    li $t0,Answer
    move $v0,$t0    # $v0 = Answer

    jr $ra  #return Answer

    .data
filler:     .asciiz "\n----------------------------------------"
option1:    .asciiz "\n1. Read Array A"
option2:    .asciiz "\n2. Read Array B"
option3:    .asciiz "\n3. Create Sparse Array A"
option4:    .asciiz "\n4. Create Sparse Array B"
option5:    .asciiz "\n5. Create Sparse Array C = A + B"
option6:    .asciiz "\n6. Display Sparse Array A"
option7:    .asciiz "\n7. Display Sparse Array B"
option8:    .asciiz "\n6. Display Sparse Array C"
option0:    .asciiz "\n0. Exit"
choice:     .asciiz "\nChoice? "
Answer:     .space 4