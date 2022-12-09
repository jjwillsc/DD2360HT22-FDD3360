#ifndef Alloc_H
#define Alloc_H
#include <stdlib.h>
#include <cstdio>
#include <cuda_runtime.h>

using std::exit;

#define checkCudaErrors(val) check((val), #val, __FILE__, __LINE__)

#define pos(sy, sz, i, j, k) (i * sy * sz + j * sz + k);

// CUDA Runtime error messages
#ifdef __DRIVER_TYPES_H__
static const char* _cudaGetErrorEnum(cudaError_t error) {
    return cudaGetErrorName(error);
}
#endif

template <typename T>
void check(T result, char const* const func, const char* const file,
    int const line) {
    if (result) {
        fprintf(stderr, "CUDA error at %s:%d code=%d(%s) \"%s\" \n", file, line,
            static_cast<unsigned int>(result), _cudaGetErrorEnum(result), func);
        exit(0);

    }
}

__host__ __device__
inline long get_idx(long v, long w, long x, long y, long z, long stride_w, long stride_x, long stride_y, long stride_z)
{
    return stride_x * stride_y * stride_z * w + stride_y * stride_z * x + stride_z * y + z;
}

__host__ __device__
inline long get_idx(long w, long x, long y, long z, long stride_x, long stride_y, long stride_z)
{
    return stride_x * stride_y * stride_z * w + stride_y * stride_z * x + stride_z * y + z;
}

__host__ __device__
inline long get_idx(long x, long y, long z, long stride_y, long stride_z)
{
    return stride_y * stride_z * x + stride_z * y + z;
}

__host__ __device__
inline long get_idx(long x, long y, long s1)
{
    return x + (y * s1);
}


template < class type >
inline type *newArr1(size_t sz1)
{
  type *arr = new type[sz1];
  return arr;
}

template < class type >
inline type **newArr2(size_t sz1, size_t sz2)
{
  type **arr = new type*[sz1]; // new type *[sz1];
  type *ptr = newArr1<type>(sz1*sz2);
  for (size_t i = 0; i < sz1; i++)
  {
    arr[i] = ptr;
    ptr += sz2;
  }
  return arr;
}

template < class type >
inline type ***newArr3(size_t sz1, size_t sz2, size_t sz3)
{
  type ***arr = new type**[sz1]; // new type **[sz1];
  type **ptr = newArr2<type>(sz1*sz2, sz3);
  for (size_t i = 0; i < sz1; i++)
  {
    arr[i] = ptr;
    ptr += sz2;
  }
  return arr;
}


template <class type>
inline type ****newArr4(size_t sz1, size_t sz2, size_t sz3, size_t sz4)
{
  type ****arr = new type***[sz1]; //(new type ***[sz1]);
  type ***ptr = newArr3<type>(sz1*sz2, sz3, sz4);
  for (size_t i = 0; i < sz1; i++) {
    arr[i] = ptr;
    ptr += sz2;
  }
  return arr;
}

// build chained pointer hierarchy for pre-existing bottom level
//

/* Build chained pointer hierachy for pre-existing bottom level                        *
 * Provide a pointer to a contig. 1D memory region which was already allocated in "in" *
 * The function returns a pointer chain to which allows subscript access (x[i][j])     */
template <class type>
inline type *****newArr5(type **in, size_t sz1, size_t sz2, size_t sz3, size_t sz4, size_t sz5)
{
  *in = newArr1<type>(sz1*sz2*sz3*sz4*sz5);

  type*****arr = newArr4<type*>(sz1,sz2,sz3,sz4);
  type**arr2 = ***arr;
  type *ptr = *in;
  size_t szarr2 = sz1*sz2*sz3*sz4;
  for(size_t i=0;i<szarr2;i++) {
    arr2[i] = ptr;
    ptr += sz5;
  }
  return arr;
}

