
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


