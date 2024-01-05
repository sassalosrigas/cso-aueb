# file name: addSparse.s
# authors: Anais Farhat (3220280)
#          Alexandra Tsitsopoulou (3220216)
#          Rigas Sassalos (3220178)
#----------------------------------------------------------------------------------------------------------
.data
    sparseA: .space 40
    sparseB: .space 40
    sparseC: .space 40
    mikosA: .space 4
    mikosB: .space 4
    a: .space 4
    b: .space 4
    c: .space 4
#----------------------------------------------------------------------------------------------------------
.text
main:
    li $a0, mikosB
    sw $a0, 16($sp)
    la $a0, sparseA
    la $a1, sparseB
    la $a2, sparseC
    la $a3, mikosA
    

    jal addSparse

    # exit program
    li $v0, 10
    syscall

# subprogram
addSparse:
    lw $t0, a
    lw $t1, b
    lw $t2, c
    lw $t3, 16($sp)
    

    loop:
    # malakies
        # or $t4, $t0, $t1 idk ti einai ayto -anais
        bge $t0, $a3, exit       # a>=mikosA
            bge $t1, $t3, exit   # b>=mikosB
                lw $t4, ($a0)
                lw $t5, ($a1)
                bgt $t4, $t5, else_if     # sparseA>sparseB
                
                
            else_if:
                bgt $t5, $t4, else        # sparseA<sparseB

                
            else:

            



    exit:

        


    




