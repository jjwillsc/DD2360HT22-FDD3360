#include <iostream>
#include "Grid.h"
#include "EMfield.h"

/** Set up the grid quantities */
void setGrid(struct parameters* param, struct grid* grd)
{
    
    ///////////////////////////////
    // add 2 for the guard cells
    // useful for BC and potential domain decomposition
    grd->nxc = param->nxc + 2;
    grd->nyc = param->nyc + 2;
    grd->nzc = param->nzc + 2;
    
    grd->nxn = grd->nxc + 1;
    grd->nyn = grd->nyc + 1;
    grd->nzn = grd->nzc + 1;
    ////////////////
    ///////////////////////////////
    
    grd->dx = param->Lx / param->nxc;
    grd->dy = param->Ly / param->nyc;
    grd->dz = param->Lz / param->nzc;
    
    // These are used in mover and interpolation from particles
    grd->invVOL = (FPfield) 1.0 / (grd->dx * grd->dy * grd->dz);
    grd->invdx = (FPfield) 1.0 / grd->dx;
    grd->invdy = (FPfield) 1.0 / grd->dy;
    grd->invdz = (FPfield) 1.0 / grd->dz;
    
    // local grid dimensions and boundaries of active nodes
    grd->xStart = 0.0;
    grd->xEnd = param->Lx;
    
    grd->yStart = 0.0;
    grd->yEnd = param->Ly;
    
    grd->zStart = 0.0;
    grd->zEnd = param->Lz;
    
    grd->Lx= param->Lx;
    grd->Ly = param->Ly;
    grd->Lz = param->Lz;
    
    grd->PERIODICX = param->PERIODICX;
    grd->PERIODICY = param->PERIODICY;
    grd->PERIODICZ = param->PERIODICZ;
    
    // allocate grid points - nodes
    grd->xn = newArr1<FPfield>(grd_dim(grd));
    grd->yn = newArr1<FPfield>(grd_dim(grd));
    grd->zn = newArr1<FPfield>(grd_dim(grd));

    for (int i = 0; i < grd->nxn; i++) {
        for (int j = 0; j < grd->nyn; j++) {
            for (int k = 0; k < grd->nzn; k++) {
                int p = pos(grd->nyn, grd->nzn, i, j, k);
                grd->xn[p] = (FPfield)(grd->xStart + (i - 1) * grd->dx);
                grd->yn[p] = (FPfield)(grd->yStart + (j - 1) * grd->dy);
                grd->zn[p] = (FPfield)(grd->zStart + (k - 1) * grd->dz);
            }
        }
    }
}


void allocateGridGPU(struct parameters* param, struct grid* grd)
{
    ///////////////////////////////
    // add 2 for the guard cells
    // useful for BC and potential domain decomposition
    grd->nxc = param->nxc + 2;
    grd->nyc = param->nyc + 2;
    grd->nzc = param->nzc + 2;

    grd->nxn = grd->nxc + 1;
    grd->nyn = grd->nyc + 1;
    grd->nzn = grd->nzc + 1;

    // allocate grid points - nodes
    checkCudaErrors(cudaMallocManaged(&grd->xn, sizeof(FPfield) * grd_dim(grd)));
    checkCudaErrors(cudaMallocManaged(&grd->yn, sizeof(FPfield) * grd_dim(grd)));
    checkCudaErrors(cudaMallocManaged(&grd->zn, sizeof(FPfield) * grd_dim(grd)));
}

void copyGridGPU(struct grid* dest, struct grid* src, bool host2CUDA /*= true*/)
{
    grid temp = *dest;
    *dest = *src;

    checkCudaErrors(cudaMemcpy(temp.xn, src->xn, sizeof(FPfield) * grd_dim(src), host2CUDA ? cudaMemcpyHostToDevice : cudaMemcpyDeviceToHost));
    checkCudaErrors(cudaMemcpy(temp.yn, src->yn, sizeof(FPfield) * grd_dim(src), host2CUDA ? cudaMemcpyHostToDevice : cudaMemcpyDeviceToHost));
    checkCudaErrors(cudaMemcpy(temp.zn, src->zn, sizeof(FPfield) * grd_dim(src), host2CUDA ? cudaMemcpyHostToDevice : cudaMemcpyDeviceToHost));

    dest->xn = temp.xn;
    dest->yn = temp.yn;
    dest->zn = temp.zn;
}


