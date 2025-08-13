#include <stdio.h>
#include <stdbool.h>
#include <math.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

void ord_shell (int v [], int n);
void ord_ins (int v [], int n);
void print_vector (int v[], int n);
void inicializar_semilla();
void aleatorio(int v [], int n);
void ascendente(int v [], int n);
void descendente(int v[], int n);
bool ordenada(int v[], int n);
double microsegundos();


//algoritmo ordenacion por insercion

void ord_shell (int v [], int n){
  int incremento = n,tmp,j,i;
  bool seguir;
  do{
    incremento = incremento /2;
    for(i = (incremento);i < n; i++){
      tmp = v[i];
      j = i;
      seguir = true;
      while ((j-incremento) >= 0 && ( seguir == true )){
        if(tmp < v[j-incremento]){
          v[j] = v[j-incremento];
          j -= incremento;
        }else
          seguir = false;
      }
      v[j] = tmp;
     }
  } while(incremento != 1);       
}

void ord_ins (int v [], int n){
    int i, j, x;
    for(i =1; i<n ; i++){
        x = v[i];
        j = i-1;
        while (j>=0 && v[j]>x){
            v[j+1] = v[j];
            j = j-1;
        }
        v[j+1]= x;        
    }
}


void print_vector  (int v[], int n){ //Imprime el vector por pantalla
    int i;
     for(i =0; i<n; i++){
        printf ("%d  ", v[i]);
    }
}


void inicializar_semilla(){ //Inicializa la semilla 
    srand(time(NULL));
}

void aleatorio(int v [], int n) { //Rellena un vector con numeros
                                    // pseudoaleatorios entre -n y +n
    int i; 
    int m=2*n+1;
    for (i=0; i < n; i++){
        v[i] = (rand() % m) - n;
    }
}


void ascendente(int v [], int n) { //Rellena un vector con numeros 
                                //oredenados de forma ascendente de 0 a n-1
    int i;
    for (i=0; i < n; i++){
        v[i] = i;
    }
}

void descendente(int v[], int n){ //Rellena un vector con numeros 
                                    //ordenados de forma descendente de n a 1
    int i;
    for (i = n; i>0; i--){
        v[n-i]=i;
    }
}

bool ordenada (int v[], int n){ //Comprueba si el vector esta ordenado
    int i;
    int x = v[0];

    for(i = 0; i < n; i++){
        if(v[i] < x){
            return false;
        }
        x = v[i];
    }
    return true;
}

double microsegundos(){  //obtenemos la hora actual (en microsegundos)

    struct timeval time;
    if(gettimeofday(&time, NULL)<0){
        return 0.0;
    }return (time.tv_usec + time.tv_sec * 1000000.0);

}

void test (){
    int i, j,n=15,v[n];
    char* sortNames [] = {"por Inserción", "shell"};
    char* vNames [] = {"aleatoria", "descendente", "ascendente"};

    void (*initialize[3]) (int[], int) = {aleatorio, descendente, ascendente};

    void (*sort[2]) (int[], int) = {ord_ins, ord_shell};

    printf("\nTEST PARA COMPROBAR EL CORRECTO FUNCIONAMIENTO DE LOS ALGORITMOS\n");

    for (i = 0; i < 2 ; i++) {

        for (j = 0; j < 3 ; j++) {

            printf("\nInicialización %s\n", vNames[j]);
            initialize[j](v, n);
            print_vector (v, n);

            printf("%s\n", ordenada(v, n)? "\tEl vector está ordenado": 
            "\tEl vector no está ordenado");

            printf("\nOrdenación %s\n", sortNames[i]);
            sort[i](v, n);
            print_vector (v, n);

            printf("%s\n", ordenada(v, n)? "\tEl vector está ordenado":
             "\tEl vector no está ordenado");
             
            printf("\n");
        }
    }
    printf("\nFIN DEL TEST\n\n");   
}

//INSERCION
void tiempo_insAleatorio (int tamano_maximo){//Calcula cuanto tarda la ordenacion
                        // por insercion con inicializacion aleatoria
    double t1, t2, t, ta, tb;
    double c_sub, c_aj, c_sobr;
    int k, n,v[tamano_maximo];

    printf("\nORDENACION POR INSERCION *****inicializacion aleatoria*****\n");
	printf("%19s%24s%28s%23s%24s%23s\n","n","t(n)","t(n)/n^1.8","t(n)/n^2","t(n)/n^2.2","k\n");
     
    for(n = 500; n < 64000; n = n*2){
        aleatorio(v, n);
        t1= microsegundos();
        ord_ins(v, n);
        t2= microsegundos();
        t = t2 - t1;

        if(t < 500){ //si el tiempo es menor de 500 microsegundos,
                        // hace la media de repetirlo k veces
            t1 = microsegundos();
            for(k = 0; k < 1000; k++){
                aleatorio(v, n);
                ord_ins(v,n);
            }
            t2= microsegundos();
            ta= microsegundos();
            for (k = 0; k < 1000; k++){
                aleatorio(v, n);
            }
            tb = microsegundos();
        
            t= ((t2-t1) - (tb-ta))/ k;
        }
        c_sub = t/pow((double)n, 1.8); //cota subestimada 
        c_aj = t/pow((double)n, 2);  //cota ajustada
        c_sobr = t/ pow((double)n,2.2);  //cota sobreestimada

        printf("\t%12d    \t%15.6f    \t%15.6f    \t%15.9f    \t%15.10f    \t%12d\n", 
        n, t, c_sub, c_aj, c_sobr, t<500? k: 1);  
    }
}


