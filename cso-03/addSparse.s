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
    bb: .space 4
    c: .space 4
#----------------------------------------------------------------------------------------------------------
.text
main:
    la $a0, sparseA
    la $a1, sparseB
    la $a2, sparseC
    la $a3, mikosA
    jal addSparse
    move $a0,$v0
    # exit program
    li $v0, 10
    syscall

# subprogram
addSparse:
    sub $sp, $sp, 4
    sw $a0, 0($sp)
    lw $s4,0($sp)
    move $s0, $a0 # sparseA
    move $s1, $a1 # sparseB
    move $s2, $a2 # sparseC
    move $s3, $a3 # mikos a
    
    li $t0, 0 # a=0
    li $t1, 0 # b=0
    li $t2, 0 # c=0

    loop:
        bge $t0, $a3, loopA       # a>=mikosA
        bge $t1, $t3, loopA   # b>=mikosB
        lw $t4, 0($s0)    # sparseA[i]
        lw $t5, 0($s1)    # sparseB[i]
        bgt $t4, $t5, else_if     # sparseA>sparseB
        sw $t4, 0($s2)        # sparseC[c++]=SparseA[a++]
        add $t0, $t0, 1       # a++
        add $t2, $t2, 1       # c++;
        
        add $s2, $s2, 4
        add $s0, $s0, 4

        lw $t4, 0($s0)        # load sparseA[a]
        sw $t4, 0($s2)        # sparseC[c++]=SparseA[a++]
        add $t0, $t0, 1       # a++
        add $t2, $t2, 1       # c++;
        j loop 

        else_if:
        bgt $t5, $t4, else        # sparseA<sparseB
        sw $t5, 0($s2)         # sparseC[c++]=SparseB[b++]
        add $t2, $t2, 1       # c++;
        add $t1, $t1, 1       # b++;
        
        add $s2, $s2, 4
        add $s1, $s1, 4

        lw $t5, 0($s1)         # load sparseB[b]
        sw $t5, 0($s2)         # sparseC[c++]=SparseB[b++]
        add $t2, $t2, 1       # c++;
        add $t1, $t1, 1       # b++;
        j loop 
            
        else:
        sw $t4, 0($s2)             # sparseC[c++]=SparseA[a++]
        add $t0, $t0, 1           # a++;
        add $t2, $t2, 1           # c++;
        add $t1, $t1, 1           # b++;
        add $s2, $s2, 4
        add $s1, $s1, 4
        add $s0, $s0, 4

        lw $t4, 0($s0)            # sparseA[i]
        lw $t5, 0($s1)            # sparseB[i]
        add $t6, $t4, $t5         # sparseC[c++]=SparseA[a++]+SparseB[b++]
        sw $t6, 0($a2)
            
        add $t0, $t0, 1           # a++;
        add $t1, $t1, 1           # b++;
        add $t2, $t2, 1           # c++;
        add $s2, $s2, 4
        add $s1, $s1, 4
        add $s0, $s0, 4

        j loop


    loopA:
        bge $t0, $s3, loopB
        lw $t4, 0($s0)         # load sparseA[a]
        sw $t4, 0($s2)         # sparseC[c++]=SparseA[a++]
        add $t0, $t0, 1       # a++
        add $t2, $t2, 1       # c++;
        add $s2, $s2, 4
        add $s0, $s0, 4
            
        lw $t4, 0($s0)         # load sparseA[a]
        sw $t4, 0($s2)         # sparseC[c++]=SparseA[a++]
        add $t0, $t0, 1       # a++
        add $t2, $t2, 1       # c++;
        add $s2, $s2, 4
        add $s0, $s0, 4

        j loopA 
            
    loopB:
        bge $t1, $t3, end
        lw $t5, 0($s1)         # load sparseB[b]
        sw $t5, 0($s2)         # sparseC[c++]=SparseB[b++]
        add $t2, $t2, 1       # c++;
        add $t1, $t1, 1       # b++;
        add $s2, $s2, 4
        add $s1, $s1, 4

        lw $t5, 0($s1)         # load sparseB[b]
        sw $t5, 0($s2)         # sparseC[c++]=SparseB[b++]
        add $t2, $t2, 1       # c++;
        add $t1, $t1, 1       # b++;
        add $s2, $s2, 4
        add $s1, $s1, 4
        j loopB     
        
             
    end:

        add $sp, $sp, 4
        move $v0, $t2
        jr $ra

    