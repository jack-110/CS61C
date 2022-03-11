.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:

    addi sp sp -4
    sw ra 0(sp)

    li t0 1
    blt a2 t0 exit_5
    blt a3 t0 exit_6
    blt a4 t0 exit_6

    # prepare for loop
    add t0 x0 x0    # t0 rep the index of element in array.
    addi t1 x0 4    # t1 rep the size of array element.
    add t2 x0 x0    # we will put intermediate result in t2
    add t3 a3 x0    # t3 rep the stride of v0
    slli t3 t3 2
    add t4 a4 x0    # t4 rep the stride of v1
    slli t4 t4 2


loop_start:

    # get elements from v0
    mul t5 t0 t3
    add t5 a0 t5   
    lw t5 0(t5)     # t5 rep v0 element.
    # get element from v1
    mul t6 t0 t4
    add t6 a1 t6    
    lw t6 0(t6)     # t6 rep v1 element.
   # compute result
    mul t5 t5 t6    # t5 = v1 * v0 for each element.
    add t2 t5 t2
    
    addi t0 t0 1
    blt t0 a2 loop_start


loop_end:

    lw ra 0(sp)
    addi sp sp 4
    
    mv a0 t2
    ret


exit_5:
    
    li a0 17
    addi a1 x0 5
    ecall


exit_6:
    
    li a0 17
    addi a1 x0 6
    ecall
