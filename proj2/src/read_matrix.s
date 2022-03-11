.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -28
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    
    mv s0 a0
    mv s1 a1
    mv s2 a2
    # open file
    mv a1 s0
    li a2 0
    jal ra fopen
    li t0 -1
    beq a0 t0 exit_50
    mv s5 a0        # s5 rep file descriptor.
    # read #rows
    mv a1 s5
    mv a2 s1
    addi a3 x0 4
    jal ra fread
    addi a0 a0 -4
    bne a0 x0 exit_51
    # read #cols
    mv a1 s5
    mv a2 s2
    addi a3 x0 4
    jal ra fread
    addi a0 a0 -4
    bne a0 x0 exit_51  


    # allocate a1 * a2 * 4 memory
    lw t0 0(s1)
    lw t1 0(s2)
    mul t2 t0 t1
    slli s3 t2 2    # s3 rep total bytes of matrix in the the target file.
    mv a0 s3
    jal ra malloc
    mv s4 a0        # s4 rep a pointer that points to buffer.
    # read file content into matrix
    mv a1 s5
    mv a2 s4
    mv a3 s3
    jal ra fread
    bne a0 s3 exit_51
    # close file
    mv a1 s5
    jal ra fclose
    bne a0 x0 exit_52

    mv a0 s4
    mv a1 s1
    mv a2 s2
    # Epilogue 
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    addi sp sp 28

    ret

exit_50:
    li a1 50
    j exit2


exit_51:
    li a1 51
    j exit2


exit_52:
    li a1 52
    j exit
