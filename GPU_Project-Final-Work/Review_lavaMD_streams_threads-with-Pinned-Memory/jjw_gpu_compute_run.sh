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

export GPU_WORK_Final_CUDA=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA

spack load cuda/irb3kpn
spack load ior
spack load nano

# --------------------------------------------------------------------------------------------------

export GPU_WORK_Final_CUDA=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA
cd $GPU_WORK_Final_CUDA

. jw_pic_gpu.sh

export GPU_WORK_Final_Stream_Home=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA/Review_lavaMD_streams_threads
export GPU_WORK_Final_Stream_Work=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA/Review_lavaMD_streams_threads/jjw_output_work

cd $GPU_WORK_Final_Stream_Home

# --------------------------------------------------------------------------------------------------

# lavaMD_20

source ncu --target-processes all -o $GPU_WORK_Final_Stream_Work/lavaMD_20/ncu_lavaMD_20-output ./lavaMD -boxes1d 20 >> $GPU_WORK_Final_Stream_Work/lavaMD_20/lavaMD_20-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_20/lavaMD_20-output.txt

# lavaMD_40

source ncu --target-processes all -o $GPU_WORK_Final_Stream_Work/lavaMD_40/ncu_lavaMD_40-output ./lavaMD -boxes1d 40 >> $GPU_WORK_Final_Stream_Work/lavaMD_40/lavaMD_40-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_40/lavaMD_40-output.txt

# lavaMD_60

source ncu --target-processes all -o $GPU_WORK_Final_Stream_Work/lavaMD_60/ncu_lavaMD_60-output ./lavaMD -boxes1d 60 >> $GPU_WORK_Final_Stream_Work/lavaMD_60/lavaMD_60-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_60/lavaMD_60-output.txt

# lavaMD_80

source ncu --target-processes all -o $GPU_WORK_Final_Stream_Work/lavaMD_80/ncu_lavaMD_80-output ./lavaMD -boxes1d 80 >> $GPU_WORK_Final_Stream_Work/lavaMD_80/lavaMD_80-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_80/lavaMD_80-output.txt

# lavaMD_100

source ncu --target-processes all -o $GPU_WORK_Final_Stream_Work/lavaMD_100/ncu_lavaMD_100-output ./lavaMD -boxes1d 100 >> $GPU_WORK_Final_Stream_Work/lavaMD_100/lavaMD_100-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_100/lavaMD_100-output.txt

# lavaMD_120

source ncu --target-processes all -o $GPU_WORK_Final_Stream_Work/lavaMD_120/ncu_lavaMD_120-output ./lavaMD -boxes1d 120 >> $GPU_WORK_Final_Stream_Work/lavaMD_120/lavaMD_120-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_120/lavaMD_120-output.txt

# lavaMD_140

source ncu --target-processes all -o $GPU_WORK_Final_Stream_Work/lavaMD_140/ncu_lavaMD_140-output ./lavaMD -boxes1d 140 >> $GPU_WORK_Final_Stream_Work/lavaMD_140/lavaMD_140-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_140/lavaMD_140-output.txt

# lavaMD_160

source ncu --target-processes all -o $GPU_WORK_Final_Stream_Work/lavaMD_160/ncu_lavaMD_160-output ./lavaMD -boxes1d 160 >> $GPU_WORK_Final_Stream_Work/lavaMD_160/lavaMD_160-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_160/lavaMD_160-output.txt

# --------------------------------------------------------------------------------------------------

export GPU_WORK_Final_CUDA=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA
cd $GPU_WORK_Final_CUDA

. jw_pic_gpu.sh

export GPU_WORK_Final_Original_Home=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA/lavaMD
export GPU_WORK_Final_Original_Work=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA/lavaMD/jjw_output_work

cd $GPU_WORK_Final_Original_Home

# --------------------------------------------------------------------------------------------------

# lavaMD_20

source ncu --target-processes all -o $GPU_WORK_Final_Original_Work/lavaMD_20/ncu_lavaMD_20-output ./lavaMD -boxes1d 20 >> $GPU_WORK_Final_Original_Work/lavaMD_20/lavaMD_20-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_20/lavaMD_20-output.txt

# lavaMD_40

source ncu --target-processes all -o $GPU_WORK_Final_Original_Work/lavaMD_40/ncu_lavaMD_40-output ./lavaMD -boxes1d 40 >> $GPU_WORK_Final_Original_Work/lavaMD_40/lavaMD_40-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_40/lavaMD_40-output.txt

# lavaMD_60

source ncu --target-processes all -o $GPU_WORK_Final_Original_Work/lavaMD_60/ncu_lavaMD_60-output ./lavaMD -boxes1d 60 >> $GPU_WORK_Final_Original_Work/lavaMD_60/lavaMD_60-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_60/lavaMD_60-output.txt

# lavaMD_80

source ncu --target-processes all -o $GPU_WORK_Final_Original_Work/lavaMD_80/ncu_lavaMD_80-output ./lavaMD -boxes1d 80 >> $GPU_WORK_Final_Original_Work/lavaMD_80/lavaMD_80-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_80/lavaMD_80-output.txt

# lavaMD_100

source ncu --target-processes all -o $GPU_WORK_Final_Original_Work/lavaMD_100/ncu_lavaMD_100-output ./lavaMD -boxes1d 100 >> $GPU_WORK_Final_Original_Work/lavaMD_100/lavaMD_100-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_100/lavaMD_100-output.txt

# lavaMD_120

source ncu --target-processes all -o $GPU_WORK_Final_Original_Work/lavaMD_120/ncu_lavaMD_120-output ./lavaMD -boxes1d 120 >> $GPU_WORK_Final_Original_Work/lavaMD_120/lavaMD_120-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_120/lavaMD_120-output.txt

# lavaMD_140

source ncu --target-processes all -o $GPU_WORK_Final_Original_Work/lavaMD_140/ncu_lavaMD_140-output ./lavaMD -boxes1d 140 >> $GPU_WORK_Final_Original_Work/lavaMD_140/lavaMD_140-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_140/lavaMD_140-output.txt

# lavaMD_160

source ncu --target-processes all -o $GPU_WORK_Final_Original_Work/lavaMD_160/ncu_lavaMD_160-output ./lavaMD -boxes1d 160 >> $GPU_WORK_Final_Original_Work/lavaMD_160/lavaMD_160-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_160/lavaMD_160-output.txt

cd $GPU_WORK_Final_CUDA

echo "END JOB"
