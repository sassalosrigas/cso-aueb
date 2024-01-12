.data
    filler:     .asciiz "\n----------------------------------------"
    option1:    .asciiz "\n1. Read Array A"
    option2:    .asciiz "\n2. Read Array B"
    option3:    .asciiz "\n3. Create Sparse Array A"
    option4:    .asciiz "\n4. Create Sparse Array B"
    option5:    .asciiz "\n5. Create Sparse Array C = A + B"
    option6:    .asciiz "\n6. Display Sparse Array A"
    option7:    .asciiz "\n7. Display Sparse Array B"
    option8:    .asciiz "\n8. Display Sparse Array C"
    option0:    .asciiz "\n0. Exit"
    choice:     .asciiz "\nChoice? "
    Answer:     .space 4

.data
    pin: .word 0, 0, 0, 0, 0, 8, 0, 0, 0, -3
    sparseA: .space 40
    sparseB: .space 40
    sparseC: .space 40
    mikosA: .space 4
    mikosB: .space 4
    a: .space 4
    bb: .space 4
    c: .space 4

.data
    test:   .asciiz "Test"
    text1:   .asciiz "Position "
    text2:  .asciiz " : \n"
    in:     .space 4
    i:      .space 4

.text
    .globl main

main:

    jal readOption
    move $a0,$v0  # returns the chosen option of the user

    # Switch case for different options
    li $t0, 0    # Set $t0 to the chosen option
    j switch_case

    # Option 1: Read Array A
    lw $t0, Answer
    beq $t0, 1, read_array

    # Option 2: Read Array B
    lw $t0, Answer
    beq $t0, 2, read_array

    # Option 3: Create Sparse Array A
    lw $t0, Answer
    beq $t0, 3, create_sparse

    # Option 4: Create Sparse Array B
    lw $t0, Answer
    beq $t0, 4, create_sparse

    # Option 5: Create Sparse Array C = A + B
    lw $t0, Answer
    beq $t0, 5, create_sparse_C

    # Option 6: Display Sparse Array A
    lw $t0, Answer
    beq $t0, 6, display_sparse

    # Option 7: Display Sparse Array B
    lw $t0, Answer
    beq $t0, 7, display_sparse

    # Option 8: Display Sparse Array C
    lw $t0, Answer
    beq $t0, 8, display_sparse

    # Option 0: Exit
    lw $t0, Answer
    beq $t0, 0, exit_program

switch_case:

    # Handle invalid input
    j main

read_array:
    la $a0, test
    li $v0, 4
    syscall

    la $a0,pin
    j readPin

create_sparse:
    la $a0, pin
    la $a1, sparseA
    jal createSparse
    move $a2, $v0
    j main

create_sparse_C:
    lw $t9, mikosB
    move $a0, $t9
    sw $a0, 16($sp)
    la $a0, sparseA
    la $a1, sparseB
    la $a2, sparseC
    la $a3, mikosA

    jal addSparse

display_sparse:
    # Call the subprogram to display Sparse Array A
    la $a0, sparse
    lw $a1, mikos
    jal printSparse
    j main

exit_program:
    # Exit program
    li $v0, 10
    syscall

#-----------------------------------------------------------------------------------

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

#-----------------------------------------------------------------------------------

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

#-----------------------------------------------------------------------------------

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

#-----------------------------------------------------------------------------------

addSparse:
    lw $t0, a
    lw $t1, bb
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
            
                lw $t4, ($a0)         # load next sparseA[a]
                sw $t4, ($a2)         # sparseC[c++]=SparseA[a++]
                add $t0, $t0, 1       # a++
                add $t2, $t2, 1       # c++;
    
                j loopA 
                
    exit2:
        loopB:
            bge $t1, $t3, end
                lw $t5, ($a1)         # load sparseB[b]
                sw $t5, ($a2)         # sparseC[c++]=SparseB[b++]
                add $t2, $t2, 1       # c++;
                add $t1, $t1, 1       # b++;

                lw $t5, ($a1)         # load sparseB[b]
                sw $t5, ($a2)         # sparseC[c++]=SparseB[b++]
                add $t2, $t2, 1       # c++;
                add $t1, $t1, 1       # b++;
                j loopB     
             
    end:
        move $v0, $t2
        jr $ra

#-----------------------------------------------------------------------------------

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