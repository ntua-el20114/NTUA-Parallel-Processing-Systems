#!/bin/bash

## Give the Job a descriptive name
#PBS -N prunjacobimpi31

## Output and error files
#PBS -o outrunjacobimpi.out
#PBS -e errorrunjacobimpi.err

## How many machines should we get?
#PBS -l nodes=8:ppn=8

#PBS -l walltime=00:10:00

## Start 
## Run make in the src folder (modify properly)
module load openmpi/1.8.3
cd /home/parallel/parlab31/a4/plums/heat_transfer/mpi
mpirun -np 64 --mca btl tcp,self ./jacobi_mpi 512 512 8 8
##./seidelsor 256
##./redblacksor 256
