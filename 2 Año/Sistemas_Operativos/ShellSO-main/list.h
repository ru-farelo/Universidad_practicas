
#ifndef __LIST_H__
#define __LIST_H__

#include <stdbool.h>

typedef struct listBase* linkedList;
typedef struct node* pos;

linkedList createList();
int insert(linkedList l, void *data, int dataSize);

pos first(linkedList l);
pos next(linkedList l, pos p);
int atEnd(linkedList l, pos p);
void *getValue(linkedList l, pos p);
int isEmpty(linkedList l);
int getSize(linkedList l);
pos getByNumericPos(linkedList l, int pos);
int listremove(linkedList, pos p);
void clearList(linkedList l);


/*
void CreateListMem(ListMem*);
//char *getItemMem(Lista, int, char[]); -> creo que no la necesitamos
bool InsertElementMem(ListMem*, datos);
void printListMem(ListMem);

void printAlocMalloc(ListMem);
void printAlocMmap(ListMem);
void printAlocShared(ListMem);
*/
#endif