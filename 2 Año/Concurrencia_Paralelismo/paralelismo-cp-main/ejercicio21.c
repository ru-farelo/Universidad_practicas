#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi/mpi.h>

void inicializaCadena(char *cadena, int n){
    int i;
    for(i=0; i<n/2; i++){
        cadena[i] = 'A';
    }
    for(i=n/2; i<3*n/4; i++){
        cadena[i] = 'C';
    }
    for(i=3*n/4; i<9*n/10; i++){
        cadena[i] = 'G';
    }
    for(i=9*n/10; i<n; i++){
        cadena[i] = 'T';
    }
}

int main(int argc, char *argv[])
{
    int i, n, count=0, rank, numprocs, totalCount=0;
    char *cadena;
    char L;


    if (argc != 3) {
        printf("Numero incorrecto de parametros\nLa sintaxis debe ser: program n L\n  program es el nombre del ejecutable\n  n es el tamaño de la cadena a generar\n  L es la letra de la que se quiere contar apariciones (A, C, G o T)\n");
        exit(1);
    }

    MPI_Init(&argc, &argv); // Inicializar el ambiente MPI
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs); // Obtener número de procesos
    MPI_Comm_rank(MPI_COMM_WORLD, &rank); // Obtener el rango del proceso actual

    if (rank == 0) { // Si es el proceso 0
        n = atoi(argv[1]);
        L = *argv[2];
    }

    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD); // Distribuir n a todos los procesos
    MPI_Bcast(&L, 1, MPI_CHAR, 0, MPI_COMM_WORLD); // Distribuir L a todos los procesos

    cadena = (char *) malloc(n*sizeof(char));
    inicializaCadena(cadena, n);

    // Reparto de la carga de trabajo en el bucle for con “paso” i+=numprocs en lugar de i++
    for (i = rank; i < n; i += numprocs) {
        if (cadena[i] == L) {
            count++;
        }
    }

    free(cadena);

    MPI_Reduce(&count, &totalCount, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD); // Recoger número de apariciones detectado por cada proceso

    if (rank == 0) {
        printf("El numero de apariciones de la letra %c es %d\n", L, totalCount);
    }

    MPI_Finalize(); // Finalizar el ambiente MPI
    exit(0);
}
