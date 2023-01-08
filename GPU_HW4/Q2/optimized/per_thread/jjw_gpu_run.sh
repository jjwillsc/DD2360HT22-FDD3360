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

export GPU_WORK_4_Q2=/scratch/jjwil/GPU_Work/Assignment_GPU_Work/Final_Assignment_4/Q2/optimized/per_thread

# Create folders (if necessary)

export DIR1="$GPU_WORK_4_Q2/per_thread_output"
if [ -d "$DIR1" ]; then
  rm -rf per_thread_output
  mkdir -p per_thread_output
else
  echo "Creating new folder here ${DIR1}..."
  mkdir -p per_thread_output
fi

# list GPU device info (CUDA utility)
nvidia-smi >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg5000.txt
echo >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg5000.txt

nvidia-smi >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg10000.txt
echo >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg10000.txt

nvidia-smi >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg50000.txt
echo >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg50000.txt

nvidia-smi >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg100000.txt
echo >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg100000.txt

# Compile
nvcc --default-stream per-thread -arch sm_80 jjw_vector_addition-streamed.cu -o jjw_vector_addition-streamed_per_thread

# GPU Review Results
./jjw_vector_addition-streamed_per_thread 131070 5000 >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg5000.txt
echo >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg5000.txt

./jjw_vector_addition-streamed_per_thread 131070 10000 >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg10000.txt
echo >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg10000.txt

./jjw_vector_addition-streamed_per_thread 131070 50000 >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg50000.txt
echo >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg50000.txt

./jjw_vector_addition-streamed_per_thread 131070 100000 >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg100000.txt
echo >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg100000.txt

# GPU Profile Results
nsys nvprof -o $GPU_WORK_4_Q2/per_thread_output/nsys_profile_131070_Seg5000.txt ./jjw_vector_addition-streamed_per_thread 131070 5000 >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg5000.txt
echo >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg5000.txt

nsys nvprof -o $GPU_WORK_4_Q2/per_thread_output/nsys_profile_131070_Seg10000 ./jjw_vector_addition-streamed_per_thread 131070 10000 >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg10000.txt
echo >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg10000.txt

nsys nvprof -o $GPU_WORK_4_Q2/per_thread_output/nsys_profile_131070_Seg50000 ./jjw_vector_addition-streamed_per_thread 131070 50000 >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg50000.txt
echo >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg50000.txt

nsys nvprof -o $GPU_WORK_4_Q2/per_thread_output/nsys_profile_131070_Seg100000 ./jjw_vector_addition-streamed_per_thread 131070 100000 >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg100000.txt
echo >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg100000.txt


echo "END" >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg5000.txt
echo "END" >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg10000.txt
echo "END" >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg50000.txt
echo "END" >> $GPU_WORK_4_Q2/per_thread_output/my_metrics_131070_Seg100000.txt

echo "END JOB"
