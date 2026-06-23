#include <stdio.h>
#include <omp.h>
int main() {
    #pragma omp parallel
    {
        printf("Thread %d → CPU %d\n", omp_get_thread_num(), sched_getcpu());
    }
}

