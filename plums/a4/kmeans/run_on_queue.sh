#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_kmeans_mpi

## Output and error files
#PBS -o run_kmeans_mpi.out
#PBS -e run_kmeans_mpi.err

## How many machines should we get? 
#PBS -l nodes=8:ppn=8

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start 
SIZE=256
COORDS=16
CLUSTERS=32
LOOPS=10

module load openmpi/1.8.3
cd /home/parallel/parlab31/a4/kmeans

for PROCS in 1 2 4 8 16 32 64; do
	printf "======== $PROCS Processes ========\n"
	mpirun -np $PROCS --mca btl tcp,self ./kmeans_mpi -c $CLUSTERS -s $SIZE -n $COORDS -l $LOOPS
done

