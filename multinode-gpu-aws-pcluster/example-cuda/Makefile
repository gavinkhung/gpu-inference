# Compiler settings
NVCC        = nvcc
NVCC_FLAGS  = -arch=sm_70  # Adjust based on your GPU architecture
MPI_PATH    = /usr/local/openmpi  # Adjust based on your MPI installation

# Include and library paths
INCLUDES    = -I$(MPI_PATH)/include
LIBS        = -L$(MPI_PATH)/lib -lmpi

# Source files
SRC         = main.cu
TARGET      = cuda_mpi_example

all: $(TARGET)

$(TARGET): $(SRC)
	$(NVCC) $(NVCC_FLAGS) $(INCLUDES) $(SRC) -o $(TARGET) $(LIBS)

clean:
	rm -f $(TARGET)

.PHONY: all clean