/** Set up the grid quantities */
void printGrid(struct grid* grd)
{
    std::cout << std::endl;
    std::cout << "**** Grid Information - Include Ghost Cells ****" << std::endl;
    std::cout << "Number of cell: -X = " << grd->nxc  << ", -Y = " << grd->nyc << ", -Z =" << grd->nzc << std::endl;
    std::cout << "Lx = " << grd->Lx  << ", Ly = " << grd->Ly << ", Lz =" << grd->Lz << std::endl;
    std::cout << "PERIODICX = " << grd->PERIODICX  << ", PERIODICY = " << grd->PERIODICY << ", PERIODICZ =" << grd->PERIODICZ << std::endl;
    std::cout << std::endl;
}

/** allocate electric and magnetic field */
void grid_deallocate(struct grid* grd)
{
    delete[] grd->xn;
    delete[] grd->yn;
    delete[] grd->zn;

}

void grid_deallocateGPU(struct grid* grd)
{
    cudaFree(grd->xn);
    cudaFree(grd->yn);
    cudaFree(grd->zn);
}


/** interpolation Node to Center */
void interpN2Cfield(FPfield ***vecFieldCx, FPfield ***vecFieldCy, FPfield ***vecFieldCz, struct grid* grd, struct EMfield* field)
{
    // Here I changed from 1 to 0. I assume that the BC have been applied on the first.
    for (register int i = 0; i < grd->nxc; i++)
        for (register int j = 0; j < grd->nyc; j++)
            for (register int k = 0; k < grd->nzc; k++){
                // X - component
                vecFieldCx[i][j][k] = .125 * (field_xn(i, j, k) + field_xn(i + 1, j, k) + field_xn(i, j + 1, k) + field_xn(i, j, k + 1) + 
                    field_xn(i + 1, j + 1, k) + field_xn(i + 1, j , k + 1) + field_xn(i, j + 1 , k + 1) + field_xn(i + 1, j + 1 , k + 1));
                // Y - component
                vecFieldCy[i][j][k] = .125 * (field_yn(i, j, k) + field_yn(i + 1, j, k) + field_yn(i, j + 1, k) + field_yn(i, j, k + 1) + 
                    field_yn(i + 1, j + 1, k) + field_yn(i + 1, j , k + 1) + field_yn(i, j + 1 , k + 1) + field_yn(i + 1, j + 1 , k + 1));
                // Z - component
                vecFieldCz[i][j][k] = .125 * (field_zn(i, j, k) + field_zn(i + 1, j, k) + field_zn(i, j + 1, k) + field_zn(i, j, k + 1) + 
                    field_zn(i + 1, j + 1, k) + field_zn(i + 1, j , k + 1) + field_zn(i, j + 1 , k + 1) + field_zn(i + 1, j + 1 , k + 1));
            }
    
    
}

/** interpolation Node to Center */
void interpC2Ninterp(FPinterp ***vecFieldN, FPinterp ***vecFieldC, struct grid* grd)
{
    // nodes
    int nxn = grd->nxn;
    int nyn = grd->nyn;
    int nzn = grd->nzn;
    
    
    for (register int i = 1; i < nxn - 1; i++)
        for (register int j = 1; j < nyn - 1; j++)
            for (register int k = 1; k < nzn - 1; k++)
                vecFieldN[i][j][k] = .125 * (vecFieldC[i][j][k] + vecFieldC[i - 1][j][k] + vecFieldC[i][j - 1][k] + vecFieldC[i][j][k - 1] + vecFieldC[i - 1][j - 1][k] + vecFieldC[i - 1][j][k - 1] + vecFieldC[i][j - 1][k - 1] + vecFieldC[i - 1][j - 1][k - 1]);
    
}

/** interpolation Node to Center */
void interpC2Nfield(FPfield ***vecFieldN, FPfield ***vecFieldC, struct grid* grd)
{
    // nodes
    int nxn = grd->nxn;
    int nyn = grd->nyn;
    int nzn = grd->nzn;
    
    
    for (register int i = 1; i < nxn - 1; i++)
        for (register int j = 1; j < nyn - 1; j++)
            for (register int k = 1; k < nzn - 1; k++)
                vecFieldN[i][j][k] = .125 * (vecFieldC[i][j][k] + vecFieldC[i - 1][j][k] + vecFieldC[i][j - 1][k] + vecFieldC[i][j][k - 1] + vecFieldC[i - 1][j - 1][k] + vecFieldC[i - 1][j][k - 1] + vecFieldC[i][j - 1][k - 1] + vecFieldC[i - 1][j - 1][k - 1]);
    
}