template <class type>
inline type ****newArr4(type **in, size_t sz1, size_t sz2, size_t sz3, size_t sz4)
{
  *in = newArr1<type>(sz1*sz2*sz3*sz4);

  type****arr = newArr3<type*>(sz1,sz2,sz3);
  type**arr2 = **arr;
  type *ptr = *in;
  size_t szarr2 = sz1*sz2*sz3;
  for(size_t i=0;i<szarr2;i++) {
    arr2[i] = ptr;
    ptr += sz4;
  }
  return arr;
}

template <class type>
inline type ***newArr3(type **in, size_t sz1, size_t sz2, size_t sz3)
{
  *in = newArr1<type>(sz1*sz2*sz3);

  type***arr = newArr2<type*>(sz1,sz2);
  type**arr2 = *arr;
  type *ptr = *in;
  size_t szarr2 = sz1*sz2;
  for(size_t i=0;i<szarr2;i++) {
    arr2[i] = ptr;
    ptr += sz3;
  }
  return arr;
}

template <class type>
inline type **newArr2(type **in, size_t sz1, size_t sz2)
{
  *in = newArr1<type>(sz1*sz2);
  type**arr = newArr1<type*>(sz1);
  type *ptr = *in;
  for(size_t i=0;i<sz1;i++) {
    arr[i] = ptr;
    ptr += sz2;
  }
  return arr;
}

// methods to deallocate arrays
//
template < class type > inline void delArray1(type * arr)
{ delete[](arr); }
template < class type > inline void delArray2(type ** arr)
{ delArray1(arr[0]); delete[](arr); }
template < class type > inline void delArray3(type *** arr)
{ delArray2(arr[0]); delete[](arr); }
template < class type > inline void delArray4(type **** arr)
{ delArray3(arr[0]); delete[](arr); }
//
// versions with dummy dimensions (for backwards compatibility)
//
template <class type> inline void delArr1(type * arr)
{ delArray1<type>(arr); }
template <class type> inline void delArr2(type ** arr, size_t sz1)
{ delArray2<type>(arr); }
template <class type> inline void delArr3(type *** arr, size_t sz1, size_t sz2)
{ delArray3<type>(arr); }
template <class type> inline void delArr4(type **** arr, size_t sz1, size_t sz2, size_t sz3)
{ delArray4<type>(arr); }

#define newArr1(type, sz1) newArr1<type>(sz1)
#define newArr(type,sz1,sz2) newArr2<type>(sz1, sz2)
#define newArr2(type, sz1, sz2) newArr2<type>(sz1, sz2)
#define newArr3(type, sz1, sz2, sz3) newArr3<type>(sz1, sz2, sz3)
#define newArr4(type, sz1, sz2, sz3, sz4) newArr4<type>(sz1, sz2, sz3, sz4)


// GPU

template < class type >
inline type* newArr1GPU(size_t sz1)
{
    type* arr;
    checkCudaErrors(cudaMallocManaged(&arr, sizeof(type) * sz1));
    return arr;
}

template < class type >
inline type** newArr2GPU(size_t sz1, size_t sz2)
{
    type** arr;
    cudaMallocManaged(&arr, sizeof(type*) * sz1);
    type* ptr = newArr1GPU<type>(sz1 * sz2);
    for (size_t i = 0; i < sz1; i++)
    {
        arr[i] = ptr;
        ptr += sz2;
    }
    return arr;
}

template < class type >
inline type*** newArr3GPU(size_t sz1, size_t sz2, size_t sz3)
{
    type*** arr;
    cudaMallocManaged(&arr, sizeof(type**) * sz1);
    type** ptr = newArr2GPU<type>(sz1 * sz2, sz3);
    for (size_t i = 0; i < sz1; i++)
    {
        arr[i] = ptr;
        ptr += sz2;
    }
    return arr;
}

template <class type>
inline type**** newArr4GPU(size_t sz1, size_t sz2, size_t sz3, size_t sz4)
{
    type**** arr;
    cudaMallocManaged(&arr, sizeof(type***) * sz1);
    type*** ptr = newArr3GPU<type>(sz1 * sz2, sz3, sz4);
    for (size_t i = 0; i < sz1; i++) {
        arr[i] = ptr;
        ptr += sz2;
    }
    return arr;
}

