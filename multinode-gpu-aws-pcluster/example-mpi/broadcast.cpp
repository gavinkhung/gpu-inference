#include <mpi.h>
#include <iostream>
#include <string>
#include <cstring>

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);

    int world_rank, world_size;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    const int MAX_STRING = 100;
    char message[MAX_STRING];

    if (world_rank == 0) {
        std::string msg = "Hello from master node!";
        strcpy(message, msg.c_str());
    }

    // Broadcast the message from process 0 to all processes
    MPI_Bcast(message, MAX_STRING, MPI_CHAR, 0, MPI_COMM_WORLD);

    std::cout << "Process " << world_rank << " received message: " << message << std::endl;

    MPI_Finalize();
    return 0;
}