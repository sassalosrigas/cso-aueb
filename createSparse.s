#----------------------------------------------------------------------------------------------------------
.data
pin: .word 0, 0, 0, 0, 0, 8, 0, 0, 0, -3
sparse: .space 40  # empty 10 ints array
i: .word 0
k: .word 0
#----------------------------------------------------------------------------------------------------------

.text
main: 
    la $a0, pin       # loading the address of pin to $a0
    la $a1, sparse    # loading the address of sparse to $a1
    jal createSparse  # calling the subprogram
    move $a2, v0

#>ExitProgram----------------------------------------------------------------------------------------------
li $v0, 10
syscall

#>SubProgram-----------------------------------------------------------------------------------------------
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


