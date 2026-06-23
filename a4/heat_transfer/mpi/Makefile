CC=mpicc
CFLAGS=-O3 -lm -Wall
##RES=-DPRINT_RESULTS
RES=
##CONV=-DTEST_CONV
CONV=

all: jacobi_mpi

jacobi_mpi: jacobi_mpi.c utils.c
	$(CC) $(CFLAGS) $(RES) $(CONV) jacobi_mpi.c utils.c -o jacobi_mpi

##seidelsor: gaussSeidelSOR_mpi.c utils.c
##	$(CC) $(CFLAGS) $(RES) $(CONV) GaussSeidelSOR_serial.c utils.c -o seidelsor

##redblacksor: RedBlackSOR_serial.c utils.c 
##	$(CC) $(CFLAGS) $(RES) $(CONV) RedBlackSOR_serial.c utils.c -o redblacksor

clean:
	rm jacobi_mpi

