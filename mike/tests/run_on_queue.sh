#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_active_cpu

## Output and error files
#PBS -o run.out
#PBS -e run.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=8

##How long should the job run for?
#PBS -l walltime=00:00:30

## Start 
## Run make in the src folder (modify properly)

cd /home/parallel/parlab31/mike/tests
export OMP_NUM_THREADS=1
export GOMP_CPU_AFFINITY="0-7"
./active_cpu
