#!/bin/bash

# #Give the Job a descriptive name
#PBS -N conc_ll-31 

## Output and error files
#PBS -o run100_0.out
#PBS -e run100_0.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=8

##How long should the job run for?
#PBS -l walltime=00:07:00

## Start 
## Run make in the src folder (modify properly)

# module load openmp
cd /home/parallel/parlab31/a2/conc_ll

export SIZE=8192
export CONTAINS=100
export ADD=0
export REMOVE=0

declare -A thread_to_conf
thread_to_conf[1]="0"
thread_to_conf[2]="0, 1"
thread_to_conf[4]="0, 1, 2, 3"
thread_to_conf[8]="0, 1, 2, 3, 4, 5, 6, 7"
thread_to_conf[16]="0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15"
thread_to_conf[32]="0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31"
thread_to_conf[64]="0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63"
thread_to_conf[128]="0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63"

printf "SIZE=$SIZE \nCONTAINS=$CONTAINS \nADD=$ADD \nREMOVE=$REMOVE \n"
for E in "cgl" "fgl" "opt" "lazy" "nb" ; do
	printf "\n==========$E==========\n"
	for T in  1 2 4 8 16 32 64 128; do
		export MT_CONF=${thread_to_conf[$T]}
		./x.$E $SIZE $CONTAINS $ADD $REMOVE
	done
done
