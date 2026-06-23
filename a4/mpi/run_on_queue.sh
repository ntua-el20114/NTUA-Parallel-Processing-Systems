#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_mpi_helloworld

## Output and error files
#PBS -o run_mpi_helloworld.out
#PBS -e run_mpi_helloworld.err

## How many machines should we get? 
#PBS -l nodes=8:ppn=8

## Start 
## Run make in the src folder (modify properly)

module load openmpi/1.8.3
cd /home/parallel/parlab31/a4/mpi
mpirun -np 16 --mca btl tcp,self ./mpi_helloworld

