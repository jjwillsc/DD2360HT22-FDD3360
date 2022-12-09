#include "EMfield.h"

/** allocate electric and magnetic field */
void field_allocate(struct grid* grd, struct EMfield* field)
{
    // E on nodes
    field->x = newArr1<FPfield>(grd_dim(grd));
    field->y = newArr1<FPfield>(grd_dim(grd));
    field->z = newArr1<FPfield>(grd_dim(grd));

    // B on nodes
    field->xn = newArr1<FPfield>(grd_dim(grd));
    field->yn = newArr1<FPfield>(grd_dim(grd));
    field->zn = newArr1<FPfield>(grd_dim(grd));
}

void field_allocateGPU(struct grid* grd, struct EMfield* field)
{
    // E on nodes
    checkCudaErrors(cudaMallocManaged(&field->x, sizeof(FPfield) * grd_dim(grd)));
    checkCudaErrors(cudaMallocManaged(&field->y, sizeof(FPfield) * grd_dim(grd)));
    checkCudaErrors(cudaMallocManaged(&field->z, sizeof(FPfield) * grd_dim(grd)));

    // B on nodes
    checkCudaErrors(cudaMallocManaged(&field->xn, sizeof(FPfield) * grd_dim(grd)));
    checkCudaErrors(cudaMallocManaged(&field->yn, sizeof(FPfield) * grd_dim(grd)));
    checkCudaErrors(cudaMallocManaged(&field->zn, sizeof(FPfield) * grd_dim(grd)));
}

void copyEMfieldGPU(struct EMfield* dest, struct EMfield* src, struct grid* grd, bool host2CUDA /*= true*/)
{
    // calculate the coordinates - Nodes
    checkCudaErrors(cudaMemcpy(dest->x, src->x, sizeof(FPfield) * grd_dim(grd), host2CUDA ? cudaMemcpyHostToDevice : cudaMemcpyDeviceToHost));
    checkCudaErrors(cudaMemcpy(dest->y, src->y, sizeof(FPfield) * grd_dim(grd), host2CUDA ? cudaMemcpyHostToDevice : cudaMemcpyDeviceToHost));
    checkCudaErrors(cudaMemcpy(dest->z, src->z, sizeof(FPfield) * grd_dim(grd), host2CUDA ? cudaMemcpyHostToDevice : cudaMemcpyDeviceToHost));

    checkCudaErrors(cudaMemcpy(dest->xn, src->xn, sizeof(FPfield) * grd_dim(grd), host2CUDA ? cudaMemcpyHostToDevice : cudaMemcpyDeviceToHost));
    checkCudaErrors(cudaMemcpy(dest->yn, src->yn, sizeof(FPfield) * grd_dim(grd), host2CUDA ? cudaMemcpyHostToDevice : cudaMemcpyDeviceToHost));
    checkCudaErrors(cudaMemcpy(dest->zn, src->zn, sizeof(FPfield) * grd_dim(grd), host2CUDA ? cudaMemcpyHostToDevice : cudaMemcpyDeviceToHost));

}

/** deallocate electric and magnetic field */
void field_deallocate(struct EMfield* field)
{
    // E deallocate 3D arrays
    delete[] field->x;
    delete[] field->y;
    delete[] field->z;

    // B deallocate 3D arrays
    delete[] field->xn;
    delete[] field->yn;
    delete[] field->zn;
}

void field_deallocateGPU(struct EMfield* field)
{
    // E deallocate 3D arrays
    cudaFree(field->x);
    cudaFree(field->y);
    cudaFree(field->z);

    // B deallocate 3D arrays
    cudaFree(field->xn);
    cudaFree(field->yn);
    cudaFree(field->zn);
}
