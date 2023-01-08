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

export GPU_WORK_4_Q3=/scratch/jjwil/GPU_Work/Assignment_GPU_Work/Final_Assignment_4/Q3/optimized_float

# Create folders (if necessary)

export DIR1="$GPU_WORK_4_Q3/managed_results"
if [ -d "$DIR1" ]; then
  rm -rf managed_results
  mkdir -p managed_results
else
  echo "Creating new folder here ${DIR1}..."
  mkdir -p managed_results
fi

# Create folders (if necessary)

export DIR1="$GPU_WORK_4_Q3/pinned_results"
if [ -d "$DIR1" ]; then
  rm -rf pinned_results
  mkdir -p pinned_results
else
  echo "Creating new folder here ${DIR1}..."
  mkdir -p pinned_results
fi

# list GPU device info (CUDA utility)
nvidia-smi >> $GPU_WORK_4_Q3/managed_results/mat_mx_managed_8188.txt
echo >> $GPU_WORK_4_Q3/managed_results/mat_mx_managed_8188.txt

nvidia-smi >> $GPU_WORK_4_Q3/pinned_results/mat_mx_pinned_8188.txt
echo >> $GPU_WORK_4_Q3/pinned_results/mat_mx_pinned_8188.txt

# Compile (managed and pinned)
nvcc -arch=sm_80 jjw_matrix_multiply_managed.cu -o jjw_matrix_multiply_managed
nvcc -arch=sm_80 jjw_matrix_multiply_pinned.cu -o jjw_matrix_multiply_pinned

# GPU Review Results
# Managed
./jjw_matrix_multiply_managed 1022 2046 8188 >> $GPU_WORK_4_Q3/managed_results/mat_mx_managed_8188.txt
echo >> $GPU_WORK_4_Q3/managed_results/mat_mx_managed_8188.txt

# Pinned
./jjw_matrix_multiply_pinned 1022 2046 8188 >> $GPU_WORK_4_Q3/pinned_results/mat_mx_pinned_8188.txt
echo >> $GPU_WORK_4_Q3/pinned_results/mat_mx_pinned_8188.txt

# GPU Review Results
# Managed
nsys nvprof -o $GPU_WORK_4_Q3/managed_results/nsys_profile_managed_8188 ./jjw_matrix_multiply_managed 1022 2046 8188 >> $GPU_WORK_4_Q3/managed_results/mat_mx_managed_8188.txt
echo >> $GPU_WORK_4_Q3/managed_results/mat_mx_managed_8188.txt

# Pinned
nsys nvprof -o $GPU_WORK_4_Q3/pinned_results/nsys_profile_pinned_8188 ./jjw_matrix_multiply_pinned 1022 2046 8188 >> $GPU_WORK_4_Q3/pinned_results/mat_mx_pinned_8188.txt
echo >> $GPU_WORK_4_Q3/pinned_results/mat_mx_pinned_8188.txt

# Managed
echo "END" >> $GPU_WORK_4_Q3/managed_results/mat_mx_managed_8188.txt

# Pinned
echo "END" >> $GPU_WORK_4_Q3/pinned_results/mat_mx_pinned_8188.txt

echo "END JOB"


