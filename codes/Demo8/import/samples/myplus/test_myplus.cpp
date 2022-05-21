#include <iostream>
#include "myplus.h"

int main(int argc, char *argv[])
{
    if (argc < 3){
        printf("Usage: %s a b \n", argv[0]);
        return -1;
    }
    double a = atof(argv[1]);
    double b = atof(argv[2]);
    double sum = myplus(a, b);
    std::cout << a << " + " << b << " is "  << sum << std::endl;
    return 0;
}
