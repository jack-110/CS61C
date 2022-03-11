.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


    # =====================================
    # LOAD MATRICES
    # =====================================
    
    addi sp sp -44
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7 32(sp)
    sw s8 36(sp)
    sw s9 40(sp)

    mv s0 a1

    # Load pretrained m0

    # allocate spaces for rows and cols
    li a0 8
    jal ra malloc
    addi a1 a0 0
    addi a2 a0 4 
    lw a0 4(s0)
    jal ra read_matrix

    mv s1 a0       # s1 rep the pointer to the m0 matrix in memory.
    lw s2 0(a1)    # s2 rep #rows for m0.
    lw s3 0(a2)    # s3 rep #cols for m0.
    
    # Load pretrained m1

    # allocate spaces for rows and cols
    li a0 8
    jal ra malloc
    addi a1 a0 0
    addi a2 a0 4
    lw a0 8(s0)
    jal ra read_matrix

    mv s4 a0
    lw s5 0(a1)
    lw s6 0(a2)
    
    # Load input matrix

    # allocate spaces for rows and cols
    li a0 8
    jal ra malloc
    addi a1 a0 0
    addi a2 a0 4
    lw a0 4(s0)
    lw a0 12(s0)
    jal ra read_matrix

    mv s7 a0
    lw s8 0(a1)
    lw s9 0(a2)


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # 1 m0 * input
    #li t0 9
    mul t0 s2 s9
    slli a0 t0 2
    jal ra malloc
    mv a6 a0

    mv a0 s1
    mv a1 s2
    mv a2 s3
    mv a3 s7
    mv a4 s8
    mv a5 s9

    jal ra matmul
   
    # m0 * input => pointer s1, #rows s2 #cols s3 
    mv s1 a6
    mv s2 s2
    mv s3 s9

    # 2 ReLU(m0 * input)
    mv a0 s1
    mul a1 s2 s3
    jal ra relu

    # 3 m1 * ReLU(m0 * input)
    mul t0 s5 s3
    slli a0 t0 2
    jal ra malloc
    mv a6 a0

    mv a0 s4
    mv a1 s5
    mv a2 s6
    mv a3 s1
    mv a4 s2
    mv a5 s3
   
    jal ra matmul
   
    # m1 * ReLU(m0 * input) => pointer s1, #rows se #cols s3 
    mv s1 a6
    mv s2 s5
    mv s3 s3

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    
    lw a0 16(s0)
    mv a1 s1
    mv a2 s2
    mv a3 s3
    
    jal ra write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    
    mv a0 s1
    mul a1 s2 s3
    
    jal ra argmax

    # Print classification
    mv a1 a0
    jal ra print_int
   

    # Print newline afterwards for clarity
    li a1 '\n'
    jal ra print_char
    
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7 32(sp)
    lw s8 36(sp)
    lw s9 40(sp)
    addi sp sp 44

    ret
exit_59:
    li a1 59
    j exit2
