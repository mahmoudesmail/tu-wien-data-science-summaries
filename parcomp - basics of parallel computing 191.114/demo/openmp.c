// install: https://stackoverflow.com/a/29109926/13045051
// $ gcc-13 -fopenmp -o ./demo/openmp ./demo/openmp.c && ./demo/openmp && rm -rf ./demo/openmp

#include <stdio.h>
#include <omp.h>
#include <stdlib.h>


int main(int argc, char *argv[]) {
    int n_threads = omp_get_num_procs();
    n_threads = 4;

    #pragma omp parallel num_threads(n_threads)
    {
        printf("child id: %d\n", omp_get_thread_num());
    }
}
