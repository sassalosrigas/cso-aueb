# file name: printSparse.s
# authors: Anais Farhat (3220)
#          Alexandra Tsitsopoulou (3220)
#          Rigas Sassalos (3220178)
#----------------------------------------------------------------------------------------------------------
.data
    sparse: .word 5, 8, 9, -3
    mikos: .word 4
    i: .word 0
    str1: .asciiz "Position: "
    str2: .asciiz " Value: "
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
    lw $t0, i       # i = 0

    loop:
        bge $t0, $a1, exit  # if i >= mikos, exit loop

        lw $t1, 0($a0)      # load value of sparse[i]
        lw $t2, 4($a0)      # load value of sparse[i+1]

        li $v0, 4
        la $a0, str1
        syscall

        li $v0, 1           # print value of sparse[i]
        move $a0, $t1
        syscall

        li $v0, 4
        la $a0, str2
        syscall

        li $v0, 1           # print value of sparse[i+1]
        move $a0, $t2
        syscall

        j loop

    exit:
        jr $ra
