.import ../../src/matmul.s
.import ../../src/utils.s
.import ../../src/dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 9
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la s0 m0
    la s1 m1
    la s2 d 
   
    mv a0 s0
    li a1 3
    li a2 3
    mv a3 s1
    li a4 3
    li a5 3
    mv a6 s2


    # Call matrix multiply, m0 * m1
    jal ra matmul


    # Print the output (use print_int_array in utils.s)
    mv a0 a6
    li a1 3
    li a2 3
    jal ra print_int_array


    # Exit the program
    jal exit