void tiempo_insAscendente (int tamano_maximo){//Calcula cuanto tarda la ordenacion
                                // por insercion con inicializacion ascendente
    double t1, t2, t, ta, tb,c_sub, c_aj, c_sobr;
    int k,n,v[tamano_maximo];

    printf("\nORDENACION POR INSERCION *****inicializacion ascendente*****\n");
    printf("%19s%24s%28s%23s%24s%23s\n","n","t(n)","t(n)/n^0.8","t(n)/n^1","t(n)/n^1.3","k\n");
     
    for(n = 500; n <= 64000; n = n*2){
        ascendente(v, n);
        t1= microsegundos();
        ord_ins(v, n);
        t2= microsegundos();
        t = t2 - t1;

        if(t < 500){ //si el tiempo es menor de 500 microsegundos,
                    // hace la media de repetirlo k veces
            t1 = microsegundos();
            for(k = 0; k < 1000; k++){
                ascendente(v, n);
                ord_ins(v,n);
            
            }
            t2= microsegundos();
            ta=microsegundos();
            for (k = 0; k < 1000; k++){
                ascendente(v, n);
            }
            tb = microsegundos();
           
            t= ((t2-t1) - (tb-ta))/ k;
            
        }
        c_sub = t/pow((double)n, 0.8);//cota subestimada 
        c_aj = t/pow((double)n, 1);  //cota ajustada
        c_sobr = t/ pow((double)n,1.3);  //cota sobreestimada

        printf("\t%12d    \t%15.6f    \t%15.6f    \t%15.9f    \t%15.10f    \t%12d\n", 
        n, t, c_sub, c_aj, c_sobr, t<500? k: 1); 
    }  
}


void tiempo_insDescendente (int tamano_maximo){  //Calcula cuanto tarda la ordenacion
                            // por insercion con inicializacion descendente
    double t1, t2, t, ta, tb, c_sub, c_aj, c_sobr;
    int k, n,v[tamano_maximo];
    
    printf("\nORDENACION POR INSERCION *****inicializacion descendente*****\n");
    printf("%19s%24s%28s%23s%24s%23s\n","n","t(n)","t(n)/n^1.8","t(n)/n^2","t(n)/n^2.2","k\n");     
    for(n = 500; n < 64000; n = n*2){
        descendente(v, n);
        t1= microsegundos();
        ord_ins(v, n);
        t2= microsegundos();
        t = t2 - t1;

        if(t < 500){  //se hace la media de repetirlo k veces
            t1 = microsegundos();
            for(k = 0; k < 1000; k++){
                descendente(v, n);
                ord_ins(v,n);
            }
            t2= microsegundos();

            ta=microsegundos();
            for (k = 0; k < 1000; k++){
                descendente(v, n);
            }
            tb = microsegundos();
        
            t= ((t2-t1) - (tb-ta))/ k;
        }
        c_sub = t/pow((double)n, 1.8); //cota subestimada 
        c_aj = t/pow((double)n, 2);  //cota ajustada
        c_sobr = t/ pow((double)n,2.2);  //cota sobreestimada

        printf("\t%12d    \t%15.6f    \t%15.6f    \t%15.9f    \t%15.10f    \t%12d\n",
         n, t, c_sub, c_aj, c_sobr, t<500? k: 1); 
    }
}

//SHELL

void tiempo_shellAleatorio (int tamano_maximo){//Calcula cuanto tarda la ordenacion
                        // por insercion con inicializacion aleatoria
    double t1, t2, t, ta, tb;
    double c_sub, c_aj, c_sobr;
    int k, n,v[tamano_maximo];

    printf("\nORDENACION POR SHELL *****inicializacion aleatoria*****\n");
    printf("%19s%24s%28s%23s%24s%23s\n","n","t(n)","t(n)/n^0.9","t(n)/n^1.1","t(n)/n^1.4","k\n");
     
    for(n = 500; n < 64000; n = n*2){
        aleatorio(v, n);
        t1= microsegundos();
        ord_shell(v, n);
        t2= microsegundos();
        t = t2 - t1;

        if(t < 500){ //si el tiempo es menor de 500 microsegundos,
                        // hace la media de repetirlo k veces
            t1 = microsegundos();
            for(k = 0; k < 1000; k++){
                aleatorio(v, n);
                ord_shell(v,n);
            }
            t2= microsegundos();
            ta= microsegundos();
            for (k = 0; k < 1000; k++){
                aleatorio(v, n);
            }
            tb = microsegundos();
        
            t= ((t2-t1) - (tb-ta))/ k;
        }
        c_sub = t/pow((double)n, 0.9); //cota subestimada 
        c_aj = t/pow((double)n, 1.1);  //cota ajustada
        c_sobr = t/ pow((double)n,1.4);  //cota sobreestimada

        printf("\t%12d    \t%15.6f    \t%15.6f    \t%15.9f    \t%15.10f    \t%12d\n", 
        n, t, c_sub, c_aj, c_sobr, t<500? k: 1);  
    }
}


