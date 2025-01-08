# Compiler settings
NVCC        = nvcc

# Source files
SRC         = main.cu
TARGET      = main

all: $(TARGET)

$(TARGET): $(SRC)
	$(NVCC) $(SRC) -o $(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all clean