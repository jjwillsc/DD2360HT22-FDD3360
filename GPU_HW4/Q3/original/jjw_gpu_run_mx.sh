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

# Create folders (if necessary)

export GPU_WORK_Q2=/scratch/jjwil/GPU_Work/Assignment_GPU_Work/Assignment_3/Q2

export DIR2="$GPU_WORK_Q2/double"
if [ -d "$DIR2" ]; then
  rm -rf double
  mkdir -p double
else
  echo "Creating new double folder in ${DIR2}..."
  mkdir -p double
fi

export DIR1="$GPU_WORK_Q2/float"
if [ -d "$DIR1" ]; then
  rm -rf float
  mkdir -p float
else
  echo "Creating new float folder here ${DIR1}..."
  mkdir -p float
fi

# list GPU device info (CUDA utility)
nvidia-smi >> $GPU_WORK_Q2/double/my_metrics_128_double.txt
echo >> $GPU_WORK_Q2/double/my_metrics_128_double.txt

nvidia-smi >> $GPU_WORK_Q2/float/my_metrics_128_float.txt
echo >> $GPU_WORK_Q2/float/my_metrics_128_float.txt

nvidia-smi >> $GPU_WORK_Q2/double/my_metrics_4094_double.txt
echo >> $GPU_WORK_Q2/double/my_metrics_4094_double.txt

nvidia-smi >> $GPU_WORK_Q2/float/my_metrics_4094_float.txt
echo >> $GPU_WORK_Q2/float/my_metrics_4094_float.txt

nvidia-smi >> $GPU_WORK_Q2/double/my_metrics_8188_double.txt
echo >> $GPU_WORK_Q2/double/my_metrics_8188_double.txt

nvidia-smi >> $GPU_WORK_Q2/float/my_metrics_8188_float.txt
echo >> $GPU_WORK_Q2/float/my_metrics_8188_float.txt

# Compile (double and float)
nvcc -arch=sm_80 jjw_matrix_multiply_double.cu -o jjw_matrix_multiply_double
nvcc -arch=sm_80 jjw_matrix_multiply_float.cu -o jjw_matrix_multiply_float

# CPU Review Stats
# Double
perf stat ./jjw_matrix_multiply_double 128 128 128 >> $GPU_WORK_Q2/double/my_metrics_128_double.txt
echo >> $GPU_WORK_Q2/double/my_metrics_128_double.txt

perf stat ./jjw_matrix_multiply_double 511 1023 4094 >> $GPU_WORK_Q2/double/my_metrics_4094_double.txt
echo >> $GPU_WORK_Q2/double/my_metrics_4094_double.txt

perf stat ./jjw_matrix_multiply_double 1022 2046 8188 >> $GPU_WORK_Q2/double/my_metrics_8188_double.txt
echo >> $GPU_WORK_Q2/double/my_metrics_8188_double.txt

# Float
perf stat ./jjw_matrix_multiply_float 128 128 128 >> $GPU_WORK_Q2/float/my_metrics_128_float.txt
echo >> $GPU_WORK_Q2/float/my_metrics_128_float.txt

perf stat ./jjw_matrix_multiply_float 511 1023 4094 >> $GPU_WORK_Q2/float/my_metrics_4094_float.txt
echo >> $GPU_WORK_Q2/float/my_metrics_4094_float.txt

perf stat ./jjw_matrix_multiply_float 1022 2046 8188 >> $GPU_WORK_Q2/float/my_metrics_8188_float.txt
echo >> $GPU_WORK_Q2/float/my_metrics_8188_float.txt

# GPU Review Results
# Double
nsys nvprof ./jjw_matrix_multiply_double 128 128 128 >> $GPU_WORK_Q2/double/my_metrics_128_double.txt
echo >> $GPU_WORK_Q2/double/my_metrics_128_double.txt

nsys nvprof ./jjw_matrix_multiply_double 511 1023 4094 >> $GPU_WORK_Q2/double/my_metrics_4094_double.txt
echo >> $GPU_WORK_Q2/double/my_metrics_4094_double.txt

nsys nvprof ./jjw_matrix_multiply_double 1022 2046 8188 >> $GPU_WORK_Q2/double/my_metrics_8188_double.txt
echo >> $GPU_WORK_Q2/double/my_metrics_8188_double.txt

# Float
nsys nvprof ./jjw_matrix_multiply_float 128 128 128 >> $GPU_WORK_Q2/float/my_metrics_128_float.txt
echo >> $GPU_WORK_Q2/float/my_metrics_128_float.txt

nsys nvprof ./jjw_matrix_multiply_float 511 1023 4094 >> $GPU_WORK_Q2/float/my_metrics_4094_float.txt
echo >> $GPU_WORK_Q2/float/my_metrics_4094_float.txt

nsys nvprof ./jjw_matrix_multiply_float 1022 2046 8188 >> $GPU_WORK_Q2/float/my_metrics_8188_float.txt
echo >> $GPU_WORK_Q2/float/my_metrics_8188_float.txt

# Double
echo "END" >> $GPU_WORK_Q2/double/my_metrics_128_double.txt
echo "END" >> $GPU_WORK_Q2/double/my_metrics_4094_double.txt
echo "END" >> $GPU_WORK_Q2/double/my_metrics_8188_double.txt

# Float
echo "END" >> $GPU_WORK_Q2/float/my_metrics_128_float.txt
echo "END" >> $GPU_WORK_Q2/float/my_metrics_4094_float.txt
echo "END" >> $GPU_WORK_Q2/float/my_metrics_8188_float.txt

echo "END JOB"


