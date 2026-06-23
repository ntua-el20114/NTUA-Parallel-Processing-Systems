#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_omp_Life31

## Output and error files
#PBS -o run_omp_Life.out
#PBS -e run_omp_Life.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=8

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start 
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab31/mike/a1
export OMP_NUM_THREADS=8
./Life 4096 1000

