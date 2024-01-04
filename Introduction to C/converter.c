
#include <stdio.h>
#include <stdlib.h>

int main(int argc,  char * argv[]) {
    
    if (argc==1)
        printf("You should have entered a number\n");
    else
        printf("%dF converts to %.1fC\n",atoi(argv[1]), (atoi(argv[1])-32)*5.0/9);
    return 0;
}
