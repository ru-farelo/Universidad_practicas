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
    int i, n, count=0, rank, numprocs;
    char *cadena;
    char L;

    if(argc != 3){
        printf("Numero incorrecto de parametros\nLa sintaxis debe ser: program n L\n  program es el nombre del ejecutable\n  n es el tamaño de la cadena a generar\n  L es la letra de la que se quiere contar apariciones (A, C, G o T)\n");
        exit(1);
    }


    MPI_Init(&argc, &argv); // Inicializar entorno MPI
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs); // Obtener número de procesos
    MPI_Comm_rank(MPI_COMM_WORLD, &rank); // Obtener rango del proceso

    if (rank == 0) { // Proceso 0 se encarga de la entrada y salida
        n = atoi(argv[1]);
        L = *argv[2];
        for (i = 1; i < numprocs; i++) {
            MPI_Send(&n, 1, MPI_INT, i, 0, MPI_COMM_WORLD); // Enviar n a los procesos
            MPI_Send(&L, 1, MPI_CHAR, i, 0, MPI_COMM_WORLD); // Enviar L a los procesos
        }
    } else { // El resto de los procesos reciben n y L
        MPI_Recv(&n, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        MPI_Recv(&L, 1, MPI_CHAR, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }

    cadena = (char *) malloc(n * sizeof(char));
    inicializaCadena(cadena, n);

    for (i = rank; i < n; i += numprocs) { // Reparto de carga de trabajo
        if (cadena[i] == L) {
            count++;
        }
    }

    free(cadena);

    if (rank == 0) { // Proceso 0 recibe resultados y los suma
        int recBuff = 0;
        for (i = 1; i < numprocs; i++) {
            MPI_Recv(&recBuff, 1, MPI_INT, i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE); // Recibir el recuento de los procesos
            count += recBuff;
        }
        printf("El numero de apariciones de la letra %c es %d\n", L, count); // Imprimir el resultado
    } else { // El resto de los procesos envían su recuento al proceso 0
        MPI_Send(&count, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
    }

    MPI_Finalize(); // Finalizar entorno MPI
    exit(0);
}
