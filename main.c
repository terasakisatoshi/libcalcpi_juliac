#include <stdio.h>
#include <stdlib.h> // Include for atoi

double calcpi(int N);

int main(int argc, char *argv[]) {
    int N = 10000; // Default value

    // Check if a command-line argument is provided
    if (argc >= 2) {
        N = atoi(argv[1]); // Convert argument to integer
        if (N <= 0) {
            fprintf(stderr, "Please enter a valid positive integer.\n");
            return 1;
        }
    }

    double pi_approx = calcpi(N);
    printf("%.16f\n", pi_approx);

    return 0;
}
