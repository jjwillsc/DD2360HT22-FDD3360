#!/bin/sh

hostname

module purge
module load git
module load gcc
module load cmake
module load cuda/11.7.99-gcc-11.3.0-irb3kpn

export PATH=/usr/local/cuda-11.7/bin:$PATH

# activate the spack environment
source /scratch/jjwil/src/spack/share/spack/setup-env.sh

# spack temp folder storage
export SPACK_USER_CACHE_PATH=/scratch/jjwil/tmp/spack-tmp
export SPACK_SRC=/scratch/jjwil/src/spack/opt/spack/linux-centos8-zen2/gcc-10.4.0

spack load cuda/irb3kpn
spack load nano

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
