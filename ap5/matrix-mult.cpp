#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#define N 30

void define_matrix(int M[][N]);
void print_matrix(int M[][N]);
void parallel_mult(int A[][N], int B[][N], int M[][N]);
void serial_mult(int A[][N], int B[][N], int M[][N]);

int main() {
    omp_set_num_threads(omp_get_num_procs());
    double time;
    int even_cnt = 0;

    int A[N][N];
    int B[N][N];
    int C[N][N];

    define_matrix(A);
    define_matrix(B);

    // printf("Matriz A:\n");
    // print_matrix(A);

    // printf("\nMatriz B:\n");
    // print_matrix(B);

    time = omp_get_wtime();
    serial_mult(A, B, C);
    time = omp_get_wtime() - time;

    // printf("\nMatriz resultante em serie:\n");
    // print_matrix(C);
    printf("\nA duracao do calculo em serie eh: %f", time);

    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++) {
            if(C[i][j]%2 == 0) even_cnt++;
        }
    }
    printf("\nHa %d valores pares na matriz em serie\n", even_cnt);

    time = omp_get_wtime();
    parallel_mult(A, B, C);
    time = omp_get_wtime() - time;

    // printf("\nMatriz resultante em paralelo:\n");
    // print_matrix(C);
    printf("\nA duracao do calculo em paralelo eh: %f", time);

    even_cnt = 0;
    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++) {
            if(C[i][j]%2 == 0) even_cnt++;
        }
    }
    printf("\nHa %d valores pares na matriz em paralelo\n", even_cnt);

    return 0;
}

void define_matrix(int M[][N]) {
    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++) {
            M[i][j] = rand()%10;
        }
    }
}

void print_matrix(int M[][N]) {
    for(int i=0; i<N; i++) {
        printf("\t");
        for(int j=0; j<N; j++) {
            printf("%d ", M[i][j]);
        }
        printf("\n");
    }
}

void parallel_mult(int A[][N], int B[][N], int M[][N]) {
    // int i, j, k;
    #pragma omp parallel for
    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++) {
            M[i][j] = 0;
            for(int k=0; k<N; k++) {
                M[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

void serial_mult(int A[][N], int B[][N], int M[][N]) {
    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++) {
            M[i][j] = 0;
            for(int k=0; k<N; k++) {
                M[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}