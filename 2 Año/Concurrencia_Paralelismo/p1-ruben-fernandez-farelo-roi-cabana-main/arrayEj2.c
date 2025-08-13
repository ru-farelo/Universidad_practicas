#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "options.h"
#include <pthread.h>
#define DELAY_SCALE 1000

struct array {
    int size;
    int *arr;
};

struct thread_data {
    int id;
    int iterations;
    int delay;
    struct array *arr;
    pthread_mutex_t *mutex_array;
};

void apply_delay(int delay) {
    for(int i = 0; i < delay * DELAY_SCALE; i++); // waste time
}

void *increment(void *thread_arg)
{
    struct thread_data *data = (struct thread_data *)thread_arg;

    int pos, val;

    for(int i = 0; i < data->iterations; i++) {
        pos = rand() % data->arr->size;

        printf("%d increasing position %d\n", data->id, pos);

        // Lock the mutex
        pthread_mutex_lock(&data->mutex_array[pos]);

        val = data->arr->arr[pos];
        apply_delay(data->delay);

        val ++;
        apply_delay(data->delay);

        data->arr->arr[pos] = val;
        apply_delay(data->delay);

        // Unlock the mutex
        pthread_mutex_unlock(&data->mutex_array[pos]);
    }

    return 0;
}

void print_array(struct array arr) {
    int total = 0;

    for(int i = 0; i < arr.size; i++) {
        total += arr.arr[i];
        printf("%d ", arr.arr[i]);
    }

    printf("\nTotal: %d\n", total);
}
int main (int argc, char **argv)
{
    struct options       opt;
    struct array         arr;
    pthread_t           *threads;
    pthread_mutex_t     *mutex_list;
    int                 *ids;
    struct thread_data *arg_list;

    srand(time(NULL));

    // Default values for the options
    opt.num_threads  = 5;
    opt.size         = 10;
    opt.iterations   = 100;
    opt.delay        = 1000;

    read_options(argc, argv, &opt);

    arr.size = opt.size;
    arr.arr  = malloc(arr.size * sizeof(int));

    memset(arr.arr, 0, arr.size * sizeof(int));

    threads = malloc(opt.num_threads * sizeof(pthread_t));//Reservamos memoria para los threads
    ids = malloc(opt.num_threads * sizeof(int));
    arg_list= malloc(opt.num_threads*sizeof (struct thread_data));

    mutex_list= (pthread_mutex_t *) malloc(opt.size*sizeof (pthread_mutex_t));//memoria para los mutex

    for(int i = 0; i<opt.size; i++){
        pthread_mutex_init(&mutex_list[i], NULL); //Inicializamos los mutex
    }
    for (int i = 0; i < opt.num_threads; i++) {//Creamos tantos hilos como iteraciones haya
        ids[i] = i;
        arg_list[i]=(struct thread_data){i, opt.iterations, opt.delay, &arr,
                                         mutex_list};
        pthread_create(&threads[i], NULL, (void*) increment, &arg_list[i]);
    }

    for (int i = 0; i < opt.num_threads; i++) {//Esperamos a que todos los hilos terminen
        pthread_join(threads[i], NULL);
    }

    for(int i = 0; i<opt.num_threads; i++){
        pthread_mutex_destroy(&mutex_list[i]); //Destruimos los mutex
    }
    free(threads);//hacemos los frees correspondientes
    free(ids);
    free(mutex_list);
    free(arg_list);

    print_array(arr);
    free(arr.arr);

    return 0;
}
