#include <stdio.h>

__global__ void print_thread_indices() {
    int threadId = threadIdx.x;
    int blockId = blockIdx.x;
    int globalId = blockId * blockDim.x + threadId;
    
    printf("Thread ID: %d, Block ID: %d, Global ID: %d\n", threadId, blockId, globalId);
}

int main() {
    print_thread_indices<<<2, 4>>>();
    
    cudaDeviceSynchronize();
    
    return 0;
}