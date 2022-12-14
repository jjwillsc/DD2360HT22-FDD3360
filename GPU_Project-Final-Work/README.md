# Rodinia LavaMD2 GPU Profiling and Optimizations

## Background and Description

Rodinia Benchmark Suites are created for heterogeneous computing infrastructures with OpenMP, OpenCL and CUDA applications. 

In Rodinia Benchmark Suite 3.1, LavaMD2 as a selected benchmark, calculates the particle potential and relocation due to mutual forces between particles within a large 3D space, which are divided into cubes or large boxes allocated to individual cluster nodes. https://www.cs.virginia.edu/rodinia/doku.php?id=lavamd2 

 ### Project Scope

The Rodinia LavaMD2 CUDA application was profiled and optimized using CUDA streams to improve data movement and runtime. 

NVIDIA Nsight Systems and/or NVIDIA Nsight Compute was the main profiling tools used on Rodinia LavaMD2 CUDA baseline and optimized versions.

### Computer Architechture and Experiment Setup

The KTH HPC Group GPU system called “NJ” was used and it is equipped with a NVIDIA Ampere Architecture - NVIDIA A100 PCIe 40 GB. 

The below table shows the standard architectureal features on NJ.  

|Name|Value|
| ------------- | ------------- | 
|Model|NVIDIA Ampere|
|Cores|6,912|
|Memory Size|40 GB|
|L1 Cache|192 KB (per SM)|
|L2 Cache|40 MB|
|Memory Type|HBM2e|
|Streaming Multiprocessors (SM)	|108|
|Cores per SM|64|
|Base Clock|765 MHz (0.765 GHz)|
|Boost Clock|1,410 MHz (1.410 GHz)|
|Memory Clock|1,215 MHz|
|FP32 (float) Performance|19.492 Tflops|
|FP64 (float) Performance|9.746 Tflops|

On NJ, the Rodinia LavaMD2 CUDA optimized version was be executed up to 160 boxes (./lavaMD -boxed1D 160) using 4 CUDA streams to improve data transfer and kernel execution.

The below table shows the parameters we used to configure the application for our experimental study. 

|Parameter|	Value|
| ------------- | ------------- | 
|Number of Boxes in One Dimension (boxes1d)|Up to 160|
|Number of Boxes in Three Dimension (Total Number of Boxes)|(boxes1d) (boxes1d) (boxes1d) | 
|Number Par Per (3D) Box|100|
|Total Particles Space |(Total Number of Boxes) (100)|
|Thread Block Size of the Kernel|128|
|Number of CUDA Streams|4|

## Compiling and Building

All source code can be complied and builded using the provided makefile updated from the Rodinia Benchmark Suite 3.1 designed for the LavaMD2 implementations.  

The user can enter “tree” in the command window to display all directories and files as followed:

![lavaMD-directory-review](https://github.com/jjwillsc/DD2360HT22-FDD3360/blob/main/GPU_Project-Final-Work/lavaMD-with-no-Streams/lavaMD-directory-review.png)

Usage:

make clean

make > /scratch/jjwil/GPU_Work/src/.../Review_lavaMD_streams_threads/jjw_output_work/make_compile_out.txt

For Output Validation, a results file (result.txt) will be created after each execution. 
Please use with caution, as this will generate a very large text file and can add extra overhead on the execution. 

Usage:

make clean 

make OUTPUT=Y > /scratch/jjwil/GPU_Work/src/.../Review_lavaMD_streams_threads/jjw_output_work/make_compile_out.txt

## Parameters and Execution 

The code takes the following parameters:

-boxes1d	(number of boxes in one dimension, which is (boxes1d) (boxes1d) (boxes1d) in three dimensions)

The below table shows the input parameters used by the application with one select boxes1d value at a time.

| Parameter   | Value (s)     | 
| ------------- | ------------- | 
| Number of Boxes in One Dimension (boxes1d) | 20, 40, 60, 80, 100, 120, 140 160 | 
| Thread Block Size of the Kernel | 128 | 
| Number of CUDA Streams         | 4 | 

The code can be executed as followed: 

./lavaMD -boxes1d 160 

The following commands were typed before each login session: 

| Name/Purpose   | Command     | 
| ------------- | ------------- | 
| GNU Compiler toolset was installed |  module load gcc | 
| The CUDA toolset was installed|  module load cuda| 
| Show info about available GPUs |  nvidia-smi| 

## Profiling 

As previously mentioned, NVIDIA Nsight Systems and NVIDIA Nsight Compute were used to collect profiling results. 

### NVIDIA Nsight Systems

Usage:

nsys nvprof -o /lavaMD_160/nsys_lavaMD_160-output ./lavaMD -boxes1d 160 >> /lavaMD_160/lavaMD_160-output.txt

### NVIDIA Nsight Compute

Usage:

source ncu --target-processes all -o /lavaMD_160/ncu_lavaMD_160-output ./lavaMD -boxes1d 160 >> /lavaMD_160/lavaMD_160-output.txt

## Performance Results

![LavaMD-CUDA-Streams_UVA_Diff_Pic3](https://github.com/jjwillsc/DD2360HT22-FDD3360/blob/main/GPU_Project-Final-Work/lavaMD-Results-Plots/LavaMD-CUDA-Streams_UVA_Diff_Pic3.png)
