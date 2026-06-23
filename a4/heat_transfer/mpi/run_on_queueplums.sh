#!/bin/bash

## Give the Job a descriptive name
#PBS -N runjacobimpi_ploumns

## Output and error files
#PBS -o outrunjacobimpi_ploums.out
#PBS -e errorrunjacobimpi_ploums.err

## How many machines should we get?
#PBS -l nodes=8:ppn=8

#PBS -l walltime=00:10:00

## Start 
## Run make in the src folder (modify properly)

module load openmpi/1.8.3
cd /home/parallel/parlab31/a4/heat_transfer/mpi
for SIZE in 512; do
	for PROCS in 64; do
		P_SIZE=$(echo "sqrt($PROCS)" | bc)
		printf "======SIZE=$SIZE===PROCS=$PROCS===P_SIZE=$P_SIZE======\n"
		mpirun -np $PROCS --mca btl tcp,self ./jacobi_mpi $SIZE $SIZE $P_SIZE $P_SIZE
	done
done
##./seidelsor 256
##./redblacksor 256
