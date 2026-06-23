#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_fw31m

## Output and error files
#PBS -o run.out
#PBS -e run.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=8

##How long should the job run for?
#PBS -l walltime=00:20:00

## Start 
## Run make in the src folder (modify properly)

# module load openmp
cd /home/parallel/parlab31/mike/a2/FW
#export OMP_NUM_THREADS=32
export GOMP_CPU_AFFINITY="0-7, 32-39, 8-15, 40-47, 16-23, 48-55, 24-31, 56-63"
#export GOMP_CPU_AFFINITY="0-63"

export SIZE=1024
export BSIZE=64

# ./fw $SIZE
# ./fw_sr $SIZE $BSIZE
# ./fw_tiled $SIZE $BSIZE

for S in 1024 2048 4096 ; do
	printf "\n======SIZE=$S======\n"
	for T in 1 2 4 8 16 32 64; do 
		export OMP_NUM_THREADS=$T
		echo $T threads:
		./fw_sr $S $BSIZE;
	done
done
