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

export GPU_WORK_Final_Stream_Home=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA/Review_lavaMD_streams_threads
export GPU_WORK_Final_Stream_Work=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA/Review_lavaMD_streams_threads/jjw_output_work

# Create folders (if necessary)

export DIR1="$GPU_WORK_Final_Stream_Work/lavaMD_20"
if [ -d "$DIR1" ]; then
  cd $GPU_WORK_Final_Stream_Work
  rm -rf lavaMD_20
  mkdir -p lavaMD_20
else
  echo "Creating new folder here ${DIR1}..."
  cd $GPU_WORK_Final_Stream_Work
  mkdir -p lavaMD_20
fi

# Create folders (if necessary)

export DIR2="$GPU_WORK_Final_Stream_Work/lavaMD_40"
if [ -d "$DIR2" ]; then
  cd $GPU_WORK_Final_Stream_Work
  rm -rf lavaMD_40
  mkdir -p lavaMD_40
else
  echo "Creating new folder here ${DIR2}..."
  cd $GPU_WORK_Final_Stream_Work
  mkdir -p lavaMD_40
fi

# Create folders (if necessary)

export DIR3="$GPU_WORK_Final_Stream_Work/lavaMD_60"
if [ -d "$DIR3" ]; then
  cd $GPU_WORK_Final_Stream_Work
  rm -rf lavaMD_60
  mkdir -p lavaMD_60
else
  echo "Creating new folder here ${DIR3}..."
  cd $GPU_WORK_Final_Stream_Work
  mkdir -p lavaMD_60
fi

# Create folders (if necessary)

export DIR4="$GPU_WORK_Final_Stream_Work/lavaMD_80"
if [ -d "$DIR4" ]; then
  cd $GPU_WORK_Final_Stream_Work
  rm -rf lavaMD_80
  mkdir -p lavaMD_80
else
  echo "Creating new folder here ${DIR4}..."
  cd $GPU_WORK_Final_Stream_Work
  mkdir -p lavaMD_80
fi

# Create folders (if necessary)

export DIR5="$GPU_WORK_Final_Stream_Work/lavaMD_100"
if [ -d "$DIR5" ]; then
  cd $GPU_WORK_Final_Stream_Work
  rm -rf lavaMD_100
  mkdir -p lavaMD_100
else
  echo "Creating new folder here ${DIR5}..."
  cd $GPU_WORK_Final_Stream_Work
  mkdir -p lavaMD_100
fi

# Create folders (if necessary)

export DIR6="$GPU_WORK_Final_Stream_Work/lavaMD_120"
if [ -d "$DIR6" ]; then
  cd $GPU_WORK_Final_Stream_Work
  rm -rf lavaMD_120
  mkdir -p lavaMD_120
else
  echo "Creating new folder here ${DIR6}..."
  cd $GPU_WORK_Final_Stream_Work
  mkdir -p lavaMD_120
fi

# Create folders (if necessary)

export DIR7="$GPU_WORK_Final_Stream_Work/lavaMD_140"
if [ -d "$DIR7" ]; then
  cd $GPU_WORK_Final_Stream_Work
  rm -rf lavaMD_140
  mkdir -p lavaMD_140
else
  echo "Creating new folder here ${DIR7}..."
  cd $GPU_WORK_Final_Stream_Work
  mkdir -p lavaMD_140
fi

# Create folders (if necessary)

export DIR8="$GPU_WORK_Final_Stream_Work/lavaMD_160"
if [ -d "$DIR8" ]; then
  cd $GPU_WORK_Final_Stream_Work
  rm -rf lavaMD_160
  mkdir -p lavaMD_160
else
  echo "Creating new folder here ${DIR8}..."
  cd $GPU_WORK_Final_Stream_Work
  mkdir -p lavaMD_160
fi

echo "Start LavaMD-Stream Run"
cd $GPU_WORK_Final_Stream_Home

# list GPU device info (CUDA utility)
nvidia-smi >> $GPU_WORK_Final_Stream_Work/lavaMD_20/lavaMD_20-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_20/lavaMD_20-output.txt

nvidia-smi >> $GPU_WORK_Final_Stream_Work/lavaMD_40/lavaMD_40-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_40/lavaMD_40-output.txt

nvidia-smi >> $GPU_WORK_Final_Stream_Work/lavaMD_60/lavaMD_60-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_60/lavaMD_60-output.txt

nvidia-smi >> $GPU_WORK_Final_Stream_Work/lavaMD_80/lavaMD_80-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_80/lavaMD_80-output.txt

nvidia-smi >> $GPU_WORK_Final_Stream_Work/lavaMD_100/lavaMD_100-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_100/lavaMD_100-output.txt

