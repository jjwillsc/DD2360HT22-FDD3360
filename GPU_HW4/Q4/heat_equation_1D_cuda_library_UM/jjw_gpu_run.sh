#!/bin/sh

hostname

module load git
module load gcc
module load cmake
module load cuda/11.7.99-gcc-11.3.0-irb3kpn

export PATH=/usr/local/cuda-11.7/bin:$PATH

# activate the spack environment
source /scratch/jjwil/src/spack/share/spack/setup-env.sh

# spack temp folder storage
export SPACK_USER_CACHE_PATH=/scratch/jjwil/tmp/spack-tmp
spack load nano

export GPU_WORK_4_Q4=/scratch/jjwil/GPU_Work/Assignment_GPU_Work/Final_Assignment_4/Q4/heat_equation_1D_cuda_library_UM/jjw_head_equation_output

# Create folders (if necessary)

export DIR1="$GPU_WORK_4_Q4/head_equation_flops_UM"
if [ -d "$DIR1" ]; then
  cd $GPU_WORK_4_Q4/head_equation_flops_UM
  rm -rf head_equation_flops_output
  mkdir -p head_equation_flops_output
else
  echo "Creating new folder here ${DIR1}..."
  cd $GPU_WORK_4_Q4/head_equation_flops_UM
  mkdir -p head_equation_flops_output
fi

# Create folders (if necessary)

export DIR2="$GPU_WORK_4_Q4/dimX_UM"
if [ -d "$DIR2" ]; then
  cd $GPU_WORK_4_Q4/dimX_UM
  rm -rf dimX_output
  mkdir -p dimX_output
else
  echo "Creating new folder here ${DIR2}..."
  cd $GPU_WORK_4_Q4/dimX_UM
  mkdir -p dimX_output
fi

# Create folders (if necessary)

export DIR3="$GPU_WORK_4_Q4/no_prefetching_UM"
if [ -d "$DIR3" ]; then
  cd $GPU_WORK_4_Q4/no_prefetching_UM
  rm -rf no_prefetching_output
  mkdir -p no_prefetching_output
else
  echo "Creating new folder here ${DIR3}..."
  cd $GPU_WORK_4_Q4/no_prefetching_UM
  mkdir -p no_prefetching_output
fi

# Create folders (if necessary)

export DIR4="$GPU_WORK_4_Q4/prefetching_UM"
if [ -d "$DIR4" ]; then
  cd $GPU_WORK_4_Q4/prefetching_UM
  rm -rf prefetching_output
  mkdir -p prefetching_output
else
  echo "Creating new folder here ${DIR4}..."
  cd $GPU_WORK_4_Q4/prefetching_UM
  mkdir -p prefetching_output
fi

# list GPU device info (CUDA utility)

# head_equation_flops_UM
nvidia-smi >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_100_output-100.txt
echo >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_100_output-100.txt

nvidia-smi >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_1000_output-1000.txt
echo >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_1000_output-1000.txt

nvidia-smi >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_10000_output-10000.txt
echo >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_10000_output-10000.txt

nvidia-smi >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_100000_output-100000.txt
echo >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_100000_output-100000.txt

nvidia-smi >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_1000000_output-1000000.txt
echo >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_1000000_output-1000000.txt

#---------------------------------------------------------------------------------------------

# dimX 128 N 
nvidia-smi >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-100.txt
echo >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-100.txt

nvidia-smi >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-500.txt
echo >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-500.txt

nvidia-smi >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-1000.txt
echo >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-1000.txt

nvidia-smi >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-5000.txt
echo >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-5000.txt

nvidia-smi >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-10000.txt
echo >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-10000.txt

#---------------------------------------------------------------------------------------------

# no_prefetching_UM
nvidia-smi >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-100.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-100.txt

nvidia-smi >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-600.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-600.txt

nvidia-smi >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-1200.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-1200.txt

nvidia-smi >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-2400.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-2400.txt

nvidia-smi >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-4800.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-4800.txt

#---------------------------------------------------------------------------------------------

# prefetching_UM
nvidia-smi >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-100.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-100.txt

nvidia-smi >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-600.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-600.txt

nvidia-smi >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-1200.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-1200.txt

nvidia-smi >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-2400.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-2400.txt

nvidia-smi >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-4800.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-4800.txt

#---------------------------------------------------------------------------------------------

# Compile (head_equation_flops_UM)
cd $GPU_WORK_4_Q4/head_equation_flops_UM
nvcc -arch=sm_80 -lcuda -lcudart -lcublas -lcusparse jjw_heat_main.cu -o jjw_heat_main

# GPU Execution Results

