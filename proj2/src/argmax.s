.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    addi sp sp 4
    sw ra 0(sp)

    li t0 1
    blt a1 t0 exit_7    # if a1 < 1, then exits with error code 7.


loop_start:

    addi t0 x0 0    # t0 is the index of array element, if t0 > t1, then loop end.
    addi t1 a1 -1   # t1 is the length of array.
    li t2 4         # t2 is the size of array element. 
    addi t5 x0 0    # t5 is the index of max.

    lw t3 0(a0)     # load the first element as max.
    

loop_continue:
    
    addi t0 t0 1
    mul t4 t0 t2
    add t4 a0 t4
    lw t4 0(t4)    # t4 is the position of array element in memory location.

    blt t3 t4 change_max

    blt t0 t1 loop_continue    # decide if it should continue
    
            
loop_end:
    
    lw ra 0(sp)
    addi sp sp -4

    mv a0 t5

    ret


change_max:

    mv t3 t4
    mv t5 t0

    blt t0 t1 loop_continue
    jal loop_end


exit_7:

    addi a0 x0 17 
    addi a1 x0 7
    ecall