nvidia-smi >> $GPU_WORK_Final_Stream_Work/lavaMD_120/lavaMD_120-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_120/lavaMD_120-output.txt

nvidia-smi >> $GPU_WORK_Final_Stream_Work/lavaMD_140/lavaMD_140-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_140/lavaMD_140-output.txt

nvidia-smi >> $GPU_WORK_Final_Stream_Work/lavaMD_160/lavaMD_160-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_160/lavaMD_160-output.txt

# lavaMD_20
./lavaMD -boxes1d 20 >> $GPU_WORK_Final_Stream_Work/lavaMD_20/lavaMD_20-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_20/lavaMD_20-output.txt

nsys nvprof -o $GPU_WORK_Final_Stream_Work/lavaMD_20/nsys_lavaMD_20-output ./lavaMD -boxes1d 20 >> $GPU_WORK_Final_Stream_Work/lavaMD_20/lavaMD_20-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_20/lavaMD_20-output.txt

# lavaMD_40
./lavaMD -boxes1d 40 >> $GPU_WORK_Final_Stream_Work/lavaMD_40/lavaMD_40-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_40/lavaMD_40-output.txt

nsys nvprof -o $GPU_WORK_Final_Stream_Work/lavaMD_40/nsys_lavaMD_40-output ./lavaMD -boxes1d 40 >> $GPU_WORK_Final_Stream_Work/lavaMD_40/lavaMD_40-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_40/lavaMD_40-output.txt

# lavaMD_60
./lavaMD -boxes1d 60 >> $GPU_WORK_Final_Stream_Work/lavaMD_60/lavaMD_60-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_60/lavaMD_60-output.txt

nsys nvprof -o $GPU_WORK_Final_Stream_Work/lavaMD_60/nsys_lavaMD_60-output ./lavaMD -boxes1d 60 >> $GPU_WORK_Final_Stream_Work/lavaMD_60/lavaMD_60-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_60/lavaMD_60-output.txt

# lavaMD_80
./lavaMD -boxes1d 80 >> $GPU_WORK_Final_Stream_Work/lavaMD_80/lavaMD_80-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_80/lavaMD_80-output.txt

nsys nvprof -o $GPU_WORK_Final_Stream_Work/lavaMD_80/nsys_lavaMD_80-output ./lavaMD -boxes1d 80 >> $GPU_WORK_Final_Stream_Work/lavaMD_80/lavaMD_80-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_80/lavaMD_80-output.txt

# lavaMD_100
./lavaMD -boxes1d 100 >> $GPU_WORK_Final_Stream_Work/lavaMD_100/lavaMD_100-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_100/lavaMD_100-output.txt

nsys nvprof -o $GPU_WORK_Final_Stream_Work/lavaMD_100/nsys_lavaMD_100-output ./lavaMD -boxes1d 100 >> $GPU_WORK_Final_Stream_Work/lavaMD_100/lavaMD_100-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_100/lavaMD_100-output.txt

# lavaMD_120
./lavaMD -boxes1d 120 >> $GPU_WORK_Final_Stream_Work/lavaMD_120/lavaMD_120-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_120/lavaMD_120-output.txt

nsys nvprof -o $GPU_WORK_Final_Stream_Work/lavaMD_120/nsys_lavaMD_120-output ./lavaMD -boxes1d 120 >> $GPU_WORK_Final_Stream_Work/lavaMD_120/lavaMD_120-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_120/lavaMD_120-output.txt

# lavaMD_140
./lavaMD -boxes1d 140 >> $GPU_WORK_Final_Stream_Work/lavaMD_140/lavaMD_140-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_140/lavaMD_140-output.txt

nsys nvprof -o $GPU_WORK_Final_Stream_Work/lavaMD_140/nsys_lavaMD_140-output ./lavaMD -boxes1d 140 >> $GPU_WORK_Final_Stream_Work/lavaMD_140/lavaMD_140-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_140/lavaMD_140-output.txt

# lavaMD_160
./lavaMD -boxes1d 160 >> $GPU_WORK_Final_Stream_Work/lavaMD_160/lavaMD_160-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_160/lavaMD_160-output.txt

nsys nvprof -o $GPU_WORK_Final_Stream_Work/lavaMD_160/nsys_lavaMD_160-output ./lavaMD -boxes1d 160 >> $GPU_WORK_Final_Stream_Work/lavaMD_160/lavaMD_160-output.txt
echo >> $GPU_WORK_Final_Stream_Work/lavaMD_160/lavaMD_160-output.txt

echo "END LavaMD-Stream Run"