// build chained pointer hierarchy for pre-existing bottom level
//

/* Build chained pointer hierachy for pre-existing bottom level                        *
 * Provide a pointer to a contig. 1D memory region which was already allocated in "in" *
 * The function returns a pointer chain to which allows subscript access (x[i][j])     */
template <class type>
inline type***** newArr5GPU(type** in, size_t sz1, size_t sz2, size_t sz3, size_t sz4, size_t sz5)
{
    *in = newArr1GPU<type>(sz1 * sz2 * sz3 * sz4 * sz5);

    type***** arr = newArr4<type*>(sz1, sz2, sz3, sz4);;
    type** arr2 = ***arr;
    type* ptr = *in;
    size_t szarr2 = sz1 * sz2 * sz3 * sz4;
    for (size_t i = 0; i < szarr2; i++) {
        arr2[i] = ptr;
        ptr += sz5;
    }
    return arr;
}

template <class type>
inline type**** newArr4GPU(type** in, size_t sz1, size_t sz2, size_t sz3, size_t sz4)
{
    *in = newArr1GPU<type>(sz1 * sz2 * sz3 * sz4);

    type**** arr = newArr3<type*>(sz1, sz2, sz3);
    type** arr2 = **arr;
    type* ptr = *in;
    size_t szarr2 = sz1 * sz2 * sz3;
    for (size_t i = 0; i < szarr2; i++) {
        arr2[i] = ptr;
        ptr += sz4;
    }
    return arr;
}

template <class type>
inline type*** newArr3GPU(type** in, size_t sz1, size_t sz2, size_t sz3)
{
    *in = newArr1GPU<type>(sz1 * sz2 * sz3);

    type*** arr = newArr2<type*>(sz1, sz2);
    type** arr2 = *arr;
    type* ptr = *in;
    size_t szarr2 = sz1 * sz2;
    for (size_t i = 0; i < szarr2; i++) {
        arr2[i] = ptr;
        ptr += sz3;
    }
    return arr;
}

template <class type>
inline type** newArr2GPU(type** in, size_t sz1, size_t sz2)
{
    *in = newArr1GPU<type>(sz1 * sz2);
    type** arr = newArr1<type*>(sz1);
    type* ptr = *in;
    for (size_t i = 0; i < sz1; i++) {
        arr[i] = ptr;
        ptr += sz2;
    }
    return arr;
}

// methods to deallocate arrays
//
template < class type > inline void delArray1GPU(type* arr)
{
    cudaFree(arr);
}
template < class type > inline void delArray2GPU(type** arr)
{
    delArray1GPU(arr[0]); cudaFree(arr);
}
template < class type > inline void delArray3GPU(type*** arr)
{
    delArray2GPU(arr[0]); cudaFree(arr);
}
template < class type > inline void delArray4GPU(type**** arr)
{
    delArray3GPU(arr[0]); cudaFree(arr);
}
//
// versions with dummy dimensions (for backwards compatibility)
//
template <class type> inline void delArr1GPU(type* arr)
{
    delArray1GPU<type>(arr);
}
template <class type> inline void delArr2GPU(type** arr, size_t sz1)
{
    delArray2GPU<type>(arr);
}
template <class type> inline void delArr3GPU(type*** arr, size_t sz1, size_t sz2)
{
    delArray3GPU<type>(arr);
}
template <class type> inline void delArr4GPU(type**** arr, size_t sz1, size_t sz2, size_t sz3)
{
    delArray4GPU<type>(arr);
}

#define newArr1GPU(type, sz1) newArr1GPU<type>(sz1)
#define newArrGPU(type,sz1,sz2) newArr2GPU<type>(sz1, sz2)
#define newArr2GPU(type, sz1, sz2) newArr2GPU<type>(sz1, sz2)
#define newArr3GPU(type, sz1, sz2, sz3) newArr3GPU<type>(sz1, sz2, sz3)
#define newArr4GPU(type, sz1, sz2, sz3, sz4) newArr4GPU<type>(sz1, sz2, sz3, sz4)

#endif