# head_equation_flops_UM
./jjw_heat_main 100 100 >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_100_output-100.txt
echo >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_100_output-100.txt

./jjw_heat_main 1000 1000 >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_1000_output-1000.txt
echo >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_1000_output-1000.txt

./jjw_heat_main 10000 10000 >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_10000_output-10000.txt
echo >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_10000_output-10000.txt

./jjw_heat_main 100000 100000 >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_100000_output-100000.txt
echo >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_100000_output-100000.txt

./jjw_heat_main 1000000 1000000 >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_1000000_output-1000000.txt
echo >> $GPU_WORK_4_Q4/head_equation_flops_UM/head_equation_flops_output/head_equation_flops_1000000_output-1000000.txt

#---------------------------------------------------------------------------------------------

# Compile (dimX 128 N)
cd $GPU_WORK_4_Q4/dimX_UM
nvcc -arch=sm_80 -lcuda -lcudart -lcublas -lcusparse jjw_heat_main.cu -o jjw_heat_main

# dimX 128 N
./jjw_heat_main 128 100 >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-100.txt
echo >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-100.txt

./jjw_heat_main 128 500 >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-500.txt
echo >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-500.txt

./jjw_heat_main 128 1000 >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-1000.txt
echo >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-1000.txt

./jjw_heat_main 128 5000 >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-5000.txt
echo >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-5000.txt

./jjw_heat_main 128 10000  >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-10000.txt
echo >> $GPU_WORK_4_Q4/dimX_UM/dimX_output/dimX_128_output-10000.txt

#---------------------------------------------------------------------------------------------

# no_prefetching_UM
cd $GPU_WORK_4_Q4/no_prefetching_UM
nvcc -arch=sm_80 -lcuda -lcudart -lcublas -lcusparse jjw_heat_main.cu -o jjw_heat_main

# GPU Execution and Profiling Results
./jjw_heat_main 600 100 >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-100.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-100.txt

nsys nvprof -o $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/nsys_no_prefetching_600_output-100 ./jjw_heat_main 600 100 >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-100.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-100.txt

./jjw_heat_main 600 600 >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-600.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-600.txt

nsys nvprof -o $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/nsys_no_prefetching_600_output-600 ./jjw_heat_main 600 600 >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-600.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-600.txt

./jjw_heat_main 600 1200 >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-1200.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-1200.txt

nsys nvprof -o $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/nsys_no_prefetching_600_output-1200 ./jjw_heat_main 600 1200 >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-1200.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-1200.txt

./jjw_heat_main 600 2400 >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-2400.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-2400.txt

nsys nvprof -o $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/nsys_no_prefetching_600_output-2400 ./jjw_heat_main 600 2400 >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-2400.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-2400.txt

./jjw_heat_main 600 4800 >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-4800.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-4800.txt

nsys nvprof -o $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/nsys_no_prefetching_600_output-4800 ./jjw_heat_main 600 4800 >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-4800.txt
echo >> $GPU_WORK_4_Q4/no_prefetching_UM/no_prefetching_output/no_prefetching_600_output-4800.txt

#---------------------------------------------------------------------------------------------

# prefetching_UM
cd $GPU_WORK_4_Q4/prefetching_UM
nvcc -arch=sm_80 -lcuda -lcudart -lcublas -lcusparse jjw_heat_main.cu -o jjw_heat_main

# GPU Execution and Profiling Results
./jjw_heat_main 600 100 >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-100.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-100.txt

nsys nvprof -o $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/nsys_prefetching_600_output-100 ./jjw_heat_main 600 100 >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-100.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-100.txt

./jjw_heat_main 600 600 >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-600.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-600.txt

nsys nvprof -o $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/nsys_prefetching_600_output-600 ./jjw_heat_main 600 600 >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-600.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-600.txt

./jjw_heat_main 600 1200 >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-1200.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-1200.txt

nsys nvprof -o $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/nsys_prefetching_600_output-1200 ./jjw_heat_main 600 1200 >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-1200.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-1200.txt

./jjw_heat_main 600 2400 >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-2400.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-2400.txt

nsys nvprof -o $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/nsys_prefetching_600_output-2400 ./jjw_heat_main 600 2400 >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-2400.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-2400.txt

./jjw_heat_main 600 4800 >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-4800.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-4800.txt

nsys nvprof -o $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/nsys_prefetching_600_output-4800 ./jjw_heat_main 600 4800 >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-4800.txt
echo >> $GPU_WORK_4_Q4/prefetching_UM/prefetching_output/prefetching_600_output-4800.txt

cd $GPU_WORK_4_Q4

echo "END JOB"