void tiempo_shellAscendente (int tamano_maximo){//Calcula cuanto tarda la ordenacion
                                // por insercion con inicializacion ascendente
    double t1, t2, t, ta, tb,c_sub, c_aj, c_sobr;
    int k,n,v[tamano_maximo];

    printf("\nORDENACION POR SHELL *****inicializacion ascendente*****\n");
    printf("%19s%24s%28s%23s%24s%23s\n","n","t(n)","t(n)/n^0.9","t(n)/n^1.1","t(n)/n^1.4","k\n");
     
    for(n = 500; n <= 64000; n = n*2){
        ascendente(v, n);
        t1= microsegundos();
        ord_shell(v, n);
        t2= microsegundos();
        t = t2 - t1;

        if(t < 500){ //si el tiempo es menor de 500 microsegundos,
                    // hace la media de repetirlo k veces
            t1 = microsegundos();
            for(k = 0; k < 1000; k++){
                ascendente(v, n);
                ord_shell(v,n);
            
            }
            t2= microsegundos();
            ta=microsegundos();
            for (k = 0; k < 1000; k++){
                ascendente(v, n);
            }
            tb = microsegundos();
           
            t= ((t2-t1) - (tb-ta))/ k;
            
        }
        c_sub = t/pow((double)n, 0.9);//cota subestimada 
        c_aj = t/pow((double)n, 1.1);  //cota ajustada
        c_sobr = t/ pow((double)n,1.4);  //cota sobreestimada

        printf("\t%12d    \t%15.6f    \t%15.6f    \t%15.9f    \t%15.10f    \t%12d\n", 
        n, t, c_sub, c_aj, c_sobr, t<500? k: 1); 
    }  
}


void tiempo_shellDescendente (int tamano_maximo){  //Calcula cuanto tarda la ordenacion
                            // por insercion con inicializacion descendente
    double t1, t2, t, ta, tb, c_sub, c_aj, c_sobr;
    int k, n,v[tamano_maximo];
    
    printf("\nORDENACION POR SHELL *****inicializacion descendente*****\n");
    printf("%19s%24s%28s%23s%24s%23s\n","n","t(n)","t(n)/n^1","t(n)/n^1.2","t(n)/n^1.4","k\n");
     
    for(n = 500; n < 64000; n = n*2){
        descendente(v, n);
        t1= microsegundos();
        ord_shell(v, n);
        t2= microsegundos();
        t = t2 - t1;

        if(t < 500){  //se hace la media de repetirlo k veces
            t1 = microsegundos();
            for(k = 0; k < 1000; k++){
                descendente(v, n);
                ord_shell(v,n);
            }
            t2= microsegundos();

            ta=microsegundos();
            for (k = 0; k < 1000; k++){
                descendente(v, n);
            }
            tb = microsegundos();
        
            t= ((t2-t1) - (tb-ta))/ k;
        }
        c_sub = t/pow((double)n, 1); //cota subestimada 
        c_aj = t/pow((double)n, 1.2);  //cota ajustada
        c_sobr = t/ pow((double)n,1.4);  //cota sobreestimada

        printf("\t%12d    \t%15.6f    \t%15.6f    \t%15.9f    \t%15.10f    \t%12d\n",
         n, t, c_sub, c_aj, c_sobr, t<500? k: 1); 
    }
}


int main (){
    int tamano_maximo = 64000;

    inicializar_semilla();
    test();

    for(int i = 0; i < 1; i++){
        tiempo_insAleatorio(tamano_maximo);
    }
    

    for(int i = 0; i < 1; i++){
        tiempo_insAscendente(tamano_maximo);
    }

    for(int i = 0; i < 1; i++){
        tiempo_insDescendente(tamano_maximo);
    }  

   
    for(int i = 0; i < 1; i++){
        tiempo_shellAscendente(tamano_maximo);
    }

    for(int i = 0; i < 1; i++){
        tiempo_shellDescendente(tamano_maximo);
    }

    for(int i = 0; i < 1; i++){
        tiempo_shellAleatorio(tamano_maximo);
    }  
}
