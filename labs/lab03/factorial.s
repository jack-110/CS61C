.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    add t0, a0, x0
    beq t0, x0, exit
    addi a0, a0, -1
    addi sp, sp, -8
    sw t0, 0(sp)
    sw ra, 4(sp)
    jal factorial
    lw t0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    add t1, a0, x0
    mul a0, t0, t1
    jr ra
exit:
    addi a0, x0, 1
    add a1, x0, x0
    jr ra
