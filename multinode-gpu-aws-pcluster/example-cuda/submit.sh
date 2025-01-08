#!/bin/bash
#SBATCH --job-name=cuda_job       # Job name
#SBATCH --nodes=1                 # Run on one node
#SBATCH --ntasks=1                # Run a single task
#SBATCH --cpus-per-task=1         # Use 1 CPU core
#SBATCH --gres=gpu:1              # Request 1 GPU
#SBATCH --time=00:05:00           # Time limit hrs:min:sec
#SBATCH --output=cuda_job_%j.out  # Standard output and error log (%j is job ID)
#SBATCH --error=cuda_job_%j.err   # Separate error log (optional)

module load cuda

# Run the program
./main