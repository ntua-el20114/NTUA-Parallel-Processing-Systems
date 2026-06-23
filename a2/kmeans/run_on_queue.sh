#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_kmeans

## Output and error files
#PBS -o run.out
#PBS -e run.err

## How many machines should we get? 
#PBS -l nodes=8:ppn=8

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start 
## Run make in the src folder (modify properly)

cd /home/parallel/parlab31/a2/kmeans

printf "====== SEQUENTIAL ======\n"
./kmeans_seq -s 256 -n 16 -c 32 -l 10

for threads in 1 2 4 8 16 32 64; do
	export OMP_NUM_THREADS=$threads
	printf "====== $threads THREADS ======\n"
	./kmeans_omp_reduction -s 256 -n 16 -c 32 -l 10
done

