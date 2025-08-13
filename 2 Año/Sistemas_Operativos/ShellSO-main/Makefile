all: p3

list.o: list.c list.h
	gcc -c list.c
main.o: main.c list.h
	gcc -c main.c
p3: main.o list.o
	gcc -o p3 main.o list.o

clean:
	rm -f main.o list.o p3