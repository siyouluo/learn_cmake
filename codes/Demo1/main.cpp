#include <iostream>

/**
 * my_power - Calculate the power of number.
 * @param base: Base value.
 * @param exponent: Exponent value.
 *
 * @return base raised to the power exponent.
 */
double my_power(double base, int exponent)
{
    int result = base;
    int i;

    if (exponent == 0) {
        return 1;
    }
    
    for(i = 1; i < exponent; ++i){
        result = result * base;
    }

    return result;
}

int main(int argc, char *argv[])
{
    if (argc < 3){
        printf("Usage: %s base exponent \n", argv[0]);
        return -1;
    }
    double base = atof(argv[1]);
    int exponent = atoi(argv[2]);
    double result = my_power(base, exponent);
    std::cout << base << " ^ " << exponent << " is "  << result << std::endl;
    return 0;
}