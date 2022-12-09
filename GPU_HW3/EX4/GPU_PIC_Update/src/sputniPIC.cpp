/** A mixed-precision implicit Particle-in-Cell simulator for heterogeneous systems **/

// Allocator for 2D, 3D and 4D array: chain of pointers
#include "Alloc.h"

// Precision: fix precision for different quantities
#include "PrecisionTypes.h"
// Simulation Parameter - structure
#include "Parameters.h"
// Grid structure
#include "Grid.h"
// Interpolated Quantities Structures
#include "InterpDensSpecies.h"
#include "InterpDensNet.h"

// Field structure
#include "EMfield.h" // Just E and Bn
#include "EMfield_aux.h" // Bc, Phi, Eth, D

// Particles structure
#include "Particles.h"
#include "Particles_aux.h" // Needed only if dointerpolation on GPU - avoid reduction on GPU

// Initial Condition
#include "IC.h"
// Boundary Conditions
#include "BC.h"
// timing
#include "Timing.h"
// Read and output operations
#include "RW_IO.h"


static void CUDA_ERROR(cudaError_t err)
{
    if (err != cudaSuccess) {
        printf("CUDA ERROR: %s, exiting\n", cudaGetErrorString(err));
        exit(-1);
    }
}


int main(int argc, char **argv){
    
    // Read the inputfile and fill the param structure
    parameters param;
    // Read the input file name from command line
    readInputFile(&param,argc,argv);
    printParameters(&param);
    saveParameters(&param);
    
    // Timing variables
    double iStart = cpuSecond();
    double iMover, iInterp, eMover = 0.0, eInterp= 0.0;
    
    // Set-up the grid information in host
    grid grdHost;
    setGrid(&param, &grdHost);

    // Set-up the grid information in device
    grid* grd = 0;
    checkCudaErrors(cudaMallocManaged(&grd, sizeof(grid)));
    allocateGridGPU(&param, grd);
    
    // Allocate Fields in host.
    EMfield fieldHost;
    field_allocate(&grdHost,&fieldHost);
    EMfield_aux field_aux;
    field_aux_allocate(&grdHost,&field_aux);

    // Allocate Fields in device.
    EMfield* field = 0;
    cudaMallocManaged(&field, sizeof(EMfield));
    field_allocateGPU(&grdHost, field);
    
    // Allocate Interpolated Quantities
    // per species
    interpDensSpecies *ids = new interpDensSpecies[param.ns];
    for (int is=0; is < param.ns; is++)
        interp_dens_species_allocate(&grdHost,&ids[is],is);

    // Net densities
    interpDensNet idn;
    interp_dens_net_allocate(&grdHost,&idn);
    
    // Allocate Particles in host
    particles *partHost = new particles[param.ns];
    // allocation
    for (int is=0; is < param.ns; is++){
        particle_allocate(&param,&partHost[is],is);
    }

    // Allocate Particles in device
    particles** part;
    cudaMallocManaged(&part, sizeof(particles*) * param.ns);
    // allocation
    for (int is = 0; is < param.ns; is++) {
        cudaMallocManaged(&part[is], sizeof(particles));
        particle_allocateGPU(&param, part[is], is);
    }
    
    // Initialization
    initGEM(&param, &grdHost, &fieldHost, &field_aux, partHost,ids);

    // **********************************************************//
    // **** Start the Simulation!  Cycle index start from 1  *** //
    // **********************************************************//
   
    for (int cycle = param.first_cycle_n; cycle < (param.first_cycle_n + param.ncycles); cycle++) {
        
        std::cout << std::endl;
        std::cout << "***********************" << std::endl;
        std::cout << "   cycle = " << cycle << std::endl;
        std::cout << "***********************" << std::endl;
    
        // set to zero the densities - needed for interpolation
        setZeroDensities(&idn, ids, &grdHost, param.ns);  

        // Copy host memory for grid and electronic-magnetic field to CUDA memory
        copyGridGPU(grd, &grdHost);
        copyEMfieldGPU(field, &fieldHost, &grdHost);

        // implicit mover
        iMover = cpuSecond(); // start timer for mover

        for (int is = 0; is < param.ns; is++) {
            // Copy host memory for particles to device memory
            copyParticlesGPU(part[is], &partHost[is]);

            // Run particle mover.
            mover_PC_gpu(part[is], field, grd, &param);

            // Copy back the device memory for particles to host memory
            copyParticlesGPU(&partHost[is], part[is], false);

        }

        eMover += (cpuSecond() - iMover); // stop timer for mover

        // Copy bac device memory for grid and electronic-magnetic field to host memory
        copyGridGPU(&grdHost, grd, false);
        copyEMfieldGPU(&fieldHost, field, &grdHost, false);

        // interpolation particle to grid
        iInterp = cpuSecond(); // start timer for the interpolation step
        // interpolate species
        for (int is=0; is < param.ns; is++)
            interpP2G(&partHost[is],&ids[is], &grdHost);

        // apply BC to interpolated densities
        for (int is=0; is < param.ns; is++)
            applyBCids(&ids[is], &grdHost, &param);
        // sum over species
        sumOverSpecies(&idn,ids, &grdHost,param.ns);
        // interpolate charge density from center to node
        applyBCscalarDensN(idn.rhon, &grdHost, &param); 
        
        // write E, B, rho to disk
        if (cycle%param.FieldOutputCycle==0){
            VTK_Write_Vectors(cycle, &grdHost, &fieldHost);
            VTK_Write_Scalars(cycle, &grdHost, ids, &idn);
        }
        
        eInterp += (cpuSecond() - iInterp); // stop timer for interpolation       
        
    
    }  // end of one PIC cycle
    
    /// Release the resources
    //deallocated grid
    grid_deallocate(&grdHost);
    grid_deallocateGPU(grd);
    // deallocate field
    field_deallocate(&fieldHost);
    field_deallocateGPU(field);

    // deallocate interp
    interp_dens_net_deallocate(&grdHost, &idn);
    
    // Deallocate interpolated densities and particles
    for (int is=0; is < param.ns; is++){
        interp_dens_species_deallocate(grd, &ids[is]);
        particle_deallocate(&partHost[is]);

        particle_deallocateGPU(part[is]);
        cudaFree(part[is]);
    }

    cudaFree(grd);
    cudaFree(field);
    cudaFree(part);

    // stop timer
    double iElaps = cpuSecond() - iStart;
    
    // Print timing of simulation
    std::cout << std::endl;
    std::cout << "**************************************" << std::endl;
    std::cout << "   Tot. Simulation Time (s) = " << iElaps << std::endl;
    std::cout << "   Mover Time / Cycle   (s) = " << eMover/param.ncycles << std::endl;
    std::cout << "   Interp. Time / Cycle (s) = " << eInterp/param.ncycles  << std::endl;
    std::cout << "**************************************" << std::endl;
    
    // exit
    return 0;
}


