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

int MPI_BinomialColectiva(void *buffer, int count, MPI_Datatype datatype, int root,
                          MPI_Comm comm ){
    if(root!=0)
        return MPI_ERR_OP;
    int myrank=0,numprocs=0,comunication_dest=0;
    MPI_Comm_rank ( comm , & myrank );
    MPI_Comm_size ( comm , & numprocs );
    if(myrank!=0){
        MPI_Recv(buffer,count,datatype,MPI_ANY_SOURCE,root,comm,NULL);
    }
    for(int i = 0;i<numprocs;i++){
        comunication_dest = pow(2,i);
        if(myrank>=comunication_dest)
            continue;
        comunication_dest+=myrank;
        if(comunication_dest>=numprocs)
            return MPI_SUCCESS;
        MPI_Send(buffer,count,datatype,comunication_dest,root,comm);
    }
    return MPI_SUCCESS;
}

int MPI_BinomialBcast(void *buffer, int count, MPI_Datatype datatype, int root, MPI_Comm comm) {
    if(root!=0)
        return MPI_ERR_OP;
    int myrank=0,numprocs=0,comunication_dest=0;
    MPI_Comm_rank ( comm , & myrank );
    MPI_Comm_size ( MPI_COMM_WORLD , & numprocs ); // 3. get number of processes
    if(myrank!=0){
        MPI_Recv(buffer,count,datatype,MPI_ANY_SOURCE,root,comm,NULL);
    }
    for(int i = 0;i<numprocs;i++){
        comunication_dest = pow(2,i);
        if(myrank>=comunication_dest)
            continue;
        comunication_dest+=myrank;
        if(comunication_dest>=numprocs)
            return MPI_ERR_OP;
        MPI_Send(buffer,count,datatype,comunication_dest,root,comm);
    }
    return MPI_SUCCESS;

}

int MPI_FlattreeColectiva(const void *sendbuf, void *recvbuf, int count, MPI_Datatype datatype,
                          MPI_Op op, int root, MPI_Comm comm){
    if (op != MPI_SUM)
        return MPI_ERR_OP;
    if (datatype != MPI_INT)
        return MPI_ERR_OP;
    if (count != 1)
        return MPI_ERR_OP;

    int myrank, numprocs;
    int* recvBufInt = (int*)recvbuf;
    MPI_Comm_rank(comm, &myrank);
    MPI_Comm_size(comm, &numprocs);

    if (myrank == root) {
        int privateRecBuff = 0;
        *recvBufInt+=*((int*)sendbuf);
        for(int i =1; i<numprocs;i++){
            MPI_Recv(&privateRecBuff,count,datatype,i,0,comm,NULL);
            *recvBufInt+=privateRecBuff;
        }
    } else {
        MPI_Send(sendbuf, count, datatype, root,0,comm);
    }

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


    MPI_BinomialBcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD); // Recibir n de proceso 0
    MPI_BinomialBcast(&L, 1, MPI_CHAR, 0, MPI_COMM_WORLD); // Recibir L de proceso 0

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


