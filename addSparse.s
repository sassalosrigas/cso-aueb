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
        bge $t0, $a3, exit1       # a>=mikosA
            bge $t1, $t3, exit1   # b>=mikosB
                lw $t4, ($a0)
                lw $t5, ($a1)
                lw $t6, ($a2)
                sw $t6, ($a2)
                bgt $t4, $t5, else_if     # sparseA>sparseB
                    lw $t4, ($a0)         # load sparseA[a]
                    sw $t4, ($a2)         # sparseC[c++]=SparseA[a++]
                    add $t0, $t0, 1       # a++
                    add $t2, $t2, 1       # c++;
                    sw $t6, ($a2)
                    lw $t4, ($a0)         # load sparseA[a]
                    sw $t4, ($a2)         # sparseC[c++]=SparseA[a++]
                    add $t0, $t0, 1       # a++
                    add $t2, $t2, 1       # c++;
                    j loop 
            else_if:
                bgt $t5, $t4, else        # sparseA<sparseB
                    lw $t5, ($a1)         # load sparseB[b]
                    sw $t5, ($a2)         # sparseC[c++]=SparseB[b++]
                    add $t2, $t2, 1       # c++;
                    add $t1, $t1, 1       # b++;
                    sw $t6, ($a2)
                    lw $t5, ($a1)         # load sparseB[b]
                    sw $t5, ($a2)         # sparseC[c++]=SparseB[b++]
                    add $t2, $t2, 1       # c++;
                    add $t1, $t1, 1       # b++;
                    j loop 
                
            else:
                lw $t4, ($a0)             # load sparseA[a]
                sw $t4, ($a2)             # sparseC[c++]=SparseA[a++]
                add $t0, $t0, 1           # a++;
                add $t2, $t2, 1           # c++;
                lw $t4, ($a0)             # load sparseA[a]
                lw $t5, ($a1)             # load sparseB[b]
                add $t6, $t4, $t5         # sparseC[c++]=SparseA[a++]+SparseB[b++]
                sw $t6, ($a2)
                       
                add $t0, $t0, 1           # a++;
                add $t1, $t1, 1           # b++;
                add $t2, $t2, 1           # c++;
                j loop

    exit1:
        loopA:
            bge $t0, $a3, exit2
                lw $t4, ($a0)         # load sparseA[a]
                sw $t4, ($a2)         # sparseC[c++]=SparseA[a++]
                add $t0, $t0, 1       # a++
                add $t2, $t2, 1       # c++;
                sw $t6, ($a2)
                lw $t4, ($a0)         # load sparseA[a]
                sw $t4, ($a2)         # sparseC[c++]=SparseA[a++]
                add $t0, $t0, 1       # a++
                add $t2, $t2, 1       # c++;
                j loopA 
                
    exit2:
        loopB:
            bge $t1, t3$, end
                lw $t5, ($a1)         # load sparseB[b]
                sw $t5, ($a2)         # sparseC[c++]=SparseB[b++]
                add $t2, $t2, 1       # c++;
                add $t1, $t1, 1       # b++;
                sw $t6, ($a2)
                lw $t5, ($a1)         # load sparseB[b]
                sw $t5, ($a2)         # sparseC[c++]=SparseB[b++]
                add $t2, $t2, 1       # c++;
                add $t1, $t1, 1       # b++;
                j loopB     
             
    end:
        sw $t2,c
        move $v0, $t2
        jr $ra

        


