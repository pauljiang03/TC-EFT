/* Independent reference runner linked to an unmodified, pinned Berkeley SoftFloat.
 * Protocol: operation width target mode tininess a b c (unsigned decimal words).
 * Modes: 0 nearest-even, 1 toward-zero, 2 down, 3 up. Tininess: 0 before, 1 after.
 */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "softfloat.h"

static uint64_t same_format(unsigned width, uint64_t a) {
    unsigned p = width == 16 ? 10 : width == 32 ? 23 : 52;
    unsigned e = width == 16 ? 5 : width == 32 ? 8 : 11;
    uint64_t frac = a & ((UINT64_C(1) << p) - 1);
    uint64_t quiet = UINT64_C(1) << (p - 1);
    if (((a >> p) & ((UINT64_C(1) << e) - 1)) == ((UINT64_C(1) << e) - 1) && frac) {
        if (!(frac & quiet)) softfloat_exceptionFlags = softfloat_flag_invalid;
        return a | quiet;
    }
    return a;
}

int main(void) {
    char op[16]; unsigned width, target, mode, tiny;
    uint64_t a, b, c;
    while (scanf("%15s %u %u %u %u %" SCNu64 " %" SCNu64 " %" SCNu64,
                 op, &width, &target, &mode, &tiny, &a, &b, &c) == 8) {
        softfloat_roundingMode = (uint_fast8_t)mode;
        softfloat_detectTininess = (uint_fast8_t)tiny;
        softfloat_exceptionFlags = 0;
        uint64_t z = 0;
        if (strcmp(op, "convert") == 0 && width == target) z = same_format(width, a);
        else if (width == 16) {
            float16_t x = {(uint16_t)a}, y = {(uint16_t)b}, v = {(uint16_t)c};
            if (strcmp(op, "add") == 0) z = f16_add(x, y).v;
            else if (strcmp(op, "sub") == 0) z = f16_sub(x, y).v;
            else if (strcmp(op, "mul") == 0) z = f16_mul(x, y).v;
            else if (strcmp(op, "fma") == 0) z = f16_mulAdd(x, y, v).v;
            else if (target == 32) z = f16_to_f32(x).v;
            else z = f16_to_f64(x).v;
        } else if (width == 32) {
            float32_t x = {(uint32_t)a}, y = {(uint32_t)b}, v = {(uint32_t)c};
            if (strcmp(op, "add") == 0) z = f32_add(x, y).v;
            else if (strcmp(op, "sub") == 0) z = f32_sub(x, y).v;
            else if (strcmp(op, "mul") == 0) z = f32_mul(x, y).v;
            else if (strcmp(op, "fma") == 0) z = f32_mulAdd(x, y, v).v;
            else if (target == 16) z = f32_to_f16(x).v;
            else z = f32_to_f64(x).v;
        } else if (width == 64) {
            float64_t x = {a}, y = {b}, v = {c};
            if (strcmp(op, "add") == 0) z = f64_add(x, y).v;
            else if (strcmp(op, "sub") == 0) z = f64_sub(x, y).v;
            else if (strcmp(op, "mul") == 0) z = f64_mul(x, y).v;
            else if (strcmp(op, "fma") == 0) z = f64_mulAdd(x, y, v).v;
            else if (target == 16) z = f64_to_f16(x).v;
            else z = f64_to_f32(x).v;
        } else return 2;
        printf("%" PRIu64 " %u\n", z, (unsigned)softfloat_exceptionFlags);
    }
    return feof(stdin) ? 0 : 2;
}
