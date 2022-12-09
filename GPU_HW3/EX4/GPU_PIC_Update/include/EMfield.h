#ifndef EMFIELD_H
#define EMFIELD_H

#include "Alloc.h"
#include "Grid.h"


/** structure with field information */
struct EMfield {
    // field arrays: 4D arrays
    
    /* Electric field defined on nodes: last index is component */
    FPfield* x;
    FPfield* y;
    FPfield* z;
    /* Magnetic field defined on nodes: last index is component */
    FPfield* xn;
    FPfield* yn;
    FPfield* zn;
};

/** allocate electric and magnetic field */
void field_allocate(struct grid*, struct EMfield*);
void field_allocateGPU(struct grid*, struct EMfield*);
void copyEMfieldGPU(struct EMfield* dest, struct EMfield* src, struct grid* grd, bool host2CUDA = true);

/** deallocate electric and magnetic field */
void field_deallocate(struct EMfield*);
void field_deallocateGPU(struct EMfield*);

#define field_x(i, j, k) (*(field->x + (i) * grd->nyn * grd->nzn + (j) * grd->nzn + (k)))
#define field_y(i, j, k) (*(field->y + (i) * grd->nyn * grd->nzn + (j) * grd->nzn + (k)))
#define field_z(i, j, k) (*(field->z + (i) * grd->nyn * grd->nzn + (j) * grd->nzn + (k)))
#define field_xn(i, j, k) (*(field->xn + (i) * grd->nyn * grd->nzn + (j) * grd->nzn + (k)))
#define field_yn(i, j, k) (*(field->yn + (i) * grd->nyn * grd->nzn + (j) * grd->nzn + (k)))
#define field_zn(i, j, k) (*(field->zn + (i) * grd->nyn * grd->nzn + (j) * grd->nzn + (k)))

#define field_x_p(p) (*(field->x + (p)))
#define field_y_p(p) (*(field->y + (p)))
#define field_z_p(p) (*(field->z + (p)))
#define field_xn_p(p) (*(field->xn + (p)))
#define field_yn_p(p) (*(field->yn + (p)))
#define field_zn_p(p) (*(field->zn + (p)))

#define field_p(i, j, k) ((i) * grd->nyn * grd->nzn + (j) * grd->nzn + (k))

#define field_dim(grd) (grd->nxn * grd->nyn * grd->nzn)

#endif
