# file name: printSparse.s
# authors: Anais Farhat (3220280)
#          Alexandra Tsitsopoulou (3220216)
#          Rigas Sassalos (3220178)
#----------------------------------------------------------------------------------------------------------
.data
    sparse: .space 40
    mikos: .space 4
    i: .word 0
    str1: .asciiz "Position: "
    str2: .asciiz " Value: "
    str3: .asciiz "\n"
#----------------------------------------------------------------------------------------------------------
.text
main:
    la $a0, sparse  # load address of sparse to $a0
    lw $a1, mikos   # load value of mikos to $a1

    jal printSparse # calling the subprogram

    # exit program
    li $v0, 10
    syscall

# subprogram
printSparse:
    lw $t0, i               # i = 0
    move $t1, $a0           # t1 = sparse

    loop:
        bge $t0, $a1, exit  # if i >= mikos, exit loop

        lw $t2, ($t1)       # t0 = sparse[i]
        lw $t3, 4($t1)      # t2 = sparse[i+1]

        li $v0, 4           # print "Position: "
        la $a0, str1
        syscall

        li $v0, 1           # print value of sparse[i]
        move $a0, $t2
        syscall

        li $v0, 4           # print " Value: "
        la $a0, str2
        syscall

        li $v0, 1           # print value of sparse[i+1]
        move $a0, $t3
        syscall

        li $v0, 4           # print "\n"
        la $a0, str3
        syscall

        addi $t1, $t1, 8    # t1 = t1 + 8
        addi $t0, $t0, 2    # i = i + 2

        j loop

    exit:
        jr $ra
