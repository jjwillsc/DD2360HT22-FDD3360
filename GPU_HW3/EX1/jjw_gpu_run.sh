#!/bin/sh

hostname

module purge
module load git
module load gcc
module load cmake
module load cuda/11.7.99-gcc-11.3.0-irb3kpn

export PATH=/usr/local/cuda-11.7/bin:$PATH

# Create folders (if necessary)

export GPU_WORK_Q4=/scratch/jjwil/GPU_Work/Assignment_GPU_Work/Assignment_3

# list GPU device info (CUDA utility)
nvidia-smi >> my_metrics_1024.txt
echo >> my_metrics_1024.txt

nvidia-smi >> my_metrics_131070.txt
echo >> my_metrics_131070.txt

# Compile
nvcc -arch=sm_80 jjw_vector_addition.cu -o jjw_vectoradd 

# CPU Review Stats
perf stat ./jjw_vectoradd 1024 >> my_metrics_1024.txt
echo >> my_metrics_1024.txt

perf stat ./jjw_vectoradd 131070 >> my_metrics_131070.txt
echo >> my_metrics_131070.txt

# GPU Review Results
nsys nvprof ./jjw_vectoradd 1024 >> my_metrics_1024.txt
echo >> my_metrics_1024.txt

nsys nvprof ./jjw_vectoradd 131070 >> my_metrics_131070.txt
echo >> my_metrics_131070.txt

echo "END" >> my_metrics_1024.txt
echo "END" >> my_metrics_131070.txt

echo "END JOB"