/** interpolation Node to Center */
void interpN2Cinterp(FPinterp ***vecFieldC, FPinterp ***vecFieldN, struct grid* grd)
{
    // centers
    int nxc = grd->nxc;
    int nyc = grd->nyc;
    int nzc = grd->nzc;
    
    for (register int i = 1; i < nxc - 1; i++)
        for (register int j = 1; j < nyc - 1; j++)
            for (register int k = 1; k < nzc - 1; k++)
                vecFieldC[i][j][k] = .125 * (vecFieldN[i][j][k] + vecFieldN[i + 1][j][k] + vecFieldN[i][j + 1][k] + vecFieldN[i][j][k + 1] + vecFieldN[i + 1][j + 1][k] + vecFieldN[i + 1][j][k + 1] + vecFieldN[i][j + 1][k + 1] + vecFieldN[i + 1][j + 1][k + 1]);
}




/** calculate gradient on nodes, given a scalar field defined on central points  */
void gradC2N(FPfield ***gradxn, FPfield ***gradyn, FPfield ***gradzn, FPfield ***scFieldC, grid* grd)
{
    
    // nodes
    int nxn = grd->nxn;
    int nyn = grd->nyn;
    int nzn = grd->nzn;
    
    // inv. dx, dy, dz
    FPfield invdx = grd->invdx;
    FPfield invdy = grd->invdy;
    FPfield invdz = grd->invdz;
    
    
    for (register int i = 1; i < nxn - 1; i++)
        for (register int j = 1; j < nyn - 1; j++)
            for (register int k = 1; k < nzn - 1; k++) {
                gradxn[i][j][k] = .25 * (scFieldC[i][j][k] - scFieldC[i - 1][j][k]) * invdx + .25 * (scFieldC[i][j][k - 1] - scFieldC[i - 1][j][k - 1]) * invdx + .25 * (scFieldC[i][j - 1][k] - scFieldC[i - 1][j - 1][k]) * invdx + .25 * (scFieldC[i][j - 1][k - 1] - scFieldC[i - 1][j - 1][k - 1]) * invdx;
                gradyn[i][j][k] = .25 * (scFieldC[i][j][k] - scFieldC[i][j - 1][k]) * invdy + .25 * (scFieldC[i][j][k - 1] - scFieldC[i][j - 1][k - 1]) * invdy + .25 * (scFieldC[i - 1][j][k] - scFieldC[i - 1][j - 1][k]) * invdy + .25 * (scFieldC[i - 1][j][k - 1] - scFieldC[i - 1][j - 1][k - 1]) * invdy;
                gradzn[i][j][k] = .25 * (scFieldC[i][j][k] - scFieldC[i][j][k - 1]) * invdz + .25 * (scFieldC[i - 1][j][k] - scFieldC[i - 1][j][k - 1]) * invdz + .25 * (scFieldC[i][j - 1][k] - scFieldC[i][j - 1][k - 1]) * invdz + .25 * (scFieldC[i - 1][j - 1][k] - scFieldC[i - 1][j - 1][k - 1]) * invdz;
            }
    
    
}



/** calculate gradient on nodes, given a scalar field defined on central points  */
void gradN2C(FPfield ***gradXC, FPfield ***gradYC, FPfield ***gradZC, FPfield ***scFieldN, grid* grd)
{
    
    // center cells
    int nxc = grd->nxc;
    int nyc = grd->nyc;
    int nzc = grd->nzc;
    
    // inv. dx, dy, dz
    FPfield invdx = grd->invdx;
    FPfield invdy = grd->invdy;
    FPfield invdz = grd->invdz;
    
    
    
    for (register int i = 1; i < nxc - 1; i++)
        for (register int j = 1; j < nyc - 1; j++)
            for (register int k = 1; k < nzc - 1; k++) {
                gradXC[i][j][k] = .25 * (scFieldN[i + 1][j][k] - scFieldN[i][j][k]) * invdx + .25 * (scFieldN[i + 1][j][k + 1] - scFieldN[i][j][k + 1]) * invdx + .25 * (scFieldN[i + 1][j + 1][k] - scFieldN[i][j + 1][k]) * invdx + .25 * (scFieldN[i + 1][j + 1][k + 1] - scFieldN[i][j + 1][k + 1]) * invdx;
                gradYC[i][j][k] = .25 * (scFieldN[i][j + 1][k] - scFieldN[i][j][k]) * invdy + .25 * (scFieldN[i][j + 1][k + 1] - scFieldN[i][j][k + 1]) * invdy + .25 * (scFieldN[i + 1][j + 1][k] - scFieldN[i + 1][j][k]) * invdy + .25 * (scFieldN[i + 1][j + 1][k + 1] - scFieldN[i + 1][j][k + 1]) * invdy;
                gradZC[i][j][k] = .25 * (scFieldN[i][j][k + 1] - scFieldN[i][j][k]) * invdz + .25 * (scFieldN[i + 1][j][k + 1] - scFieldN[i + 1][j][k]) * invdz + .25 * (scFieldN[i][j + 1][k + 1] - scFieldN[i][j + 1][k]) * invdz + .25 * (scFieldN[i + 1][j + 1][k + 1] - scFieldN[i + 1][j + 1][k]) * invdz;
            }
}



