#include <stdio.h>

int main (void)
{
    int a = 7;
    int b = 2;
    int c = 0;

    c = a + 3;
    printf("a + 3 = %i\n", c);
    printf("a + 3 = %i\n", a + 3);
    printf("a multiplied by b: %i\n", a * b);
    printf("BODMAS! %i\n", a * (b + 3)/2);
    printf("Modulus of a and b: %i\n", a % b);

    return 0;    
}