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
# _____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
# subprograms
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

createSparse:
    lw $t0,i
    lw $t1,k

    loop:
        bgt $t0, $a0, exit
            lw $t2, 0($a0)
            lw $t3, 0($a1)
            bnez $t2, else
                add $t1, $t1, 1  # k++
                sw $t0, 0($a1)   # sparse[k++]=i
                add $t1, $t1, 1  # k++
                sw $t2, 0($a1)   # sparse[k++] = pin[i]
            else:
                add $a0, $a0, 4  # next element in pin
                add $t0, $t0, 1  # i++
                j loop

        
    exit:
        sw $t1,k
        move $v0, $t1
        jr $ra

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

    jr $ra  #return Answer

readPin:    

    la $t0,pin  # $t0 is base register of given pin
    
    li $t1,0
    sw $t1,i    # i = 0

readNext:

    lw $t1,i
    bge $t1,10,exitread     # if i >= 10 the execution of the function ends   

#-----------------this is only executed if i < 10 -------------------
    lw $t3,($t0)    # $t3 is next int from pin

    la $a0,text1
    li $v0,4
    syscall     # prints "Position "

    lw $t1,i
    lw $a0,i
    li $v0,1
    syscall     # prints the value of i

    la $a0,text2
    li $v0,4
    syscall     # prints " : "

    li $v0,5
    syscall     # reads value from user

    sw $v0,in   # in = nextInt()

    li $t2,in
    sb $t2,($t3)    # pin[i] = in.nextInt();

    add $t1,$t1,1
    sw $t1,i    # i ++

    j readNext

#--------------this is executed if i >= 10---------------
exitread:

    move $v0,pin
    jr $ra

  
