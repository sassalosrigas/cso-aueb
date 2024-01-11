# file name: readPin.s
# authors: Anais Farhat (3220280)
#          Alexandra Tsitsopoulou (3220216)
#          Rigas Sassalos (3220178)
#----------------------------------------------------------------------------------------------------------
    .text
    .globl main

main:

    la $a0, test
    li $v0, 4
    syscall

    la $a0,pin
    jal readPin

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

  
  
    .data
test:   .asciiz "Test"
text1:   .asciiz "Position "
text2:  .asciiz " : \n"
pin:    .space 40 # initialization of an array with 10 elements
in:     .space 4
i:     .space 4