export GPU_WORK_Final_Original_Home=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA/lavaMD
export GPU_WORK_Final_Original_Work=/scratch/jjwil/GPU_Work/src/GPU_jjw_rodinia_work/GPU_Assignment_Work/CUDA/lavaMD/jjw_output_work

# Create folders (if necessary)

export DIR9="$GPU_WORK_Final_Original_Work/lavaMD_20"
if [ -d "$DIR9" ]; then
  cd $GPU_WORK_Final_Original_Work
  rm -rf lavaMD_20
  mkdir -p lavaMD_20
else
  echo "Creating new folder here ${DIR9}..."
  cd $GPU_WORK_Final_Original_Work
  mkdir -p lavaMD_20
fi

# Create folders (if necessary)

export DIR10="$GPU_WORK_Final_Original_Work/lavaMD_40"
if [ -d "$DIR10" ]; then
  cd $GPU_WORK_Final_Original_Work
  rm -rf lavaMD_40
  mkdir -p lavaMD_40
else
  echo "Creating new folder here ${DIR10}..."
  cd $GPU_WORK_Final_Original_Work
  mkdir -p lavaMD_40
fi

# Create folders (if necessary)

export DIR11="$GPU_WORK_Final_Original_Work/lavaMD_60"
if [ -d "$DIR11" ]; then
  cd $GPU_WORK_Final_Original_Work
  rm -rf lavaMD_60
  mkdir -p lavaMD_60
else
  echo "Creating new folder here ${DIR11}..."
  cd $GPU_WORK_Final_Original_Work
  mkdir -p lavaMD_60
fi

# Create folders (if necessary)

export DIR12="$GPU_WORK_Final_Original_Work/lavaMD_80"
if [ -d "$DIR12" ]; then
  cd $GPU_WORK_Final_Original_Work
  rm -rf lavaMD_80
  mkdir -p lavaMD_80
else
  echo "Creating new folder here ${DIR12}..."
  cd $GPU_WORK_Final_Original_Work
  mkdir -p lavaMD_80
fi

# Create folders (if necessary)

export DIR13="$GPU_WORK_Final_Original_Work/lavaMD_100"
if [ -d "$DIR13" ]; then
  cd $GPU_WORK_Final_Original_Work
  rm -rf lavaMD_100
  mkdir -p lavaMD_100
else
  echo "Creating new folder here ${DIR13}..."
  cd $GPU_WORK_Final_Original_Work
  mkdir -p lavaMD_100
fi

# Create folders (if necessary)

export DIR14="$GPU_WORK_Final_Original_Work/lavaMD_120"
if [ -d "$DIR14" ]; then
  cd $GPU_WORK_Final_Original_Work
  rm -rf lavaMD_120
  mkdir -p lavaMD_120
else
  echo "Creating new folder here ${DIR14}..."
  cd $GPU_WORK_Final_Original_Work
  mkdir -p lavaMD_120
fi

# Create folders (if necessary)

export DIR15="$GPU_WORK_Final_Original_Work/lavaMD_140"
if [ -d "$DIR15" ]; then
  cd $GPU_WORK_Final_Original_Work
  rm -rf lavaMD_140
  mkdir -p lavaMD_140
else
  echo "Creating new folder here ${DIR15}..."
  cd $GPU_WORK_Final_Original_Work
  mkdir -p lavaMD_140
fi

# Create folders (if necessary)

export DIR16="$GPU_WORK_Final_Original_Work/lavaMD_160"
if [ -d "$DIR16" ]; then
  cd $GPU_WORK_Final_Original_Work
  rm -rf lavaMD_160
  mkdir -p lavaMD_160
else
  echo "Creating new folder here ${DIR16}..."
  cd $GPU_WORK_Final_Original_Work
  mkdir -p lavaMD_160
fi

echo "Start LavaMD-Original Run"
cd $GPU_WORK_Final_Original_Home

# list GPU device info (CUDA utility)
nvidia-smi >> $GPU_WORK_Final_Original_Work/lavaMD_20/lavaMD_20-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_20/lavaMD_20-output.txt

nvidia-smi >> $GPU_WORK_Final_Original_Work/lavaMD_40/lavaMD_40-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_40/lavaMD_40-output.txt

nvidia-smi >> $GPU_WORK_Final_Original_Work/lavaMD_60/lavaMD_60-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_60/lavaMD_60-output.txt

nvidia-smi >> $GPU_WORK_Final_Original_Work/lavaMD_80/lavaMD_80-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_80/lavaMD_80-output.txt

nvidia-smi >> $GPU_WORK_Final_Original_Work/lavaMD_100/lavaMD_100-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_100/lavaMD_100-output.txt

