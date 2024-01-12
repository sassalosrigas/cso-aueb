# file name: main.s
# authors: Anais Farhat (3220280)
#          Alexandra Tsitsopoulou (3220216)
#          Rigas Sassalos (3220178)
#----------------------------------------------------------------------------------------------------------
.text
main_loop:
    jal readOption      # op=readOption()
    sw $v0, op

    lw $t0, op          # $t0=op 

    blt $t0, 1, exit
    bgt $t0, 8, exit

    case_1:
        bne $t0, 1, case_2

        la $a0, c1 
        li $v0, 4
        syscall

        la $a0, pinA
        jal readPin
        j read_op

    case_2:
        bne $t0, 2, case_3

        la $a0, c2 
        li $v0, 4
        syscall

        la $a0, pinB
        jal readPin
        j read_op
    
    case_3:
        bne $t0, 3, case_4

        la $a0, c3 
        li $v0, 4
        syscall

        la $a0, pinA
        la $a1, SparseA
        jal createSparse
        sw $v0, mikosA
        lw $t7, mikosA

        move $t0, $t7
        div $t0, $t0, 2
        move $a0, $t0
        li $v0, 4
        syscall

        beq $t0, 1, onev
        la $a0, values
        li $v0, 4
        syscall

        j read_op
    
    case_4:
        bne $t0, 4, case_5

        la $a0, c4 
        li $v0, 4
        syscall

        la $a0, pinB
        la $a1, SparseB
        jal createSparse
        sw $v0, mikosB
        lw $t8, mikosB

        move $t0, $t8
        div $t0, $t0, 2
        move $a0, $t0
        li $v0, 4
        syscall

        beq $t0, 1, onev
        la $a0, values
        li $v0, 4
        syscall
        j read_op

    case_5:
        bne $t0, 5, case_6

        la $a0, c5 
        li $v0, 4
        syscall

        la $a0, SparseA
        la $a1, SparseB
        la $a2, SparseC
        lw $a3, mikosA
        lw $t4, mikosB
        sub $sp, $sp, 4
        sw $t4, 0($sp)
        jal addSparse
        sw $v0, mikosC
        lw $t9, mikosC

        move $t0, $t9
        div $t0, $t0, 2
        move $a0, $t0
        li $v0, 1
        syscall

        beq $t0, 1, onev
        la $a0, values
        li $v0, 4
        syscall
        j read_op

    case_6:
        bne $t0, 6, case_7

        la $a0, c6 
        li $v0, 4
        syscall

        la $a0, SparseA
        la $a1, mikosA
        jal printSparse
        j read_op

    case_7:
        bne $t0, 7, case_8

        la $a0, c7 
        li $v0, 4
        syscall

        la $a0, SparseB
        la $a1, mikosB
        jal printSparse
        j read_op

    case_8:
        la $a0, c8 
        li $v0, 4
        syscall

        la $a0, SparseC
        la $a1, mikosC
        jal printSparse
        j read_op

    onev:
        la $a0, value
        li $v0, 4
        syscall

    read_op:
        j main_loop

exit:
    add $sp, $sp, 4
    li $v0, 10
    syscall


