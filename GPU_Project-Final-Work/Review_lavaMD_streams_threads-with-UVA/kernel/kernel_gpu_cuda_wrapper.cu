//========================================================================================================================================================================================================200
//	DEFINE/INCLUDE
//========================================================================================================================================================================================================200

#include <stdio.h>
#include <cuda_runtime.h> 
#include <stdlib.h>
#include <math.h>
 
#define DataType double

//======================================================================================================================================================150
//	MAIN FUNCTION HEADER
//======================================================================================================================================================150

#include "./../main.h"								// (in the main program folder)	needed to recognized input parameters


//======================================================================================================================================================150
//	UTILITIES
//======================================================================================================================================================150

#include "./../util/device/device.h"				// (in library path specified to compiler)	needed by for device functions
#include "./../util/timer/timer.h"					// (in library path specified to compiler)	needed by timer

//======================================================================================================================================================150
//	KERNEL_GPU_CUDA_WRAPPER FUNCTION HEADER
//======================================================================================================================================================150

#include "./kernel_gpu_cuda_wrapper.h"				// (in the current directory)

//======================================================================================================================================================150
//	KERNEL
//======================================================================================================================================================150

#include "./kernel_gpu_cuda.cu"						// (in the current directory)	GPU kernel, cannot include with header file because of complications with passing of constant memory variables

//========================================================================================================================================================================================================200
//	KERNEL_GPU_CUDA_WRAPPER FUNCTION
//========================================================================================================================================================================================================200

void 
kernel_gpu_cuda_wrapper(par_str par_cpu,
						dim_str dim_cpu,
						box_str* box_cpu,
						FOUR_VECTOR* rv_cpu,
						fp* qv_cpu,
						FOUR_VECTOR* fv_cpu)


