# CUDA + MPI Example

Run Multi-Node GPU CUDA code, allowing for distributed workloads.

This assumes that all of the compute nodes have a GPU and CUDA installed.

Compile the code on the login node and submit the Slurm job.

```sh
make

sbatch submit.sh
```
