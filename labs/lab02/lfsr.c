#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

static uint16_t get_bit(uint16_t x, uint16_t n);
static void set_bit(uint16_t *x, uint16_t n, uint16_t v);


void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    
    uint16_t tmp;
    uint16_t value = *reg;

    tmp = get_bit(value, 0) ^ get_bit(value, 2) ^ get_bit(value, 3) ^ get_bit(value, 5);

    //shift one bit right
    value = value >> 1;
    *reg = value;

    set_bit(reg, 15, tmp);    
}

static uint16_t get_bit(uint16_t x, uint16_t n) {
    x = x >> n;
    return x & 1;    
}

static void set_bit(uint16_t *x, uint16_t n, uint16_t v) {
    uint16_t value = *x;
    uint16_t mask = 1 << n;

    if (v == 1) {
        value = value | mask;
    } else {
        mask = ~mask;
	value = value & mask;
    }

    *x = value;
}
