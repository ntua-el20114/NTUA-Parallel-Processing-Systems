#!/bin/bash

## Give the Job a descriptive name
#PBS -N pmakejob

## Output and error files
#PBS -o outmakejob.out
#PBS -e errormakejob.err

## How many machines should we get?
#PBS -l nodes=1:ppn=1

#PBS -l walltime=00:05:00

## Start 
## Run make in the src folder (modify properly)
module load openmpi/1.8.3
cd /home/parallel/parlab31/plums/a4/heat_transfer/mpi
make
