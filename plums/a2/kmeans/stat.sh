#!/bin/bash

#PBS -o stat.out
#PBS -e stat.err

cd /home/parallel/parlab31/plums/a2/kmeans
numactl --hardware
