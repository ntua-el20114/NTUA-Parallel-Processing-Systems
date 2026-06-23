.KEEP_STATE:

CC = gcc

CFLAGS = -Wall -Wextra -Wno-unused -O3

OMPFLAGS = -fopenmp $(CFLAGS)

LDFLAGS =

all: active_cpu

active_cpu: active_cpu.o
	$(CC) $(OMPFLAGS) $^ -o $@ $(LDFLAGS)

active_cpu.o: active_cpu.c $(H_FILES)
	$(CC) $(OMPFLAGS) -c $< -o $@

clean:
	rm -rf *.o active_cpu
