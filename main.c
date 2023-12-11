#include <stdio.h>
#include "add.h"

#ifndef A
#define A   1
#endif // A
#ifndef B
#define B   3
#endif // B

int main(void)
{
    printf("Hello world, %d + %d = %d\n", A, B, add(A, B));
    return 0;
}
