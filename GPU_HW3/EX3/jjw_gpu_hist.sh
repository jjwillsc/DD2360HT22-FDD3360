#!/bin/sh

hostname

module purge
module load git
module load gcc
module load cmake
module load cuda/11.7.99-gcc-11.3.0-irb3kpn

export PATH=/usr/local/cuda-11.7/bin:$PATH

# Create folders (if necessary)

export GPU_WORK_Q3=/scratch/jjwil/GPU_Work/Assignment_GPU_Work/Assignment_3

export DIR1="$GPU_WORK_Q3/hist_1024_output"
if [ -d "$DIR1" ]; then
  rm -rf hist_1024_output
  mkdir -p hist_1024_output
else
  echo "Creating new histogram-1024 folder in ${DIR1}..."
  mkdir -p hist_1024_output
fi

export DIR2="$GPU_WORK_Q3/hist_10000_output"
if [ -d "$DIR2" ]; then
  rm -rf hist_10000_output
  mkdir -p hist_10000_output
else
  echo "Creating new histogram-10000 folder here ${DIR2}..."
  mkdir -p hist_10000_output
fi

# Histogram 1024
# list GPU device info (CUDA utility)

cd $GPU_WORK_Q3/hist_1024

nvidia-smi >> $GPU_WORK_Q3/hist_1024_output/my_metrics_1024.txt
echo >> $GPU_WORK_Q3/hist_1024_output/my_metrics_1024.txt

# Compile
nvcc -arch=sm_80 jjw_histogram.cu -o jjw_histogram

# CPU Review Stats
perf stat ./jjw_histogram 1024 >> $GPU_WORK_Q3/hist_1024_output/my_metrics_1024.txt
echo >> $GPU_WORK_Q3/hist_1024_output/my_metrics_1024.txt

# GPU Review Results
nsys nvprof ./jjw_histogram 1024 >> $GPU_WORK_Q3/hist_1024_output/my_metrics_1024.txt
echo >> $GPU_WORK_Q3/hist_1024_output/my_metrics_1024.txt

# END Histogram 1024 Work
echo "END" >> $GPU_WORK_Q3/hist_1024_output/my_metrics_1024.txt

#-------------------------------------------------------

# Histogram 10000
# list GPU device info (CUDA utility)

cd $GPU_WORK_Q3/hist_10000

nvidia-smi >> $GPU_WORK_Q3/hist_10000_output/my_metrics_10000.txt
echo >> $GPU_WORK_Q3/hist_10000_output/my_metrics_10000.txt

# Compile
nvcc -arch=sm_80 jjw_histogram.cu -o jjw_histogram

# CPU Review Stats
perf stat ./jjw_histogram 10000 >> $GPU_WORK_Q3/hist_1024_output/my_metrics_10000.txt
echo >> $GPU_WORK_Q3/hist_10000_output/my_metrics_10000.txt

# GPU Review Results
nsys nvprof ./jjw_histogram 10000 >> $GPU_WORK_Q3/hist_10000_output/my_metrics_10000.txt
echo >> $GPU_WORK_Q3/hist_10000_output/my_metrics_10000.txt

# END Histogram 10000 Work
echo "END" >> $GPU_WORK_Q3/hist_10000_output/my_metrics_10000.txt

echo "END JOB"


