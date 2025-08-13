#include <stdlib.h>
#include <pthread.h>
#include <stdio.h>


// circular array.
typedef struct _queue {
    int size;
    int used;
    int first;
    void **data;
    pthread_mutex_t mutex;
    pthread_cond_t buffer_full;
    pthread_cond_t buffer_empty;
    int queue_end;
} _queue;

#include "queue.h"

queue q_create(int size) {

    queue q = malloc(sizeof(_queue));
    q->size  = size;
    q->used  = 0;
    q->first = 0;
    q->data  = malloc(size * sizeof(void *));
    pthread_mutex_init(&q->mutex, NULL);
    pthread_cond_init(&q->buffer_full,NULL);
    pthread_cond_init(&q->buffer_empty,NULL);
    q->queue_end = 0;  // Inicialización de la variable
    return q;
}

int q_elements(queue q) {
    return q->used;
}
int q_is_empty(queue q) {
    return q->first == 0;
}

int q_insert(queue q, void *elem) {

    pthread_mutex_lock(&q->mutex);//bloqueamos el mutex

    q->queue_end=0;
    //printf("%d) ins\n",q->size);
    while(q_elements(q) == q->size) { //Si el tamaño de la cola es igual a
        // numero de elemento esperamos , ya que esta llena
        //printf("%d) ins wait\n",q->size);
        pthread_cond_wait(&q->buffer_full, &q->mutex);
    }
    //printf("%d) ins cont\n",q->size);

    /*

    if(q_elements(q) == 0){
        pthread_mutex_unlock(&q->mutex);
        return NULL;
    }
    */
    q->data[(q->first + q->used) % q->size] = elem;
    q->used++;

    if(q_elements(q) == 1) { //Si el numero de elementos es 1 y sabemos que la cola esta vacia ya que fue el primer elemento que insertamos
        pthread_cond_broadcast(&q->buffer_empty);// envia la señal a los
        // productores que estaban esperando
    }

    //printf("%d) ins ends\n",q->size);
    pthread_mutex_unlock(&q->mutex);

    return 0;
}

void *q_remove(queue q) {
    void *res;

    pthread_mutex_lock(&q->mutex);

    //printf("%d) rem st\n",q->size);
    while(q_elements(q) == 0&&!q->queue_end) { //Si no hay elementos en la cola
        // tenemos que esperar a que los productores añandan elementos
        //printf("%d) rem wait\n",q->size);
        pthread_cond_wait(&q->buffer_empty, &q->mutex);
    }
    //printf("%d) rem cont\n",q->size);



    if(q_elements(q) == 0){
        //printf("NULL");
        pthread_mutex_unlock(&q->mutex);
        return NULL;
    }

    res = q->data[q->first];
    q->first = (q->first + 1) % q->size;
    q->used--;

    if(q->used == q->size - 1) { // si hay elemento en la cola avisamos a los consumidores
        pthread_cond_broadcast(&q->buffer_full);
    }

    //printf("%d) rem ends\n",q->size);
    pthread_mutex_unlock(&q->mutex);

    return res;
}

//Notifica que se han acabado de añadir elementos
void q_end(queue q){
    q->queue_end=1;
    pthread_cond_broadcast(&q->buffer_empty);
}

void q_destroy(queue q) {
    pthread_mutex_destroy(&q->mutex);
    pthread_cond_destroy(&q->buffer_full);
    pthread_cond_destroy(&q->buffer_empty);
    free(q->data);
    free(q);
}