{

	//======================================================================================================================================================150
	//	CPU VARIABLES
	//======================================================================================================================================================150

	// timer
	long long time0;
	long long time1;
	long long time2;
	long long time3;
	long long time4;
	long long time5;
	long long time6;

	time0 = get_time();

	//======================================================================================================================================================150
	//	GPU SETUP
	//======================================================================================================================================================150

	//====================================================================================================100
	//	INITIAL DRIVER OVERHEAD
	//====================================================================================================100

	cudaThreadSynchronize();

	//====================================================================================================100
	//	VARIABLES
	//====================================================================================================100

	box_str* d_box_gpu;
	FOUR_VECTOR* d_rv_gpu;
	fp* d_qv_gpu;
	FOUR_VECTOR* d_fv_gpu;

        int streamCount = 4;
        printf("CUDA Stream Count: %d\n", streamCount);

	dim3 threads;
	dim3 blocks;  

        //====================================================================================================100
        //      EXECUTION PARAMETERS
        //====================================================================================================100

        blocks.x = dim_cpu.number_boxes / (streamCount * NUMBER_THREADS);
        blocks.y = 1;
        threads.x = NUMBER_THREADS;                                                                                    // define the number of threads in the block
        threads.y = 1;

	time1 = get_time();

	//======================================================================================================================================================150
	//	GPU MEMORY				(MALLOC)
	//======================================================================================================================================================150

	//====================================================================================================100
	//	GPU MEMORY				(MALLOC) COPY IN
	//====================================================================================================100

#if defined(USE_STREAM)

	cudaMalloc((void**)&d_box_gpu, dim_cpu.box_mem);
	cudaMalloc((void**)&d_rv_gpu, dim_cpu.space_mem);
	cudaMalloc((void**)&d_qv_gpu, dim_cpu.space_mem2);
	cudaMalloc((void**)&d_fv_gpu, dim_cpu.space_mem);

	cudaStream_t* streams = (cudaStream_t*)malloc(sizeof(cudaStream_t) * streamCount);

	for (int i = 0; i < streamCount; i++) {

		cudaStreamCreate(&streams[i]);

                time2 = get_time();                 
	
                //cudaMemcpyAsync(d_box_gpu, box_cpu, dim_cpu.box_mem, cudaMemcpyHostToDevice, streams[i]);
                //cudaMemcpyAsync(d_rv_gpu, rv_cpu, dim_cpu.space_mem, cudaMemcpyHostToDevice, streams[i]);
                //cudaMemcpyAsync(d_qv_gpu, qv_cpu, dim_cpu.space_mem2, cudaMemcpyHostToDevice, streams[i]);
                //cudaMemcpyAsync(d_fv_gpu, fv_cpu, dim_cpu.space_mem, cudaMemcpyHostToDevice, streams[i]);

                cudaMemcpyAsync(d_box_gpu, box_cpu, dim_cpu.box_mem, cudaMemcpyDefault, streams[i]);
                cudaMemcpyAsync(d_rv_gpu, rv_cpu, dim_cpu.space_mem, cudaMemcpyDefault, streams[i]);
                cudaMemcpyAsync(d_qv_gpu, qv_cpu, dim_cpu.space_mem2, cudaMemcpyDefault, streams[i]);
                cudaMemcpyAsync(d_fv_gpu, fv_cpu, dim_cpu.space_mem, cudaMemcpyDefault, streams[i]);

                cudaStreamSynchronize(streams[i]);

        }

        //======================================================================================================================================================150
        //      KERNEL
        //======================================================================================================================================================150

       	for (int i = 0; i < streamCount; i++) {

                time3 = get_time();

		// launch kernel - all boxes

                kernel_gpu_cuda<<<blocks, threads, 0, streams[i]>>>(par_cpu, dim_cpu, d_box_gpu, d_rv_gpu, d_qv_gpu, d_fv_gpu);

		checkCUDAError("Start");
        	cudaThreadSynchronize();

          	cudaStreamSynchronize(streams[i]);

	}
 
        //======================================================================================================================================================150
        //      GPU MEMORY                      COPY (CONTD.)
        //======================================================================================================================================================150


        for (int i = 0; i < streamCount; i++) {

               	time4 = get_time();

                //cudaMemcpyAsync(fv_cpu, d_fv_gpu, dim_cpu.space_mem, cudaMemcpyDeviceToHost, streams[i]);

                cudaMemcpyAsync(fv_cpu, d_fv_gpu, dim_cpu.space_mem, cudaMemcpyDefault, streams[i]);

                cudaStreamSynchronize(streams[i]);
        }


        //======================================================================================================================================================150
        //      GPU MEMORY DEALLOCATION
        //======================================================================================================================================================150


       	for (int i = 0; i < streamCount; i++) {
                cudaStreamDestroy(streams[i]);
       	}
      	free(streams);  

#endif

	time5 = get_time();

	cudaFree(d_rv_gpu);
	cudaFree(d_qv_gpu);
	cudaFree(d_fv_gpu);
	cudaFree(d_box_gpu);

	time6 = get_time();	

	//======================================================================================================================================================150
	//	DISPLAY TIMING
	//======================================================================================================================================================150

	printf("Time spent in different stages of GPU_CUDA KERNEL:\n");

	printf("%15.12f s, %15.12f % : GPU: SET DEVICE / DRIVER INIT\n",	(float) (time1-time0) / TIME_DIVIDER, (float) (time1-time0) / (float) (time6-time0) * 100);
	printf("%15.12f s, %15.12f % : GPU MEM: ALO\n", 					(float) (time2-time1) / TIME_DIVIDER, (float) (time2-time1) / (float) (time6-time0) * 100);
	printf("%15.12f s, %15.12f % : GPU MEM: COPY IN\n",					(float) (time3-time2) / TIME_DIVIDER, (float) (time3-time2) / (float) (time6-time0) * 100);

	printf("%15.12f s, %15.12f % : GPU: KERNEL\n",						(float) (time4-time3) / TIME_DIVIDER, (float) (time4-time3) / (float) (time6-time0) * 100);

	printf("%15.12f s, %15.12f % : GPU MEM: COPY OUT\n",				(float) (time5-time4) / TIME_DIVIDER, (float) (time5-time4) / (float) (time6-time0) * 100);
	printf("%15.12f s, %15.12f % : GPU MEM: FRE\n", 					(float) (time6-time5) / TIME_DIVIDER, (float) (time6-time5) / (float) (time6-time0) * 100);

	printf("Total time:\n");
	printf("%.12f s\n", 												(float) (time6-time0) / TIME_DIVIDER);

}
