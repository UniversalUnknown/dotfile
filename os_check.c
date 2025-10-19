#include <stdio.h>
#include <stdlib.h>

int main() {
    #ifdef _WIN32
        printf("Operating System: Windows\n");
    #elif __linux__
        printf("Operating System: Linux\n");
    #elif __APPLE__
        printf("Operating System: macOS\n");
    #else
        printf("Operating System: Unknown\n");
    #endif

    return 0;
}
