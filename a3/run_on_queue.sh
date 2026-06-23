#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_kmeans31

## Output and error files
#PBS -o run.out
#PBS -e run.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=8

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start 
## Run make in the src folder (modify properly)

cd /home/parallel/parlab31/a3
export CUDA_VISIBLE_DEVICES=2
# sizes='32 64 128 256 512 1024 2048'

sizes='1024'

coordinates='32'

centers='64'

loop_threshold='10'

block_size='32 48 64 128 238 512 1024'

progs=(
	kmeans_seq
	kmeans_cuda_naive
#	kmeans_cuda_transpose
#	kmeans_cuda_shared
#	kmeans_cuda_all_gpu
#	kmeans_cuda_all_gpu_delta_reduction
)

for size in $sizes; do
	printf "\n***** Size = $size *****\n"
	for coord in $coordinates; do	
		printf "\n***** Coordinates = $coord *****\n"
		for center in $centers; do
			printf "\n***** Center = $center *****\n"
			filename=Execution_logs/Sz-${size}_Coo-${coord}_Cl-${center}.csv 
			echo "Implementation,blockSize,av_loop_t,min_loop_t,max_loop_t" >> $filename
			for prog in "${progs[@]}"; do
				if [[ $prog == 'kmeans_seq' ]]; then
					./${prog} -s $size -n $coord -c $center -l $loop_threshold
				fi
				for bs in $block_size; do
					if [[ $prog != 'kmeans_seq' ]]; then
						printf "\n***** Block Size = $bs *****\n"
						./${prog} -s $size -n $coord -c $center -l $loop_threshold -b $bs
					fi

				done
			done
		done
	done
done
