.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    blt a1 x0 exit_2
    blt a2 x0 exit_2
    blt a4 x0 exit_3
    blt a5 x0 exit_3
    bne a2 a4 exit_4
    # Prologue
    addi sp sp -32
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    # prepare for loop
    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    mv s4 a4
    mv s5 a5
    mv s6 a6
       
    add t0 x0 x0    # t0 rep outter loop index.


outer_loop_start:
    
    beq t0 s1 outer_loop_end

    # compute location of row vector in m0: a0 +  #col * 4 * outrer loop index.
    slli t2 s2 2    # t2 rep #bytes of each row in m0.
    mul t3 t2 t0    # t3 rep offset from a0. 
    add a0 s0 t3    
    mv a2 s2        
    li a3 1         
    
    mv t5 a0        # call dot will override a0.
 
    add s6 a6 t3
    add t2 x0 x0    # t2 rep inner loop index.
    
    
inner_loop_start:
    
    beq t2 s5 inner_loop_end
    # compute location of col vector in m1: a3 + inner loop index * 4.
    slli t1 t2 2    # t1 = 4 * index
    add a1 s3 t1   
    mv a4 s5        # a4 parameter for dot function.
    
    addi sp sp -12
    sw t0 0(sp)
    sw t2 4(sp)
    sw t5 8(sp)
    jal ra dot     # call dot.
    lw t0 0(sp)
    lw t2 4(sp)
    lw t5 8(sp)
    addi sp sp 12
    
    # put a0 into d in right position
    sw a0 0(s6)
    addi s6 s6 4
    mv a0 t5
    
    # jump to inner_loop_end
    addi t2 t2 1
    j inner_loop_start


inner_loop_end:

    addi t0 t0 1
    j outer_loop_start


outer_loop_end:

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    addi sp sp 32
    
    ret


exit_2:
    addi a0 x0 17
    addi a1 x0 2
    ecall


exit_3:
    addi a0 x0 17
    addi a1 x0 3
    ecall


exit_4:
    addi a0 x0 17
    addi a1 x0 4
    ecall