nvidia-smi >> $GPU_WORK_Final_Original_Work/lavaMD_120/lavaMD_120-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_120/lavaMD_120-output.txt

nvidia-smi >> $GPU_WORK_Final_Original_Work/lavaMD_140/lavaMD_140-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_140/lavaMD_140-output.txt

nvidia-smi >> $GPU_WORK_Final_Original_Work/lavaMD_160/lavaMD_160-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_160/lavaMD_160-output.txt

# lavaMD_20
./lavaMD -boxes1d 20 >> $GPU_WORK_Final_Original_Work/lavaMD_20/lavaMD_20-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_20/lavaMD_20-output.txt

nsys nvprof -o $GPU_WORK_Final_Original_Work/lavaMD_20/nsys_lavaMD_20-output ./lavaMD -boxes1d 20 >> $GPU_WORK_Final_Original_Work/lavaMD_20/lavaMD_20-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_20/lavaMD_20-output.txt

# lavaMD_40
./lavaMD -boxes1d 40 >> $GPU_WORK_Final_Original_Work/lavaMD_40/lavaMD_40-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_40/lavaMD_40-output.txt

nsys nvprof -o $GPU_WORK_Final_Original_Work/lavaMD_40/nsys_lavaMD_40-output ./lavaMD -boxes1d 40 >> $GPU_WORK_Final_Original_Work/lavaMD_40/lavaMD_40-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_40/lavaMD_40-output.txt

# lavaMD_60
./lavaMD -boxes1d 60 >> $GPU_WORK_Final_Original_Work/lavaMD_60/lavaMD_60-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_60/lavaMD_60-output.txt

nsys nvprof -o $GPU_WORK_Final_Original_Work/lavaMD_60/nsys_lavaMD_60-output ./lavaMD -boxes1d 60 >> $GPU_WORK_Final_Original_Work/lavaMD_60/lavaMD_60-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_60/lavaMD_60-output.txt

# lavaMD_80
./lavaMD -boxes1d 80 >> $GPU_WORK_Final_Original_Work/lavaMD_80/lavaMD_80-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_80/lavaMD_80-output.txt

nsys nvprof -o $GPU_WORK_Final_Original_Work/lavaMD_80/nsys_lavaMD_80-output ./lavaMD -boxes1d 80 >> $GPU_WORK_Final_Original_Work/lavaMD_80/lavaMD_80-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_80/lavaMD_80-output.txt

# lavaMD_100
./lavaMD -boxes1d 100 >> $GPU_WORK_Final_Original_Work/lavaMD_100/lavaMD_100-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_100/lavaMD_100-output.txt

nsys nvprof -o $GPU_WORK_Final_Original_Work/lavaMD_100/nsys_lavaMD_100-output ./lavaMD -boxes1d 100 >> $GPU_WORK_Final_Original_Work/lavaMD_100/lavaMD_100-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_100/lavaMD_100-output.txt

# lavaMD_120
./lavaMD -boxes1d 120 >> $GPU_WORK_Final_Original_Work/lavaMD_120/lavaMD_120-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_120/lavaMD_120-output.txt

nsys nvprof -o $GPU_WORK_Final_Original_Work/lavaMD_120/nsys_lavaMD_120-output ./lavaMD -boxes1d 120 >> $GPU_WORK_Final_Original_Work/lavaMD_120/lavaMD_120-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_120/lavaMD_120-output.txt

# lavaMD_140
./lavaMD -boxes1d 140 >> $GPU_WORK_Final_Original_Work/lavaMD_140/lavaMD_140-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_140/lavaMD_140-output.txt

nsys nvprof -o $GPU_WORK_Final_Original_Work/lavaMD_140/nsys_lavaMD_140-output ./lavaMD -boxes1d 140 >> $GPU_WORK_Final_Original_Work/lavaMD_140/lavaMD_140-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_140/lavaMD_140-output.txt

# lavaMD_160
./lavaMD -boxes1d 160 >> $GPU_WORK_Final_Original_Work/lavaMD_160/lavaMD_160-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_160/lavaMD_160-output.txt

nsys nvprof -o $GPU_WORK_Final_Original_Work/lavaMD_160/nsys_lavaMD_160-output ./lavaMD -boxes1d 160 >> $GPU_WORK_Final_Original_Work/lavaMD_160/lavaMD_160-output.txt
echo >> $GPU_WORK_Final_Original_Work/lavaMD_160/lavaMD_160-output.txt

echo "END LavaMD-Original Run"

cd $GPU_WORK_Final_CUDA

echo "END JOB"





