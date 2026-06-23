#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_kmeans

## Output and error files
#PBS -o run1.out
#PBS -e run.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=8

##How long should the job run for?
#PBS -l walltime=00:00:30

## Start 
## Run make in the src folder (modify properly)

cd /home/parallel/parlab31/mike/a2/kmeans
export OMP_NUM_THREADS=1
export GOMP_CPU_AFFINITY="0-7"
./kmeans_omp_naive -s 256 -n 16 -c 32 -l 10