/** calculate divergence on central points, given a vector field defined on nodes  */
void divN2C(FPfield ***divC, FPfield ***vecFieldxn, FPfield ***vecFieldyn, FPfield ***vecFieldzn, grid* grd)
{
    
    
    // nodes
    int nxc = grd->nxc;
    int nyc = grd->nyc;
    int nzc = grd->nzc;
    
    // inv. dx, dy, dz
    FPfield invdx = grd->invdx;
    FPfield invdy = grd->invdy;
    FPfield invdz = grd->invdz;
    
    
    // three components of field solver
    FPfield compX;
    FPfield compY;
    FPfield compZ;
    
    
    for (register int i = 1; i < nxc - 1; i++)
        for (register int j = 1; j < nyc - 1; j++)
            for (register int k = 1; k < nzc - 1; k++) {
                compX = .25 * (vecFieldxn[i + 1][j][k] - vecFieldxn[i][j][k]) * invdx + .25 * (vecFieldxn[i + 1][j][k + 1] - vecFieldxn[i][j][k + 1]) * invdx + .25 * (vecFieldxn[i + 1][j + 1][k] - vecFieldxn[i][j + 1][k]) * invdx + .25 * (vecFieldxn[i + 1][j + 1][k + 1] - vecFieldxn[i][j + 1][k + 1]) * invdx;
                compY = .25 * (vecFieldyn[i][j + 1][k] - vecFieldyn[i][j][k]) * invdy + .25 * (vecFieldyn[i][j + 1][k + 1] - vecFieldyn[i][j][k + 1]) * invdy + .25 * (vecFieldyn[i + 1][j + 1][k] - vecFieldyn[i + 1][j][k]) * invdy + .25 * (vecFieldyn[i + 1][j + 1][k + 1] - vecFieldyn[i + 1][j][k + 1]) * invdy;
                compZ = .25 * (vecFieldzn[i][j][k + 1] - vecFieldzn[i][j][k]) * invdz + .25 * (vecFieldzn[i + 1][j][k + 1] - vecFieldzn[i + 1][j][k]) * invdz + .25 * (vecFieldzn[i][j + 1][k + 1] - vecFieldzn[i][j + 1][k]) * invdz + .25 * (vecFieldzn[i + 1][j + 1][k + 1] - vecFieldzn[i + 1][j + 1][k]) * invdz;
                divC[i][j][k] = compX + compY + compZ;
            }
    
    
}



