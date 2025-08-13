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

int MPI_BinomialColectiva(void *buffer, int count, MPI_Datatype datatype, int root, MPI_Comm comm) {

    // Verificar que el proceso raíz sea el proceso 0
    if(root!=0)
        return MPI_ERR_OP;

    // Obtener el rango del proceso y el número de procesos en el comunicador
    int myrank=0,numprocs=0,comunication_dest=0;
    MPI_Comm_rank ( comm , & myrank );
    MPI_Comm_size ( MPI_COMM_WORLD , & numprocs );

    // Si el proceso actual no es el proceso raíz, recibir los datos del proceso raíz
    if(myrank!=0){
        MPI_Recv(buffer,count,datatype,MPI_ANY_SOURCE,root,comm,NULL);
    }

    // Enviar los datos a los demás procesos utilizando un algoritmo de broadcast binomial
    for(int i = 0;i<numprocs;i++){
        comunication_dest = pow(2,i);
        if(myrank>=comunication_dest)
            continue;
        comunication_dest+=myrank;
        if(comunication_dest>=numprocs)
            return MPI_ERR_OP;
        MPI_Send(buffer,count,datatype,comunication_dest,root,comm);
    }

    // Retornar el valor de éxito de MPI
    return MPI_SUCCESS;
}

// Función para realizar una operación de suma colectiva en un árbol plano
int MPI_FlattreeColectiva(const void *sendbuf, void *recvbuf, int count, MPI_Datatype datatype,
                          MPI_Op op, int root, MPI_Comm comm){

    // Se verifica que la operación sea de suma
    if (op != MPI_SUM)
        return MPI_ERR_OP;

    // Se verifica que el tipo de dato sea un entero
    if (datatype != MPI_INT)
        return MPI_ERR_OP;

    // Se verifica que el tamaño del mensaje sea 1
    if (count != 1)
        return MPI_ERR_OP;

    // Se obtiene el rango del proceso actual y el número total de procesos
    int myrank, numprocs;
    int* recvBufInt = (int*)recvbuf;
    MPI_Comm_rank(comm, &myrank);
    MPI_Comm_size(comm, &numprocs);

    // Si el proceso actual es el proceso raíz
    if (myrank == root) {
        int privateRecBuff = 0;
        // Se agrega el valor enviado por el proceso raíz al valor del buffer de recepción
        *recvBufInt+=*((int*)sendbuf);
        // Para cada proceso, excepto el proceso raíz
        for(int i =1; i<numprocs;i++){
            // Recibe el valor enviado por el proceso i
            MPI_Recv(&privateRecBuff,count,datatype,i,0,comm,NULL);
            // Agrega el valor recibido al valor del buffer de recepción
            *recvBufInt+=privateRecBuff;
        }
    } else {
        // Si el proceso actual no es el proceso raíz, envía su valor al proceso raíz
        MPI_Send(sendbuf, count, datatype, root,0,comm);
    }

    // Devuelve MPI_SUCCESS para indicar que la operación ha sido realizada con éxito
    return MPI_SUCCESS;
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


    MPI_BinomialColectiva(&n, 1, MPI_INT, 0, MPI_COMM_WORLD); // Recibir n de proceso 0
    MPI_BinomialColectiva(&L, 1, MPI_CHAR, 0, MPI_COMM_WORLD); // Recibir L de proceso 0

    cadena = (char *) malloc(n*sizeof(char));
    inicializaCadena(cadena, n);

    // Reparto de la carga de trabajo en el bucle for con “paso” i+=numprocs en lugar de i++
    for (i = rank; i < n; i += numprocs) {
        if (cadena[i] == L) {
            count++;
        }
    }


    free(cadena);

    MPI_FlattreeColectiva(&count, &totalCount, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD); // Recoger número de apariciones detectado por cada proceso

    if (rank == 0) {
        printf("El numero de apariciones de la letra %c es %d\n", L, totalCount);
    }

    MPI_Finalize(); // Finalizar el ambiente MPI
    exit(0);
}


