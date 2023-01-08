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
spack load nano

export GPU_WORK_4_Q2=/scratch/jjwil/GPU_Work/Assignment_GPU_Work/Final_Assignment_4/Q2/optimized/per_thread

