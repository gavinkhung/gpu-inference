// main.cu
#include <stdio.h>
#include <cuda_runtime.h>
#include <mpi.h>

// CUDA kernel to print GPU info
__global__ void printGPUInfo(int rank) {
    if (threadIdx.x == 0 && blockIdx.x == 0) {
        printf("Hello from GPU thread in rank %d (GPU Device: %d)\n", 
               rank, cudaGetDeviceOrdinal());
    }
}

int main(int argc, char** argv) {
    int rank, size, broadcast_value;
    
    // Initialize MPI
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    
    // Set GPU device based on local rank
    cudaSetDevice(rank % 4);  // Assuming max 4 GPUs per node
    
    // Launch kernel
    printGPUInfo<<<1, 1>>>(rank);
    cudaDeviceSynchronize();
    
    // Broadcast example
    if (rank == 0) {
        broadcast_value = 42;
    }
    
    MPI_Bcast(&broadcast_value, 1, MPI_INT, 0, MPI_COMM_WORLD);
    
    printf("Rank %d received broadcast value: %d\n", rank, broadcast_value);
    
    // Cleanup
    cudaDeviceSynchronize();
    MPI_Finalize();
    return 0;
}