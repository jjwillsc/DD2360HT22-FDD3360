#!/bin/sh

# Do this first (at start up)
unset LD_PRELOAD

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

export HOME=/scratch/jjwil

# I/O performance analysis
# change darshan output log path
export DARSHAN_LOG_DIR_PATH=$HOME/darshan/darshan-log
export DARSHAN_RUNTIME=$HOME/lib/darshan/runtime
export DARSHAN_LIB=$DARSHAN_RUNTIME/lib/libdarshan.so
export LD_LIBRARY_PATH="$DARSHAN_RUNTIME/lib:$LD_LIBRARY_PATH"

# Darshan MPI profile setup
export MPICC_PROFILE=$DARSHAN_PREFIX/share/mpi-profile/darshan-cc
export MPICXX_PROFILE=$DARSHAN_PREFIX/share/mpi-profile/darshan-cxx
export MPIFORT_PROFILE=$DARSHAN_PREFIX/share/mpi-profile/darshan-f

# create folder (today´s date)
cd $HOME/darshan/darshan-log/2022
mkdir -p 12
cd $HOME/darshan/darshan-log/2022/12
rm -rf 27
mkdir -p 27

# Set Preload Library
export LD_PRELOAD=$DARSHAN_LIB

# Darshan extra options and Trace Enabled (Darshan eXtended Tracing (DXT) module)
export DARSHAN_DISABLE_SHARED_REDUCTION=1
export DARSHAN_MODMEM=8
export DARSHAN_MOD_ENABLE="DXT_POSIX,DXT_MPIIO"
# export DARSHAN_ENABLE_NONMPI=1
export DXT_ENABLE_IO_TRACE=1

export GPU_WORK_Final_Stream_Home=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA/Review_lavaMD_streams_threads
cd $GPU_WORK_Final_Stream_Home

# export GPU_WORK_Final_Original_Home=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA/lavaMD
# cd $GPU_WORK_Final_Original_Home

export DARSHAN_ENABLE_NONMPI=1
LD_PRELOAD=$DARSHAN_LIB  ./lavaMD -boxes1d 128

# LD_PRELOAD=$DARSHAN_LIB
# mpirun -n 2 ./lavaMD -boxes1d 128

exit 0

