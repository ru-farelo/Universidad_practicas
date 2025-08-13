CC=gcc
CFLAGS=-Wall -g -O0
LIBS=
OBJS1=arrayEj1.o options.o
OBJS2=arrayEj2.o options.o
OBJS3=arrayEj3.o options.o
OBJS4=arrayEj4.o options.o

all: arrayEj1 arrayEj2 arrayEj3 arrayEj4

%.o : %.c
	$(CC) $(CFLAGS) -c $<

arrayEj1: $(OBJS1)
	$(CC) $(CFLAGS) -o $@ $(OBJS1) $(LIBS)
arrayEj2: $(OBJS2)
	$(CC) $(CFLAGS) -o $@ $(OBJS2) $(LIBS)
arrayEj3: $(OBJS3)
	$(CC) $(CFLAGS) -o $@ $(OBJS3) $(LIBS)
arrayEj4: $(OBJS4)
	$(CC) $(CFLAGS) -o $@ $(OBJS4) $(LIBS)

cleanOut:
	rm -f *.o

clean:
	rm -f *.o arrayEj1 arrayEj2 arrayEj3 arrayEj4

