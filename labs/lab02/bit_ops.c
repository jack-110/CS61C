#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    x = x >> n; 
    return x & 1;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    unsigned value = *x;
    unsigned mask = 1 << n;

    if (v == 1) {
	value = value | mask;
    } else {
        mask = ~ mask;
	value = value & mask;
    }

    *x = value;
}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    unsigned mask = 1 << n;
    
    unsigned value = *x;
    value = value ^ mask;
    *x = value;
}

