.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    addi sp sp -4
    sw ra 0(sp)

    li t0 1
    blt a1 t0 exit_8 # if a1 < 1, then exits with error code 8.


loop_start:
    addi t0 x0 0  # t0 is a counter, default value = 0.
    li t1 4       # t1 is the size of int.
    add t2 a1 x0  #t2 is the # of elements in the array.     


loop_continue:
   
    mul t3 t0 t1  # offset of array address.
    add t3 a0 t3  # address of each element.
    lw t4 0(t3)    # t4 is the value of array item.

    addi t0 t0 1
    blt t4 x0 zero_neg    

    blt t0 t2 loop_continue # repeat if we don't finish this iteration.


loop_end:

    lw ra 0(sp)
    addi sp sp 4

    ret


zero_neg:

    sw x0 0(t3)

    blt t0 t2 loop_continue
    jal loop_end


exit_8:

    addi a0 x0 17
    addi a1 x0 8
    ecall

