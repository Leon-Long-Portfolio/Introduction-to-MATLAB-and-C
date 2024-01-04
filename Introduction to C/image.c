
#include <stdio.h>

int main(int argc, const char * argv[])
{
    printf("Hello, World!\n");
    
    if (argc==1)
        printf("You should have entered a string\n");
    else
        printf("%s %s\n", argv[1], argv[1]);
    return 0;
}
