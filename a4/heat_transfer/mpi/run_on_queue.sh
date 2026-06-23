#!/bin/bash

## Give the Job a descriptive name
#PBS -N runjacobimpi

## Output and error files
#PBS -o outrunjacobimpi.out
#PBS -e errorrunjacobimpi.err

## How many machines should we get?
#PBS -l nodes=8:ppn=8

#PBS -l walltime=00:10:00

## Start 
## Run make in the src folder (modify properly)

module load openmpi/1.8.3
cd /home/parallel/parlab31/a4/heat_transfer/mpi
for SIZE in 2048 4096 6144; do
	for PROCS in 1 2 4 8 16 32 64; do
		P_X=$(awk -v p=$PROCS 'BEGIN { for(i=int(sqrt(p)); i>=1; i--) if(p%i==0) {print i; exit} }')
		P_Y=$(( PROCS / P_X ))
		printf "[$SIZE/$PROCS] "

		mpirun -np $PROCS --mca btl tcp,self ./jacobi_mpi $SIZE $SIZE $P_X $P_Y
	done
done
##./seidelsor 256
##./redblacksor 256
