#!/bin/bash
#SBATCH --job-name=mpi_test
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:05:00
#SBATCH --output=mpi_test_%j.out
#SBATCH --error=mpi_test_%j.err

module load openmpi

mpirun -n 2 ./broadcast