/** calculate divergence on central points, given a Tensor field defined on nodes  */
void divSymmTensorN2C(FPinterp ***divCX, FPinterp ***divCY, FPinterp ***divCZ, FPinterp ***pXX, FPinterp ***pXY, FPinterp ***pXZ, FPinterp ***pYY, FPinterp ***pYZ, FPinterp ***pZZ, grid* grd)
{
    
    // center
    int nxc = grd->nxc;
    int nyc = grd->nyc;
    int nzc = grd->nzc;
    
    // inv. dx, dy, dz
    FPinterp invdx = grd->invdx;
    FPinterp invdy = grd->invdy;
    FPinterp invdz = grd->invdz;
   
    
    FPinterp comp1X, comp2X, comp3X;
    FPinterp  comp1Y, comp2Y, comp3Y;
    FPinterp  comp1Z, comp2Z, comp3Z;
    
    for (register int i = 1; i < nxc - 1; i++)
        for (register int j = 1; j < nyc - 1; j++)
            for (register int k = 1; k < nzc - 1; k++) {
               
                comp1X = .25 * (pXX[i + 1][j][k] - pXX[i][j][k]) * invdx + .25 * (pXX[i + 1][j][k + 1] - pXX[i][j][k + 1]) * invdx + .25 * (pXX[i + 1][j + 1][k] - pXX[i][j + 1][k]) * invdx + .25 * (pXX[i + 1][j + 1][k + 1] - pXX[i][j + 1][k + 1]) * invdx;
                comp2X = .25 * (pXY[i + 1][j][k] - pXY[i][j][k]) * invdx + .25 * (pXY[i + 1][j][k + 1] - pXY[i][j][k + 1]) * invdx + .25 * (pXY[i + 1][j + 1][k] - pXY[i][j + 1][k]) * invdx + .25 * (pXY[i + 1][j + 1][k + 1] - pXY[i][j + 1][k + 1]) * invdx;
                comp3X = .25 * (pXZ[i + 1][j][k] - pXZ[i][j][k]) * invdx + .25 * (pXZ[i + 1][j][k + 1] - pXZ[i][j][k + 1]) * invdx + .25 * (pXZ[i + 1][j + 1][k] - pXZ[i][j + 1][k]) * invdx + .25 * (pXZ[i + 1][j + 1][k + 1] - pXZ[i][j + 1][k + 1]) * invdx;
                comp1Y = .25 * (pXY[i][j + 1][k] - pXY[i][j][k]) * invdy + .25 * (pXY[i][j + 1][k + 1] - pXY[i][j][k + 1]) * invdy + .25 * (pXY[i + 1][j + 1][k] - pXY[i + 1][j][k]) * invdy + .25 * (pXY[i + 1][j + 1][k + 1] - pXY[i + 1][j][k + 1]) * invdy;
                comp2Y = .25 * (pYY[i][j + 1][k] - pYY[i][j][k]) * invdy + .25 * (pYY[i][j + 1][k + 1] - pYY[i][j][k + 1]) * invdy + .25 * (pYY[i + 1][j + 1][k] - pYY[i + 1][j][k]) * invdy + .25 * (pYY[i + 1][j + 1][k + 1] - pYY[i + 1][j][k + 1]) * invdy;
                comp3Y = .25 * (pYZ[i][j + 1][k] - pYZ[i][j][k]) * invdy + .25 * (pYZ[i][j + 1][k + 1] - pYZ[i][j][k + 1]) * invdy + .25 * (pYZ[i + 1][j + 1][k] - pYZ[i + 1][j][k]) * invdy + .25 * (pYZ[i + 1][j + 1][k + 1] - pYZ[i + 1][j][k + 1]) * invdy;
                comp1Z = .25 * (pXZ[i][j][k + 1] - pXZ[i][j][k]) * invdz + .25 * (pXZ[i + 1][j][k + 1] - pXZ[i + 1][j][k]) * invdz + .25 * (pXZ[i][j + 1][k + 1] - pXZ[i][j + 1][k]) * invdz + .25 * (pXZ[i + 1][j + 1][k + 1] - pXZ[i + 1][j + 1][k]) * invdz;
                comp2Z = .25 * (pYZ[i][j][k + 1] - pYZ[i][j][k]) * invdz + .25 * (pYZ[i + 1][j][k + 1] - pYZ[i + 1][j][k]) * invdz + .25 * (pYZ[i][j + 1][k + 1] - pYZ[i][j + 1][k]) * invdz + .25 * (pYZ[i + 1][j + 1][k + 1] - pYZ[i + 1][j + 1][k]) * invdz;
                comp3Z = .25 * (pZZ[i][j][k + 1] - pZZ[i][j][k]) * invdz + .25 * (pZZ[i + 1][j][k + 1] - pZZ[i + 1][j][k]) * invdz + .25 * (pZZ[i][j + 1][k + 1] - pZZ[i][j + 1][k]) * invdz + .25 * (pZZ[i + 1][j + 1][k + 1] - pZZ[i + 1][j + 1][k]) * invdz;
                
                divCX[i][j][k] = comp1X + comp1Y + comp1Z;
                divCY[i][j][k] = comp2X + comp2Y + comp2Z;
                divCZ[i][j][k] = comp3X + comp3Y + comp3Z;
                
            }
    
}


