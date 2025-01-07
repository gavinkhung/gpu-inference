CXX = mpicxx
CXXFLAGS = -O2 -Wall

TARGET = broadcast
SRC = broadcast.cpp

$(TARGET): $(SRC)
        $(CXX) $(CXXFLAGS) -o $(TARGET) $(SRC)

clean:
        rm -f $(TARGET)