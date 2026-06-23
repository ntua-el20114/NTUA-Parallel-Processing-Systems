#!/bin/bash

#PBS -N run_serial
#PBS -o run_serial.out
#PBS -e run_serial.err

#PBS -l walltime=00:03:00

#PBS -l nodes=1:ppn=1

cd /home/parallel/parlab31/a2/conc_ll
./x.serial 1024 100 0 0