/** calculate divergence on nodes, given a vector field defined on central points  */
void divC2N(FPfield ***divN, FPfield  ***vecFieldXC, FPfield  ***vecFieldYC, FPfield  ***vecFieldZC, grid* grd)
{
   
    // nodes
    int nxn = grd->nxn;
    int nyn = grd->nyn;
    int nzn = grd->nzn;
    
    // inv. dx, dy, dz
    FPfield invdx = grd->invdx;
    FPfield invdy = grd->invdy;
    FPfield invdz = grd->invdz;
    
    
    FPfield  compX;
    FPfield  compY;
    FPfield  compZ;
    
    for (register int i = 1; i < nxn - 1; i++)
        for (register int j = 1; j < nyn - 1; j++)
            for (register int k = 1; k < nzn - 1; k++) {
                compX = .25 * (vecFieldXC[i][j][k] - vecFieldXC[i - 1][j][k]) * invdx + .25 * (vecFieldXC[i][j][k - 1] - vecFieldXC[i - 1][j][k - 1]) * invdx + .25 * (vecFieldXC[i][j - 1][k] - vecFieldXC[i - 1][j - 1][k]) * invdx + .25 * (vecFieldXC[i][j - 1][k - 1] - vecFieldXC[i - 1][j - 1][k - 1]) * invdx;
                compY = .25 * (vecFieldYC[i][j][k] - vecFieldYC[i][j - 1][k]) * invdy + .25 * (vecFieldYC[i][j][k - 1] - vecFieldYC[i][j - 1][k - 1]) * invdy + .25 * (vecFieldYC[i - 1][j][k] - vecFieldYC[i - 1][j - 1][k]) * invdy + .25 * (vecFieldYC[i - 1][j][k - 1] - vecFieldYC[i - 1][j - 1][k - 1]) * invdy;
                compZ = .25 * (vecFieldZC[i][j][k] - vecFieldZC[i][j][k - 1]) * invdz + .25 * (vecFieldZC[i - 1][j][k] - vecFieldZC[i - 1][j][k - 1]) * invdz + .25 * (vecFieldZC[i][j - 1][k] - vecFieldZC[i][j - 1][k - 1]) * invdz + .25 * (vecFieldZC[i - 1][j - 1][k] - vecFieldZC[i - 1][j - 1][k - 1]) * invdz;
                divN[i][j][k] = compX + compY + compZ;
            }
}


