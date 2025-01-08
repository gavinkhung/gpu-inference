# CUDA Example

Use the NVIDIA CUDA Docker Image to compile and run CUDA code

This assumes the host machine has a NVIDIA GPU and has installed the NVIDIA Container Toolkit.

Verify that the NVIDIA Container Toolkit is installed and that Docker can access the GPU

```sh
nvidia-smi
nvidia-docker --version

docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

## Usage

### Running via Slurm

```sh
make

sbatch submit.sh

squeue -u $USER
```

### Running via Docker

```sh
docker build -t example-cuda .
docker run --rm --gpus all example-cuda
```

### Running via Docker Compose

```sh
docker compose up --build
```
