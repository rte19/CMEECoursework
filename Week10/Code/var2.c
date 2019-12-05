#include <stdio.h>

int main (void)
{
    int a = 7; 
    int b = 2;
    float c = 0;
    int d = 0;

    c = 7/2;
    d = a/b;

    printf("Result of literal expression: %f\n", c);
    printf("Result of variable expression: %i\n", d);

    return 0;

}