/** calculate curl on nodes, given a vector field defined on central points  */
void curlC2N(FPfield ***curlxn, FPfield ***curlyn, FPfield ***curlzn, FPfield ***vecFieldXC, FPfield ***vecFieldYC, FPfield ***vecFieldZC, grid* grd)
{
    // nodes
    int nxn = grd->nxn;
    int nyn = grd->nyn;
    int nzn = grd->nzn;
    
    // inv. dx, dy, dz
    FPfield invdx = grd->invdx;
    FPfield invdy = grd->invdy;
    FPfield invdz = grd->invdz;
    
    
    
    FPfield compZDY, compYDZ;
    FPfield compXDZ, compZDX;
    FPfield compYDX, compXDY;
    
    
    
    for (register int i = 1; i < nxn - 1; i++)
        for (register int j = 1; j < nyn - 1; j++)
            for (register int k = 1; k < nzn - 1; k++) {
                // curl - X
                compZDY = .25 * (vecFieldZC[i][j][k] - vecFieldZC[i][j - 1][k]) * invdy + .25 * (vecFieldZC[i][j][k - 1] - vecFieldZC[i][j - 1][k - 1]) * invdy + .25 * (vecFieldZC[i - 1][j][k] - vecFieldZC[i - 1][j - 1][k]) * invdy + .25 * (vecFieldZC[i - 1][j][k - 1] - vecFieldZC[i - 1][j - 1][k - 1]) * invdy;
                compYDZ = .25 * (vecFieldYC[i][j][k] - vecFieldYC[i][j][k - 1]) * invdz + .25 * (vecFieldYC[i - 1][j][k] - vecFieldYC[i - 1][j][k - 1]) * invdz + .25 * (vecFieldYC[i][j - 1][k] - vecFieldYC[i][j - 1][k - 1]) * invdz + .25 * (vecFieldYC[i - 1][j - 1][k] - vecFieldYC[i - 1][j - 1][k - 1]) * invdz;
                // curl - Y
                compXDZ = .25 * (vecFieldXC[i][j][k] - vecFieldXC[i][j][k - 1]) * invdz + .25 * (vecFieldXC[i - 1][j][k] - vecFieldXC[i - 1][j][k - 1]) * invdz + .25 * (vecFieldXC[i][j - 1][k] - vecFieldXC[i][j - 1][k - 1]) * invdz + .25 * (vecFieldXC[i - 1][j - 1][k] - vecFieldXC[i - 1][j - 1][k - 1]) * invdz;
                compZDX = .25 * (vecFieldZC[i][j][k] - vecFieldZC[i - 1][j][k]) * invdx + .25 * (vecFieldZC[i][j][k - 1] - vecFieldZC[i - 1][j][k - 1]) * invdx + .25 * (vecFieldZC[i][j - 1][k] - vecFieldZC[i - 1][j - 1][k]) * invdx + .25 * (vecFieldZC[i][j - 1][k - 1] - vecFieldZC[i - 1][j - 1][k - 1]) * invdx;
                // curl - Z
                compYDX = .25 * (vecFieldYC[i][j][k] - vecFieldYC[i - 1][j][k]) * invdx + .25 * (vecFieldYC[i][j][k - 1] - vecFieldYC[i - 1][j][k - 1]) * invdx + .25 * (vecFieldYC[i][j - 1][k] - vecFieldYC[i - 1][j - 1][k]) * invdx + .25 * (vecFieldYC[i][j - 1][k - 1] - vecFieldYC[i - 1][j - 1][k - 1]) * invdx;
                compXDY = .25 * (vecFieldXC[i][j][k] - vecFieldXC[i][j - 1][k]) * invdy + .25 * (vecFieldXC[i][j][k - 1] - vecFieldXC[i][j - 1][k - 1]) * invdy + .25 * (vecFieldXC[i - 1][j][k] - vecFieldXC[i - 1][j - 1][k]) * invdy + .25 * (vecFieldXC[i - 1][j][k - 1] - vecFieldXC[i - 1][j - 1][k - 1]) * invdy;
                
                curlxn[i][j][k] = compZDY - compYDZ;
                curlyn[i][j][k] = compXDZ - compZDX;
                curlzn[i][j][k] = compYDX - compXDY;
            }
    
    
}

