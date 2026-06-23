#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_fw31p

## Output and error files
#PBS -o run.out
#PBS -e run.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=16

##How long should the job run for?
#PBS -l walltime=00:03:00

## Start 
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab31/plums/a2/FW
export OMP_NUM_THREADS=16
export GOMP_CPU_AFFINITY="0-15"
#export GOMP_CPU_AFFINITY="0-15,32-47"
#export GOMP_CPU_AFFINITY="0-63"

export SIZE=1024
export BSIZE=64

# ./fw $SIZE
# ./fw_sr $SIZE $BSIZE
# ./fw_tiled $SIZE $BSIZE

##for T in 1 2 4 8 16; do export OMP_NUM_THREADS=$T && echo $T threads: && ./fw_tiled $SIZE $BSIZE; done

./fw_tiled $SIZE $BSIZE
