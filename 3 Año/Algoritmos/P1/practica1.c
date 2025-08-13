#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <sys/time.h>

void inicializar_semilla(){
	srand(time(NULL));
}

void aleatorio(int v[], int n){
	int i, m=2*n+1;
	for (i=0;i<n;i++){
		v[i] = (rand() % m) - n;
	}
}

double tiempo_actual(){  //obtenemos la hora actual (en microsegundos)
	struct timeval time;
	if(gettimeofday(&time, NULL)<0){
		return 0.0;
	}
	return (time.tv_usec + time.tv_sec * 1000000.0);
}

int sumaSubMax1(int v[],int n){
	int sumaMax=0, estaSuma=0;
	int i,j;

	for (i = 0; i < n; i++) {
		estaSuma=0;
		
		for (j = i; j < n; j++) {
			estaSuma=estaSuma+v[j];
			
			if (estaSuma>sumaMax)
				sumaMax=estaSuma;
		}
	}
	return sumaMax;
}

int sumaSubMax2 (int v[], int n){
	int i, estaSuma =0 , sumaMax =0;	
	for (i = 0; i<n; i++){
		estaSuma = estaSuma + v[i];
		
		if (estaSuma > sumaMax){
			sumaMax = estaSuma;
		}else if (estaSuma < 0){
			estaSuma = 0;
		}
	}
	return sumaMax;
}

void listar_vector (int v[], int n){
	int i;
	printf("[");	
	for (i=0; i<n;i++){
		printf("%3d", v[i]);
	}
	printf("]");
}

void medirsumaSubMax1(int v[]){
	double t1, t2, t;
	double c_sub, c_aj, c_sobr;
	int k;
	int n;
	printf("\nsumaSubMax1\n");
	printf("%14s%20s%20s%20s%20s\n","n","t(n)","t(n)/n^1.8","t()n/n^2","t(n)/n^2.2\n");
   
	for(n=500; n<=32000; n=2*n){ 
		t1= tiempo_actual();
		sumaSubMax1(v,n);
		t2= tiempo_actual();
		t=t2-t1;
		
		if(t<500){
			t1= tiempo_actual();
			for(k=0; k<1000; k++){
				sumaSubMax1(v,n);
			}
			t2=tiempo_actual();
			t= (t2-t1)/k;
		}
		//Calculamos las cotas
		c_sub= t/ pow(n,1.8);//subestimada
		c_aj= t/pow(n,2); //ajustada
		c_sobr= t/ pow(n,2.2); //sobrestimada
		printf("%15d%20f%20f%20f%20f\n", n, t, c_sub, c_aj, c_sobr);
	}
}

void medirsumaSubMax2(int v[]){
	double t1, t2, t;
	double c_sub, c_aj, c_sobr;
	int k;
	int n;
	printf("\nsumaSubMax2\n");
	printf("%14s%20s%20s%20s%20s\n","n","t(n)","t(n)/n^0.75","t(n)/n^1","t(n)/n^1.25 \n");
   
	for(n=500; n<=256000; n=2*n){ 
		t1= tiempo_actual();
		sumaSubMax2(v,n);
		t2= tiempo_actual();
		t=t2-t1;
		
		if(t<500){
			t1= tiempo_actual();
			for(k=0; k<1000; k++){
				sumaSubMax2(v,n);
			}
			t2=tiempo_actual();
			t= (t2-t1)/k;
		}
		//Calculamos las cotas
		c_sub= t/ pow(n,0.75);//subestimada
		c_aj= t/pow(n,1); //ajustada
		c_sobr= t/ pow(n,1.25); //sobrestimada
		printf("%15d%20f%20f%20f%20f\n", n, t, c_sub, c_aj, c_sobr);
	}
}

void test1(){
	int i,n=5;
	int v[][5] = {
	{-9,2,-5,-4,6},
	{4,0,9,2,5},
	{-2,-1,-9,-7,-1},
	{9,-2,1,-7,-8},
	{15,-2,-5,-4,16},
	{7,-5,6,7,-7}
	};
	
	printf("Test con vectores dados\n");
	printf("%20s%13s%13s\n", "", "sumaSubMax1", "sumaSubMax2");
	for(i=0; i<6;i++){
		listar_vector(v[i], n);
		printf("%10d%14d \n", sumaSubMax1(v[5], n), sumaSubMax2(v[5], n));
	}
}

void test2() {
	int i, a, b;
	int v[9];
	printf("test con numero pseudoaleatorios\n");
	printf("%35s%13s%15s\n", "", "sumaSubMax1", "sumaSubMax2");
	
	for (i=0; i<10; i++) {
		aleatorio(v, 9);
		listar_vector(v, 9);
		a = sumaSubMax1(v, 9);
		b = sumaSubMax2(v, 9);
		printf("%15d%15d\n", a, b);
	}
}

int main() {
	int v1[32000];
	int v2 [256000];
	
	inicializar_semilla(); 
	
	test1();
	printf("\n");
	test2();
	
	aleatorio(v1,32000);
	aleatorio(v2,256000);
	
	medirsumaSubMax1(v1);
	printf("\n");
	medirsumaSubMax2(v2);
	
	return 0;
}