/** calculate curl on central points, given a vector field defined on nodes  */
void curlN2C(FPfield ***curlXC, FPfield ***curlYC, FPfield ***curlZC, FPfield ***vecFieldxn, FPfield ***vecFieldyn, FPfield ***vecFieldzn, grid* grd)
{
    // center
    int nxc = grd->nxc;
    int nyc = grd->nyc;
    int nzc = grd->nzc;
    
    // inv. dx, dy, dz
    FPfield invdx = grd->invdx;
    FPfield invdy = grd->invdy;
    FPfield invdz = grd->invdz;
    
    FPfield compZDY, compYDZ;
    FPfield compXDZ, compZDX;
    FPfield compYDX, compXDY;
    
    
    for (register int i = 1; i < nxc - 1; i++)
        for (register int j = 1; j < nyc - 1; j++)
            for (register int k = 1; k < nzc - 1; k++) {
                // curl - X
                compZDY = .25 * (vecFieldzn[i][j + 1][k] - vecFieldzn[i][j][k]) * invdy + .25 * (vecFieldzn[i][j + 1][k + 1] - vecFieldzn[i][j][k + 1]) * invdy + .25 * (vecFieldzn[i + 1][j + 1][k] - vecFieldzn[i + 1][j][k]) * invdy + .25 * (vecFieldzn[i + 1][j + 1][k + 1] - vecFieldzn[i + 1][j][k + 1]) * invdy;
                compYDZ = .25 * (vecFieldyn[i][j][k + 1] - vecFieldyn[i][j][k]) * invdz + .25 * (vecFieldyn[i + 1][j][k + 1] - vecFieldyn[i + 1][j][k]) * invdz + .25 * (vecFieldyn[i][j + 1][k + 1] - vecFieldyn[i][j + 1][k]) * invdz + .25 * (vecFieldyn[i + 1][j + 1][k + 1] - vecFieldyn[i + 1][j + 1][k]) * invdz;
                // curl - Y
                compXDZ = .25 * (vecFieldxn[i][j][k + 1] - vecFieldxn[i][j][k]) * invdz + .25 * (vecFieldxn[i + 1][j][k + 1] - vecFieldxn[i + 1][j][k]) * invdz + .25 * (vecFieldxn[i][j + 1][k + 1] - vecFieldxn[i][j + 1][k]) * invdz + .25 * (vecFieldxn[i + 1][j + 1][k + 1] - vecFieldxn[i + 1][j + 1][k]) * invdz;
                compZDX = .25 * (vecFieldzn[i + 1][j][k] - vecFieldzn[i][j][k]) * invdx + .25 * (vecFieldzn[i + 1][j][k + 1] - vecFieldzn[i][j][k + 1]) * invdx + .25 * (vecFieldzn[i + 1][j + 1][k] - vecFieldzn[i][j + 1][k]) * invdx + .25 * (vecFieldzn[i + 1][j + 1][k + 1] - vecFieldzn[i][j + 1][k + 1]) * invdx;
                // curl - Z
                compYDX = .25 * (vecFieldyn[i + 1][j][k] - vecFieldyn[i][j][k]) * invdx + .25 * (vecFieldyn[i + 1][j][k + 1] - vecFieldyn[i][j][k + 1]) * invdx + .25 * (vecFieldyn[i + 1][j + 1][k] - vecFieldyn[i][j + 1][k]) * invdx + .25 * (vecFieldyn[i + 1][j + 1][k + 1] - vecFieldyn[i][j + 1][k + 1]) * invdx;
                compXDY = .25 * (vecFieldxn[i][j + 1][k] - vecFieldxn[i][j][k]) * invdy + .25 * (vecFieldxn[i][j + 1][k + 1] - vecFieldxn[i][j][k + 1]) * invdy + .25 * (vecFieldxn[i + 1][j + 1][k] - vecFieldxn[i + 1][j][k]) * invdy + .25 * (vecFieldxn[i + 1][j + 1][k + 1] - vecFieldxn[i + 1][j][k + 1]) * invdy;
                
                
                curlXC[i][j][k] = compZDY - compYDZ;
                curlYC[i][j][k] = compXDZ - compZDX;
                curlZC[i][j][k] = compYDX - compXDY;
            }
    
    
    
}
/** calculate laplacian on nodes, given a scalar field defined on nodes */
void lapN2N(FPfield ***lapN, FPfield ***scFieldN,  grid* grd)
{
    // nodes
    int nxn = grd->nxn;
    int nyn = grd->nyn;
    int nzn = grd->nzn;
    
    // inv. dx, dy, dz
    FPfield invdx = grd->invdx;
    FPfield invdy = grd->invdy;
    FPfield invdz = grd->invdz;
    
    for (register int i = 1; i < nxn - 1; i++)
        for (register int j = 1; j < nyn - 1; j++)
            for (register int k = 1; k < nzn - 1; k++)
                lapN[i][j][k] = (scFieldN[i - 1][j][k] - 2 * scFieldN[i][j][k] + scFieldN[i + 1][j][k]) * invdx * invdx + (scFieldN[i][j - 1][k] - 2 * scFieldN[i][j][k] + scFieldN[i][j + 1][k]) * invdy * invdy + (scFieldN[i][j][k - 1] - 2 * scFieldN[i][j][k] + scFieldN[i][j][k + 1]) * invdz * invdz;
    
    

}


/** calculate laplacian on central points, given a scalar field defined on central points */
void lapC2C(FPfield ***lapC, FPfield ***scFieldC, grid* grd)
{
    // center
    int nxc = grd->nxc;
    int nyc = grd->nyc;
    int nzc = grd->nzc;
    
    // inv. dx, dy, dz
    FPfield invdx = grd->invdx;
    FPfield invdy = grd->invdy;
    FPfield invdz = grd->invdz;
    
    for (register int i = 1; i < nxc - 1; i++)
        for (register int j = 1; j < nyc - 1; j++)
            for (register int k = 1; k < nzc - 1; k++)
                lapC[i][j][k] = (scFieldC[i - 1][j][k] - 2 * scFieldC[i][j][k] + scFieldC[i + 1][j][k]) * invdx * invdx + (scFieldC[i][j - 1][k] - 2 * scFieldC[i][j][k] + scFieldC[i][j + 1][k]) * invdy * invdy + (scFieldC[i][j][k - 1] - 2 * scFieldC[i][j][k] + scFieldC[i][j][k + 1]) * invdz * invdz;
    
}
