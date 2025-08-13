/*AUTORES:
---------------------------------------------------------------------------
Rubén Fernández Farelo	| ruben.fernandez.farelo@udc.es
Lucía Costa López	| lucia.costa.lopez@udc.es
---------------------------------------------------------------------------
GRUPO DE PRÁCTICAS 3.2
---------------------------------------------------------------------------
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <stdbool.h>
#include <sys/time.h>

#define TAM_MAX 1000

typedef int **matriz;

typedef struct {
    char *nombre;
    double (*f)(int, double);
} Cota;

typedef struct {
    char *nombre;
    void (*f)(matriz m, int n, int *minimo);
    Cota cota_inferior;
    Cota cota_acotada;
    Cota cota_superior;
} Algoritmo;


double microsegundos();
oid print_matrix(matriz m, int n);
matriz crear_matriz(int n);
void inicializar_matriz(matriz m, int n);
void liberar_matriz(matriz m, int n);
void dijkstra(matriz grafo, matriz distancias, int tam);
void test();
void tiempos_dijkstra(int n, void (*inicializacion)(matriz, int), void (*algoritmo)(matriz, matriz, int));
void mostrar_tablas_dijkstra();

double microsegundos() {
    struct timeval time;
    if (gettimeofday(&time, NULL) < 0) {
        return 0.0;
    }
    return (time.tv_usec + time.tv_sec * 1000000.0);
}

void print_matrix(matriz m, int n) {
    int i, j;
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            printf("%d ", m[i][j]);
        }
        printf("\n");
    }
}

matriz crear_matriz(int n) {
    int i;
    matriz aux;
    if ((aux = malloc(n * sizeof(int *))) == NULL)
        return NULL;
    for (i = 0; i < n; i++)
        if ((aux[i] = malloc(n * sizeof(int))) == NULL)
            return NULL;
    return aux;
}

void inicializar_matriz(matriz m, int n) {
    int i, j;
    for (i = 0; i < n; i++)
        for (j = i + 1; j < n; j++)
            m[i][j] = rand() % TAM_MAX + 1;
    for (i = 0; i < n; i++)
        for (j = 0; j <= i; j++)
            m[i][j] = (i == j) ? 0 : m[j][i];
}

void liberar_matriz(matriz m, int n) {
    int i;
    for (i = 0; i < n; i++)
        free(m[i]);
    free(m);
}

void dijkstra(matriz grafo, matriz distancias, int tam) {
    int n, i, j, min;
    int *noVisitados = malloc(tam * sizeof(int));

    for (n = 0; n < tam; n++) {
        for (i = 0; i < tam; i++) {
            noVisitados[i] = 1;
            distancias[n][i] = grafo[n][i];
        }
        noVisitados[n] = 0;

        for (i = 0; i < tam - 2; i++) { 
            min = -1;
            for (j = 0; j < tam; j++) {
                if (noVisitados[j] && (min == -1 || distancias[n][j] < distancias[n][min])) {
                    min = j;
                }
            }

            noVisitados[min] = 0;

            for (int w = 0; w < tam; w++) {
                if (noVisitados[w] && distancias[n][w] > distancias[n][min] + grafo[min][w]) {
                    distancias[n][w] = distancias[n][min] + grafo[min][w];
                }
            }
        }
    }

    free(noVisitados);
}

void test() {
    srand(time(NULL));

    int tamA = 5;
    matriz grafoA = crear_matriz(tamA);
    matriz distanciasA = crear_matriz(tamA);

    int ejemplo_grafoA[5][5] = {
        {0, 1, 8, 4, 7},
        {1, 0, 2, 6, 5},
        {8, 2, 0, 9, 5},
        {4, 6, 9, 0, 3},
        {7, 5, 5, 3, 0}
    };

    for (int i = 0; i < tamA; i++) {
        for (int j = 0; j < tamA; j++) {
            grafoA[i][j] = ejemplo_grafoA[i][j];
        }
    }

    printf("Grafo A:\n");
    printf("Matriz de adyacencia:\n");
    print_matrix(grafoA, tamA);

    dijkstra(grafoA, distanciasA, tamA);

    printf("\nDistancias mínimas:\n");
    print_matrix(distanciasA, tamA);

    liberar_matriz(grafoA, tamA);
    liberar_matriz(distanciasA, tamA);

    int tamB = 4;
    matriz grafoB = crear_matriz(tamB);
    matriz distanciasB = crear_matriz(tamB);

    int ejemplo_grafoB[4][4] = {
        {0, 1, 4, 7},
        {1, 0, 2, 8},
        {4, 2, 0, 3},
        {7, 8, 3, 0}
    };

    for (int i = 0; i < tamB; i++) {
        for (int j = 0; j < tamB; j++) {
            grafoB[i][j] = ejemplo_grafoB[i][j];
        }
    }

    printf("\nGrafo B:\n");
    printf("Matriz de adyacencia:\n");
    print_matrix(grafoB, tamB);

    dijkstra(grafoB, distanciasB, tamB);

    printf("\nDistancias mínimas:\n");
    print_matrix(distanciasB, tamB);

    liberar_matriz(grafoB, tamB);
    liberar_matriz(distanciasB, tamB);
}



void tiempos_dijkstra(int n, void (*inicializacion)(matriz, int), void (*algoritmo)(matriz, matriz, int)) {
    matriz grafo = crear_matriz(n);
    matriz distancias = crear_matriz(n);

    double ta, tb, t;

    inicializacion(grafo, n);

    ta = microsegundos();

    algoritmo(grafo, distancias, n);

    tb = microsegundos();

    t = tb - ta;

    if (t < 500) {
        int k;
        ta = microsegundos();
        for (k = 0; k < 1000; k++) {
            inicializacion(grafo, n);
            algoritmo(grafo, distancias, n);
        }
        tb = microsegundos();
        t = tb - ta;
        ta = microsegundos();
        for (k = 0; k < 1000; k++) {
            inicializacion(grafo, n);
        }
        tb = microsegundos();
        t = (t - (tb - ta)) / k;
        printf("*");
    } else {
        printf(" ");
    }

    double cota_inf = t / pow(n, 2.6);
    double cota_acot = t / pow(n, 2.9);
    double cota_sup = t / pow(n, 3.2);

    printf("\t%10d    \t%14.5f    \t%11.9f    \t%11.9f    \t%11.10f\n", n, t, cota_inf, cota_acot, cota_sup);


    liberar_matriz(grafo, n);
    liberar_matriz(distancias, n);
}


void mostrar_tablas_dijkstra() {
    int i;

    printf("\nMedicion tiempos Dijkstra\n\n");
    printf("%18s%14s%25s%14s%20s\n", "n", "t", "t/n^2.6", "t/n^2.9", "t/n^3.2\n");

    for (i = 15; i <= 960; i = i * 2) {
        tiempos_dijkstra(i, inicializar_matriz, dijkstra);
    }

    printf("\n");
}

int main() {
    int i;
    test();
    for(i=1;i<=3;i++)
    mostrar_tablas_dijkstra();
    
    return 0;
}
