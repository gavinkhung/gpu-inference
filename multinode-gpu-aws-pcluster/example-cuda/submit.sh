#!/bin/bash
#SBATCH --job-name=cuda_mpi_job
#SBATCH --output=cuda_mpi_%j.out
#SBATCH --error=cuda_mpi_%j.err
#SBATCH --nodes=2                # Number of nodes
#SBATCH --ntasks-per-node=1      # MPI processes per node
#SBATCH --gres=gpu:1                   # Request 1 GPU per node
#SBATCH --gpus-per-task=1        # GPUs per MPI process
#SBATCH --time=00:10:00          # Maximum runtime in HH:MM:SS
#SBATCH --partition=gpu          # Specify GPU partition/queue

module load cuda
module load openmpi

# export PATH=$PATH:/home/ec2-user

# nvcc -o main main.cu
mpirun -np 2 ./main
