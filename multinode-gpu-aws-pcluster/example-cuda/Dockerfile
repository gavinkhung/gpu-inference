FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu20.04

WORKDIR /app

COPY . .

RUN nvcc main.cu -o main

CMD ["./main"]