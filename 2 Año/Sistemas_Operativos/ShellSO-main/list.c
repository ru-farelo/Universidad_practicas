#include <stdlib.h>
#include <memory.h>
#include <time.h>
#include "list.h"
#include <stdio.h>

#define UNUSED __attribute__((unused))

struct node {
    void *data;
    struct  node * prev;
    struct node* next;

};
struct listBase{
    struct node* first;
    int size;
};



linkedList createList() {
    linkedList list = malloc(sizeof (struct listBase));
    list -> first = malloc(sizeof (struct node));
    list -> first -> next = NULL;
    list -> first -> data = NULL;
    list -> first -> prev = NULL;
    list -> size = 0;
    return list;
}

int insert(linkedList l, void *insdata, int data_size) {

    void *data = malloc(data_size);
    if(data==NULL)return 0;
    memcpy(data,insdata,data_size);
    struct node *nodo = l->first;

    while (nodo->next != NULL){
        nodo = nodo -> next;
    }

    nodo -> next = malloc(sizeof(struct node));
    nodo -> next -> next = NULL;
    nodo -> next -> data = data;
    nodo -> next -> prev = nodo;
    l->size++;
    return 1;

}

pos getByNumericPos(linkedList l, int pos)
{
    struct node *nodo = l->first;
    for(int i = 0;i<pos;i++)
        nodo = nodo->next;
    return nodo;
}

pos first(linkedList l) {
    return l -> first;
}

pos next(UNUSED linkedList l, pos p) {
    if(p->next != NULL)
        return p-> next;
    return p;
}

int atEnd(UNUSED linkedList l, pos p) {
    return p -> next == NULL;
}

int isEmpty(linkedList l){
    return l -> first -> next==NULL;
}

void clearList(linkedList l)
{
    if(isEmpty(l))return;
    struct node *nodo = l->first->next;
    l->first->next=NULL;
    struct node *next;
    while (nodo != NULL){
        next = nodo->next;
        free(nodo->data);
        free(nodo);
        nodo=next;
    }
}
int getSize(linkedList l){
    return l->size;
}

void* getValue(UNUSED linkedList l, pos p) {
    if(p->next != NULL)
        return p->next->data;
    return NULL;
}
int listremove(linkedList l, pos p){
    pos aux = p -> next;
    p->next = p->next -> next;
    free(aux);
    l->size--;
    return 1;
}
