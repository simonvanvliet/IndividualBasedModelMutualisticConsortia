/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * SteadyState_3D_SOR_Solver_CoreC.c
 *
 * Code generation for function 'SteadyState_3D_SOR_Solver_CoreC'
 *
 */

/* Include files */
#include <math.h>
#include "SteadyState_3D_SOR_Solver_CoreC.h"
#include "sqrt.h"
#include "SteadyState_3D_SOR_Solver_CoreC_emxutil.h"

/* Function Definitions */
void SteadyState_3D_SOR_Solver_CoreC(emxArray_real_T *exGridE1, emxArray_real_T *
  exGridE2, const emxArray_real_T *extendedGridType, const int gridSize[3],
  double dx, const double boundaryType[6], double ru1, double ru2, double rl1,
  double rl2, double D1, double D2, double Iconst1, double Iconst2, double alpha,
  double tolerance, double omega, double *numIt, double *errorCode)
{
  int isNotConverged;
  int numGridPointH;
  emxArray_real_T *prevGridE1;
  emxArray_real_T *prevGridE2;
  emxArray_real_T *b_exGridE1;
  emxArray_real_T *c_exGridE1;
  emxArray_real_T *d_exGridE1;
  int NDfactor;
  int loop_ub;
  int b_loop_ub;
  int exGridE1_idx_0;
  int b_exGridE1_idx_0;
  int qY;
  int localConvergence;
  int localDivergence;
  int b_qY;
  int xx;
  int c_qY;
  int yy;
  int d_qY;
  int zz;
  int b_zz;
  double dDif1;
  double dDif2;
  double E1;
  double E2;
  double a_tmp;
  double I1;
  double I2;
  double d0;
  double errorE2;

  /*  Core solver, called from all other codes that solve 3D steady state problem */
  /*  Calculates steady state solution for 3D model of amino acid exchange */
  /*  */
  /*  two cell types: */
  /*    type 0 produces AA1, growth limited by AA2 */
  /*    type 1 produces AA2, growth limited by AA1 */
  /*    type 0 produces pro, growth limited by try: Delta try on left */
  /*    type 1 produces try, growth limited by pro: Delta pro on right */
  /*  internal concentration of produced AA is set to Iconst */
  /*  AA uptake is linear with [E], leakage is passive diffusion */
  /*  uptake, leakage, and diffusion rates can be assymetric between AA */
  /*  effective diffusion constant  =  (1-p)/(1+p/2), where p is density */
  /*  time scaled with growth rate (1h doubling time) */
  /*  space scaled with cell size (settings.cellSpacing um) */
  /*  concentrations scaled with Km of growth for each AA */
  /*  */
  /*  Boundary conditions: no flux on left, right, and top wall, [E] = 0 on bottom wall */
  /*  */
  /*  Solved with iterative finite difference scheme using successive over-relaxation (SOR) method */
  /*  */
  /*  Written by Simon van Vliet[1] & Alma Dal Co[2] */
  /*  [1] UBC Vancouver, [2] Harvard University */
  /*  */
  /*  Initial development: 06.02.2020 */
  /*  Last update: 06.02.2020 */
  /*  Run SOR */
  isNotConverged = 1;
  *numIt = 0.0;
  *errorCode = 0.0;

  /* Grid size [Width (East-West), Depth (North-South), Height (Top-Bottom)] */
  numGridPointH = gridSize[2];

  /* Grid size [Width (East-West), Depth (North-South), Height (Top-Bottom)] */
  /* boundaryType:  */
  /*  0 is closed boundary (zero-flux) */
  /*  1 os open boundary (zero concentration) */
  /*  order is: North, East, South, West, Top, Bottom */
  /* boundaryType = [0, 0, 1, 0, 0, 0];   */
  emxInit_real_T(&prevGridE1, 3);
  emxInit_real_T(&prevGridE2, 3);
  emxInit_real_T(&b_exGridE1, 3);
  emxInit_real_T(&c_exGridE1, 3);
  emxInit_real_T(&d_exGridE1, 2);
  while (isNotConverged != 0) {
    /* update grids */
    NDfactor = prevGridE1->size[0] * prevGridE1->size[1] * prevGridE1->size[2];
    prevGridE1->size[0] = exGridE1->size[0];
    prevGridE1->size[1] = exGridE1->size[1];
    prevGridE1->size[2] = exGridE1->size[2];
    emxEnsureCapacity_real_T(prevGridE1, NDfactor);
    loop_ub = exGridE1->size[0] * exGridE1->size[1] * exGridE1->size[2];
    for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
      prevGridE1->data[NDfactor] = exGridE1->data[NDfactor];
    }

    NDfactor = prevGridE2->size[0] * prevGridE2->size[1] * prevGridE2->size[2];
    prevGridE2->size[0] = exGridE2->size[0];
    prevGridE2->size[1] = exGridE2->size[1];
    prevGridE2->size[2] = exGridE2->size[2];
    emxEnsureCapacity_real_T(prevGridE2, NDfactor);
    loop_ub = exGridE2->size[0] * exGridE2->size[1] * exGridE2->size[2];
    for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
      prevGridE2->data[NDfactor] = exGridE2->data[NDfactor];
    }

    (*numIt)++;

    /* Implement boundary conditions */
    /* North boundary */
    if (boundaryType[0] == 0.0) {
      /* closed boundary, zero flux */
      loop_ub = exGridE1->size[1] - 1;
      b_loop_ub = exGridE1->size[2] - 1;
      NDfactor = b_exGridE1->size[0] * b_exGridE1->size[1] * b_exGridE1->size[2];
      b_exGridE1->size[0] = 1;
      b_exGridE1->size[1] = loop_ub + 1;
      b_exGridE1->size[2] = b_loop_ub + 1;
      emxEnsureCapacity_real_T(b_exGridE1, NDfactor);
      for (NDfactor = 0; NDfactor <= b_loop_ub; NDfactor++) {
        for (exGridE1_idx_0 = 0; exGridE1_idx_0 <= loop_ub; exGridE1_idx_0++) {
          b_exGridE1->data[exGridE1_idx_0 + b_exGridE1->size[1] * NDfactor] =
            exGridE1->data[(exGridE1->size[0] * exGridE1_idx_0 + exGridE1->size
                            [0] * exGridE1->size[1] * NDfactor) + 2];
        }
      }

      loop_ub = b_exGridE1->size[2];
      for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
        b_loop_ub = b_exGridE1->size[1];
        for (exGridE1_idx_0 = 0; exGridE1_idx_0 < b_loop_ub; exGridE1_idx_0++) {
          exGridE1->data[exGridE1->size[0] * exGridE1_idx_0 + exGridE1->size[0] *
            exGridE1->size[1] * NDfactor] = b_exGridE1->data[exGridE1_idx_0 +
            b_exGridE1->size[1] * NDfactor];
        }
      }

      loop_ub = exGridE2->size[1] - 1;
      b_loop_ub = exGridE2->size[2] - 1;
      NDfactor = b_exGridE1->size[0] * b_exGridE1->size[1] * b_exGridE1->size[2];
      b_exGridE1->size[0] = 1;
      b_exGridE1->size[1] = loop_ub + 1;
      b_exGridE1->size[2] = b_loop_ub + 1;
      emxEnsureCapacity_real_T(b_exGridE1, NDfactor);
      for (NDfactor = 0; NDfactor <= b_loop_ub; NDfactor++) {
        for (exGridE1_idx_0 = 0; exGridE1_idx_0 <= loop_ub; exGridE1_idx_0++) {
          b_exGridE1->data[exGridE1_idx_0 + b_exGridE1->size[1] * NDfactor] =
            exGridE2->data[(exGridE2->size[0] * exGridE1_idx_0 + exGridE2->size
                            [0] * exGridE2->size[1] * NDfactor) + 2];
        }
      }

      loop_ub = b_exGridE1->size[2];
      for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
        b_loop_ub = b_exGridE1->size[1];
        for (exGridE1_idx_0 = 0; exGridE1_idx_0 < b_loop_ub; exGridE1_idx_0++) {
          exGridE2->data[exGridE2->size[0] * exGridE1_idx_0 + exGridE2->size[0] *
            exGridE2->size[1] * NDfactor] = b_exGridE1->data[exGridE1_idx_0 +
            b_exGridE1->size[1] * NDfactor];
        }
      }
    } else {
      if (boundaryType[0] == 1.0) {
        /* open boundary, zero concentration */
        loop_ub = exGridE1->size[1];
        b_loop_ub = exGridE1->size[2];
        for (NDfactor = 0; NDfactor < b_loop_ub; NDfactor++) {
          for (exGridE1_idx_0 = 0; exGridE1_idx_0 < loop_ub; exGridE1_idx_0++) {
            exGridE1->data[exGridE1->size[0] * exGridE1_idx_0 + exGridE1->size[0]
              * exGridE1->size[1] * NDfactor] = 0.0;
          }
        }

        loop_ub = exGridE2->size[1];
        b_loop_ub = exGridE2->size[2];
        for (NDfactor = 0; NDfactor < b_loop_ub; NDfactor++) {
          for (exGridE1_idx_0 = 0; exGridE1_idx_0 < loop_ub; exGridE1_idx_0++) {
            exGridE2->data[exGridE2->size[0] * exGridE1_idx_0 + exGridE2->size[0]
              * exGridE2->size[1] * NDfactor] = 0.0;
          }
        }
      }
    }

    /* East boundary */
    if (boundaryType[1] == 0.0) {
      /* closed boundary, zero flux */
      loop_ub = exGridE1->size[0] - 1;
      NDfactor = exGridE1->size[1];
      b_loop_ub = exGridE1->size[2] - 1;
      exGridE1_idx_0 = exGridE1->size[1] - 1;
      b_exGridE1_idx_0 = c_exGridE1->size[0] * c_exGridE1->size[1] *
        c_exGridE1->size[2];
      c_exGridE1->size[0] = loop_ub + 1;
      c_exGridE1->size[1] = 1;
      c_exGridE1->size[2] = b_loop_ub + 1;
      emxEnsureCapacity_real_T(c_exGridE1, b_exGridE1_idx_0);
      for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 <= b_loop_ub; b_exGridE1_idx_0
           ++) {
        for (qY = 0; qY <= loop_ub; qY++) {
          c_exGridE1->data[qY + c_exGridE1->size[0] * b_exGridE1_idx_0] =
            exGridE1->data[(qY + exGridE1->size[0] * (NDfactor - 3)) +
            exGridE1->size[0] * exGridE1->size[1] * b_exGridE1_idx_0];
        }
      }

      loop_ub = c_exGridE1->size[2];
      for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
        b_loop_ub = c_exGridE1->size[0];
        for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 < b_loop_ub;
             b_exGridE1_idx_0++) {
          exGridE1->data[(b_exGridE1_idx_0 + exGridE1->size[0] * exGridE1_idx_0)
            + exGridE1->size[0] * exGridE1->size[1] * NDfactor] =
            c_exGridE1->data[b_exGridE1_idx_0 + c_exGridE1->size[0] * NDfactor];
        }
      }

      loop_ub = exGridE2->size[0] - 1;
      NDfactor = exGridE2->size[1];
      b_loop_ub = exGridE2->size[2] - 1;
      exGridE1_idx_0 = exGridE2->size[1] - 1;
      b_exGridE1_idx_0 = c_exGridE1->size[0] * c_exGridE1->size[1] *
        c_exGridE1->size[2];
      c_exGridE1->size[0] = loop_ub + 1;
      c_exGridE1->size[1] = 1;
      c_exGridE1->size[2] = b_loop_ub + 1;
      emxEnsureCapacity_real_T(c_exGridE1, b_exGridE1_idx_0);
      for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 <= b_loop_ub; b_exGridE1_idx_0
           ++) {
        for (qY = 0; qY <= loop_ub; qY++) {
          c_exGridE1->data[qY + c_exGridE1->size[0] * b_exGridE1_idx_0] =
            exGridE2->data[(qY + exGridE2->size[0] * (NDfactor - 3)) +
            exGridE2->size[0] * exGridE2->size[1] * b_exGridE1_idx_0];
        }
      }

      loop_ub = c_exGridE1->size[2];
      for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
        b_loop_ub = c_exGridE1->size[0];
        for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 < b_loop_ub;
             b_exGridE1_idx_0++) {
          exGridE2->data[(b_exGridE1_idx_0 + exGridE2->size[0] * exGridE1_idx_0)
            + exGridE2->size[0] * exGridE2->size[1] * NDfactor] =
            c_exGridE1->data[b_exGridE1_idx_0 + c_exGridE1->size[0] * NDfactor];
        }
      }
    } else {
      if (boundaryType[1] == 1.0) {
        /* open boundary, zero concentration */
        loop_ub = exGridE1->size[0];
        b_loop_ub = exGridE1->size[2];
        NDfactor = exGridE1->size[1] - 1;
        for (exGridE1_idx_0 = 0; exGridE1_idx_0 < b_loop_ub; exGridE1_idx_0++) {
          for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 < loop_ub;
               b_exGridE1_idx_0++) {
            exGridE1->data[(b_exGridE1_idx_0 + exGridE1->size[0] * NDfactor) +
              exGridE1->size[0] * exGridE1->size[1] * exGridE1_idx_0] = 0.0;
          }
        }

        loop_ub = exGridE2->size[0];
        b_loop_ub = exGridE2->size[2];
        NDfactor = exGridE2->size[1] - 1;
        for (exGridE1_idx_0 = 0; exGridE1_idx_0 < b_loop_ub; exGridE1_idx_0++) {
          for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 < loop_ub;
               b_exGridE1_idx_0++) {
            exGridE2->data[(b_exGridE1_idx_0 + exGridE2->size[0] * NDfactor) +
              exGridE2->size[0] * exGridE2->size[1] * exGridE1_idx_0] = 0.0;
          }
        }
      }
    }

    /* South boundary */
    if (boundaryType[2] == 0.0) {
      /* closed boundary, zero flux */
      NDfactor = exGridE1->size[0];
      loop_ub = exGridE1->size[1] - 1;
      b_loop_ub = exGridE1->size[2] - 1;
      exGridE1_idx_0 = exGridE1->size[0] - 1;
      b_exGridE1_idx_0 = b_exGridE1->size[0] * b_exGridE1->size[1] *
        b_exGridE1->size[2];
      b_exGridE1->size[0] = 1;
      b_exGridE1->size[1] = loop_ub + 1;
      b_exGridE1->size[2] = b_loop_ub + 1;
      emxEnsureCapacity_real_T(b_exGridE1, b_exGridE1_idx_0);
      for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 <= b_loop_ub; b_exGridE1_idx_0
           ++) {
        for (qY = 0; qY <= loop_ub; qY++) {
          b_exGridE1->data[qY + b_exGridE1->size[1] * b_exGridE1_idx_0] =
            exGridE1->data[((NDfactor + exGridE1->size[0] * qY) + exGridE1->
                            size[0] * exGridE1->size[1] * b_exGridE1_idx_0) - 3];
        }
      }

      loop_ub = b_exGridE1->size[2];
      for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
        b_loop_ub = b_exGridE1->size[1];
        for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 < b_loop_ub;
             b_exGridE1_idx_0++) {
          exGridE1->data[(exGridE1_idx_0 + exGridE1->size[0] * b_exGridE1_idx_0)
            + exGridE1->size[0] * exGridE1->size[1] * NDfactor] =
            b_exGridE1->data[b_exGridE1_idx_0 + b_exGridE1->size[1] * NDfactor];
        }
      }

      NDfactor = exGridE2->size[0];
      loop_ub = exGridE2->size[1] - 1;
      b_loop_ub = exGridE2->size[2] - 1;
      exGridE1_idx_0 = exGridE2->size[0] - 1;
      b_exGridE1_idx_0 = b_exGridE1->size[0] * b_exGridE1->size[1] *
        b_exGridE1->size[2];
      b_exGridE1->size[0] = 1;
      b_exGridE1->size[1] = loop_ub + 1;
      b_exGridE1->size[2] = b_loop_ub + 1;
      emxEnsureCapacity_real_T(b_exGridE1, b_exGridE1_idx_0);
      for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 <= b_loop_ub; b_exGridE1_idx_0
           ++) {
        for (qY = 0; qY <= loop_ub; qY++) {
          b_exGridE1->data[qY + b_exGridE1->size[1] * b_exGridE1_idx_0] =
            exGridE2->data[((NDfactor + exGridE2->size[0] * qY) + exGridE2->
                            size[0] * exGridE2->size[1] * b_exGridE1_idx_0) - 3];
        }
      }

      loop_ub = b_exGridE1->size[2];
      for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
        b_loop_ub = b_exGridE1->size[1];
        for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 < b_loop_ub;
             b_exGridE1_idx_0++) {
          exGridE2->data[(exGridE1_idx_0 + exGridE2->size[0] * b_exGridE1_idx_0)
            + exGridE2->size[0] * exGridE2->size[1] * NDfactor] =
            b_exGridE1->data[b_exGridE1_idx_0 + b_exGridE1->size[1] * NDfactor];
        }
      }
    } else {
      if (boundaryType[2] == 1.0) {
        /* open boundary, zero concentration */
        loop_ub = exGridE1->size[1];
        b_loop_ub = exGridE1->size[2];
        NDfactor = exGridE1->size[0] - 1;
        for (exGridE1_idx_0 = 0; exGridE1_idx_0 < b_loop_ub; exGridE1_idx_0++) {
          for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 < loop_ub;
               b_exGridE1_idx_0++) {
            exGridE1->data[(NDfactor + exGridE1->size[0] * b_exGridE1_idx_0) +
              exGridE1->size[0] * exGridE1->size[1] * exGridE1_idx_0] = 0.0;
          }
        }

        loop_ub = exGridE2->size[1];
        b_loop_ub = exGridE2->size[2];
        NDfactor = exGridE2->size[0] - 1;
        for (exGridE1_idx_0 = 0; exGridE1_idx_0 < b_loop_ub; exGridE1_idx_0++) {
          for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 < loop_ub;
               b_exGridE1_idx_0++) {
            exGridE2->data[(NDfactor + exGridE2->size[0] * b_exGridE1_idx_0) +
              exGridE2->size[0] * exGridE2->size[1] * exGridE1_idx_0] = 0.0;
          }
        }
      }
    }

    /* West boundary */
    if (boundaryType[3] == 0.0) {
      /* closed boundary, zero flux */
      loop_ub = exGridE1->size[0] - 1;
      b_loop_ub = exGridE1->size[2] - 1;
      NDfactor = c_exGridE1->size[0] * c_exGridE1->size[1] * c_exGridE1->size[2];
      c_exGridE1->size[0] = loop_ub + 1;
      c_exGridE1->size[1] = 1;
      c_exGridE1->size[2] = b_loop_ub + 1;
      emxEnsureCapacity_real_T(c_exGridE1, NDfactor);
      for (NDfactor = 0; NDfactor <= b_loop_ub; NDfactor++) {
        for (exGridE1_idx_0 = 0; exGridE1_idx_0 <= loop_ub; exGridE1_idx_0++) {
          c_exGridE1->data[exGridE1_idx_0 + c_exGridE1->size[0] * NDfactor] =
            exGridE1->data[(exGridE1_idx_0 + (exGridE1->size[0] << 1)) +
            exGridE1->size[0] * exGridE1->size[1] * NDfactor];
        }
      }

      loop_ub = c_exGridE1->size[2];
      for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
        b_loop_ub = c_exGridE1->size[0];
        for (exGridE1_idx_0 = 0; exGridE1_idx_0 < b_loop_ub; exGridE1_idx_0++) {
          exGridE1->data[exGridE1_idx_0 + exGridE1->size[0] * exGridE1->size[1] *
            NDfactor] = c_exGridE1->data[exGridE1_idx_0 + c_exGridE1->size[0] *
            NDfactor];
        }
      }

      loop_ub = exGridE2->size[0] - 1;
      b_loop_ub = exGridE2->size[2] - 1;
      NDfactor = c_exGridE1->size[0] * c_exGridE1->size[1] * c_exGridE1->size[2];
      c_exGridE1->size[0] = loop_ub + 1;
      c_exGridE1->size[1] = 1;
      c_exGridE1->size[2] = b_loop_ub + 1;
      emxEnsureCapacity_real_T(c_exGridE1, NDfactor);
      for (NDfactor = 0; NDfactor <= b_loop_ub; NDfactor++) {
        for (exGridE1_idx_0 = 0; exGridE1_idx_0 <= loop_ub; exGridE1_idx_0++) {
          c_exGridE1->data[exGridE1_idx_0 + c_exGridE1->size[0] * NDfactor] =
            exGridE2->data[(exGridE1_idx_0 + (exGridE2->size[0] << 1)) +
            exGridE2->size[0] * exGridE2->size[1] * NDfactor];
        }
      }

      loop_ub = c_exGridE1->size[2];
      for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
        b_loop_ub = c_exGridE1->size[0];
        for (exGridE1_idx_0 = 0; exGridE1_idx_0 < b_loop_ub; exGridE1_idx_0++) {
          exGridE2->data[exGridE1_idx_0 + exGridE2->size[0] * exGridE2->size[1] *
            NDfactor] = c_exGridE1->data[exGridE1_idx_0 + c_exGridE1->size[0] *
            NDfactor];
        }
      }
    } else {
      if (boundaryType[3] == 1.0) {
        /* open boundary, zero concentration */
        loop_ub = exGridE1->size[0];
        b_loop_ub = exGridE1->size[2];
        for (NDfactor = 0; NDfactor < b_loop_ub; NDfactor++) {
          for (exGridE1_idx_0 = 0; exGridE1_idx_0 < loop_ub; exGridE1_idx_0++) {
            exGridE1->data[exGridE1_idx_0 + exGridE1->size[0] * exGridE1->size[1]
              * NDfactor] = 0.0;
          }
        }

        loop_ub = exGridE2->size[0];
        b_loop_ub = exGridE2->size[2];
        for (NDfactor = 0; NDfactor < b_loop_ub; NDfactor++) {
          for (exGridE1_idx_0 = 0; exGridE1_idx_0 < loop_ub; exGridE1_idx_0++) {
            exGridE2->data[exGridE1_idx_0 + exGridE2->size[0] * exGridE2->size[1]
              * NDfactor] = 0.0;
          }
        }
      }
    }

    if (numGridPointH > 2) {
      /* System is 3D */
      /* Top boundary */
      if (boundaryType[4] == 0.0) {
        /* closed boundary, zero flux */
        loop_ub = exGridE1->size[0] - 1;
        b_loop_ub = exGridE1->size[1] - 1;
        NDfactor = exGridE1->size[2];
        exGridE1_idx_0 = exGridE1->size[2] - 1;
        b_exGridE1_idx_0 = d_exGridE1->size[0] * d_exGridE1->size[1];
        d_exGridE1->size[0] = loop_ub + 1;
        d_exGridE1->size[1] = b_loop_ub + 1;
        emxEnsureCapacity_real_T(d_exGridE1, b_exGridE1_idx_0);
        for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 <= b_loop_ub;
             b_exGridE1_idx_0++) {
          for (qY = 0; qY <= loop_ub; qY++) {
            d_exGridE1->data[qY + d_exGridE1->size[0] * b_exGridE1_idx_0] =
              exGridE1->data[(qY + exGridE1->size[0] * b_exGridE1_idx_0) +
              exGridE1->size[0] * exGridE1->size[1] * (NDfactor - 3)];
          }
        }

        loop_ub = d_exGridE1->size[1];
        for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
          b_loop_ub = d_exGridE1->size[0];
          for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 < b_loop_ub;
               b_exGridE1_idx_0++) {
            exGridE1->data[(b_exGridE1_idx_0 + exGridE1->size[0] * NDfactor) +
              exGridE1->size[0] * exGridE1->size[1] * exGridE1_idx_0] =
              d_exGridE1->data[b_exGridE1_idx_0 + d_exGridE1->size[0] * NDfactor];
          }
        }

        loop_ub = exGridE2->size[0] - 1;
        b_loop_ub = exGridE2->size[1] - 1;
        NDfactor = exGridE2->size[2];
        exGridE1_idx_0 = exGridE2->size[2] - 1;
        b_exGridE1_idx_0 = d_exGridE1->size[0] * d_exGridE1->size[1];
        d_exGridE1->size[0] = loop_ub + 1;
        d_exGridE1->size[1] = b_loop_ub + 1;
        emxEnsureCapacity_real_T(d_exGridE1, b_exGridE1_idx_0);
        for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 <= b_loop_ub;
             b_exGridE1_idx_0++) {
          for (qY = 0; qY <= loop_ub; qY++) {
            d_exGridE1->data[qY + d_exGridE1->size[0] * b_exGridE1_idx_0] =
              exGridE2->data[(qY + exGridE2->size[0] * b_exGridE1_idx_0) +
              exGridE2->size[0] * exGridE2->size[1] * (NDfactor - 3)];
          }
        }

        loop_ub = d_exGridE1->size[1];
        for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
          b_loop_ub = d_exGridE1->size[0];
          for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 < b_loop_ub;
               b_exGridE1_idx_0++) {
            exGridE2->data[(b_exGridE1_idx_0 + exGridE2->size[0] * NDfactor) +
              exGridE2->size[0] * exGridE2->size[1] * exGridE1_idx_0] =
              d_exGridE1->data[b_exGridE1_idx_0 + d_exGridE1->size[0] * NDfactor];
          }
        }
      } else {
        if (boundaryType[4] == 1.0) {
          /* open boundary, zero concentration */
          loop_ub = exGridE1->size[0];
          b_loop_ub = exGridE1->size[1];
          NDfactor = exGridE1->size[2] - 1;
          for (exGridE1_idx_0 = 0; exGridE1_idx_0 < b_loop_ub; exGridE1_idx_0++)
          {
            for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 < loop_ub;
                 b_exGridE1_idx_0++) {
              exGridE1->data[(b_exGridE1_idx_0 + exGridE1->size[0] *
                              exGridE1_idx_0) + exGridE1->size[0] *
                exGridE1->size[1] * NDfactor] = 0.0;
            }
          }

          loop_ub = exGridE2->size[0];
          b_loop_ub = exGridE2->size[1];
          NDfactor = exGridE2->size[2] - 1;
          for (exGridE1_idx_0 = 0; exGridE1_idx_0 < b_loop_ub; exGridE1_idx_0++)
          {
            for (b_exGridE1_idx_0 = 0; b_exGridE1_idx_0 < loop_ub;
                 b_exGridE1_idx_0++) {
              exGridE2->data[(b_exGridE1_idx_0 + exGridE2->size[0] *
                              exGridE1_idx_0) + exGridE2->size[0] *
                exGridE2->size[1] * NDfactor] = 0.0;
            }
          }
        }
      }

      /* Bottom boundary */
      if (boundaryType[5] == 0.0) {
        /* closed boundary, zero flux */
        loop_ub = exGridE1->size[0] - 1;
        b_loop_ub = exGridE1->size[1] - 1;
        NDfactor = d_exGridE1->size[0] * d_exGridE1->size[1];
        d_exGridE1->size[0] = loop_ub + 1;
        d_exGridE1->size[1] = b_loop_ub + 1;
        emxEnsureCapacity_real_T(d_exGridE1, NDfactor);
        for (NDfactor = 0; NDfactor <= b_loop_ub; NDfactor++) {
          for (exGridE1_idx_0 = 0; exGridE1_idx_0 <= loop_ub; exGridE1_idx_0++)
          {
            d_exGridE1->data[exGridE1_idx_0 + d_exGridE1->size[0] * NDfactor] =
              exGridE1->data[(exGridE1_idx_0 + exGridE1->size[0] * NDfactor) +
              ((exGridE1->size[0] * exGridE1->size[1]) << 1)];
          }
        }

        loop_ub = d_exGridE1->size[1];
        for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
          b_loop_ub = d_exGridE1->size[0];
          for (exGridE1_idx_0 = 0; exGridE1_idx_0 < b_loop_ub; exGridE1_idx_0++)
          {
            exGridE1->data[exGridE1_idx_0 + exGridE1->size[0] * NDfactor] =
              d_exGridE1->data[exGridE1_idx_0 + d_exGridE1->size[0] * NDfactor];
          }
        }

        loop_ub = exGridE2->size[0] - 1;
        b_loop_ub = exGridE2->size[1] - 1;
        NDfactor = d_exGridE1->size[0] * d_exGridE1->size[1];
        d_exGridE1->size[0] = loop_ub + 1;
        d_exGridE1->size[1] = b_loop_ub + 1;
        emxEnsureCapacity_real_T(d_exGridE1, NDfactor);
        for (NDfactor = 0; NDfactor <= b_loop_ub; NDfactor++) {
          for (exGridE1_idx_0 = 0; exGridE1_idx_0 <= loop_ub; exGridE1_idx_0++)
          {
            d_exGridE1->data[exGridE1_idx_0 + d_exGridE1->size[0] * NDfactor] =
              exGridE2->data[(exGridE1_idx_0 + exGridE2->size[0] * NDfactor) +
              ((exGridE2->size[0] * exGridE2->size[1]) << 1)];
          }
        }

        loop_ub = d_exGridE1->size[1];
        for (NDfactor = 0; NDfactor < loop_ub; NDfactor++) {
          b_loop_ub = d_exGridE1->size[0];
          for (exGridE1_idx_0 = 0; exGridE1_idx_0 < b_loop_ub; exGridE1_idx_0++)
          {
            exGridE2->data[exGridE1_idx_0 + exGridE2->size[0] * NDfactor] =
              d_exGridE1->data[exGridE1_idx_0 + d_exGridE1->size[0] * NDfactor];
          }
        }
      } else {
        if (boundaryType[5] == 1.0) {
          /* open boundary, zero concentration */
          loop_ub = exGridE1->size[0];
          b_loop_ub = exGridE1->size[1];
          for (NDfactor = 0; NDfactor < b_loop_ub; NDfactor++) {
            for (exGridE1_idx_0 = 0; exGridE1_idx_0 < loop_ub; exGridE1_idx_0++)
            {
              exGridE1->data[exGridE1_idx_0 + exGridE1->size[0] * NDfactor] =
                0.0;
            }
          }

          loop_ub = exGridE2->size[0];
          b_loop_ub = exGridE2->size[1];
          for (NDfactor = 0; NDfactor < b_loop_ub; NDfactor++) {
            for (exGridE1_idx_0 = 0; exGridE1_idx_0 < loop_ub; exGridE1_idx_0++)
            {
              exGridE2->data[exGridE1_idx_0 + exGridE2->size[0] * NDfactor] =
                0.0;
            }
          }
        }
      }
    }

    localConvergence = 1;
    localDivergence = 0;

    /* loop over grid */
    if (gridSize[0] > 2147483646) {
      b_qY = MAX_int32_T;
    } else {
      b_qY = gridSize[0] + 1;
    }

    for (xx = 2; xx <= b_qY; xx++) {
      /* loop over interior, note: grid is extended by 2 pixels for boundary conditions */
      if (gridSize[1] > 2147483646) {
        c_qY = MAX_int32_T;
      } else {
        c_qY = gridSize[1] + 1;
      }

      for (yy = 2; yy <= c_qY; yy++) {
        if (numGridPointH > 2147483646) {
          d_qY = MAX_int32_T;
        } else {
          d_qY = numGridPointH + 1;
        }

        for (zz = 2; zz <= d_qY; zz++) {
          b_zz = zz - 1;

          /* approximate Nabda E */
          if (numGridPointH == 1) {
            /* 2D */
            b_zz = 0;
            loop_ub = exGridE1->size[0];
            b_loop_ub = exGridE1->size[0];
            exGridE1_idx_0 = exGridE1->size[0];
            b_exGridE1_idx_0 = exGridE1->size[0];
            if (yy > 2147483646) {
              qY = MAX_int32_T;
            } else {
              qY = yy + 1;
            }

            if (xx > 2147483646) {
              NDfactor = MAX_int32_T;
            } else {
              NDfactor = xx + 1;
            }

            dDif1 = ((exGridE1->data[(yy + loop_ub * (xx - 1)) - 2] +
                      exGridE1->data[(qY + b_loop_ub * (xx - 1)) - 1]) +
                     exGridE1->data[(yy + exGridE1_idx_0 * (xx - 2)) - 1]) +
              exGridE1->data[(yy + b_exGridE1_idx_0 * (NDfactor - 1)) - 1];
            loop_ub = exGridE2->size[0];
            b_loop_ub = exGridE2->size[0];
            exGridE1_idx_0 = exGridE2->size[0];
            b_exGridE1_idx_0 = exGridE2->size[0];
            if (yy > 2147483646) {
              qY = MAX_int32_T;
            } else {
              qY = yy + 1;
            }

            if (xx > 2147483646) {
              NDfactor = MAX_int32_T;
            } else {
              NDfactor = xx + 1;
            }

            dDif2 = ((exGridE2->data[(yy + loop_ub * (xx - 1)) - 2] +
                      exGridE2->data[(qY + b_loop_ub * (xx - 1)) - 1]) +
                     exGridE2->data[(yy + exGridE1_idx_0 * (xx - 2)) - 1]) +
              exGridE2->data[(yy + b_exGridE1_idx_0 * (NDfactor - 1)) - 1];
            NDfactor = 4;
          } else {
            /* 3D */
            if (yy > 2147483646) {
              qY = MAX_int32_T;
            } else {
              qY = yy + 1;
            }

            if (xx > 2147483646) {
              NDfactor = MAX_int32_T;
            } else {
              NDfactor = xx + 1;
            }

            if (zz > 2147483646) {
              loop_ub = MAX_int32_T;
            } else {
              loop_ub = zz + 1;
            }

            dDif1 = ((((exGridE1->data[((yy + exGridE1->size[0] * (xx - 1)) +
              exGridE1->size[0] * exGridE1->size[1] * (zz - 1)) - 2] +
                        exGridE1->data[((qY + exGridE1->size[0] * (xx - 1)) +
              exGridE1->size[0] * exGridE1->size[1] * (zz - 1)) - 1]) +
                       exGridE1->data[((yy + exGridE1->size[0] * (xx - 2)) +
                        exGridE1->size[0] * exGridE1->size[1] * (zz - 1)) - 1])
                      + exGridE1->data[((yy + exGridE1->size[0] * (NDfactor - 1))
                       + exGridE1->size[0] * exGridE1->size[1] * (zz - 1)) - 1])
                     + exGridE1->data[((yy + exGridE1->size[0] * (xx - 1)) +
                      exGridE1->size[0] * exGridE1->size[1] * (zz - 2)) - 1]) +
              exGridE1->data[((yy + exGridE1->size[0] * (xx - 1)) +
                              exGridE1->size[0] * exGridE1->size[1] * (loop_ub -
              1)) - 1];
            if (yy > 2147483646) {
              qY = MAX_int32_T;
            } else {
              qY = yy + 1;
            }

            if (xx > 2147483646) {
              NDfactor = MAX_int32_T;
            } else {
              NDfactor = xx + 1;
            }

            if (zz > 2147483646) {
              loop_ub = MAX_int32_T;
            } else {
              loop_ub = zz + 1;
            }

            dDif2 = ((((exGridE2->data[((yy + exGridE2->size[0] * (xx - 1)) +
              exGridE2->size[0] * exGridE2->size[1] * (zz - 1)) - 2] +
                        exGridE2->data[((qY + exGridE2->size[0] * (xx - 1)) +
              exGridE2->size[0] * exGridE2->size[1] * (zz - 1)) - 1]) +
                       exGridE2->data[((yy + exGridE2->size[0] * (xx - 2)) +
                        exGridE2->size[0] * exGridE2->size[1] * (zz - 1)) - 1])
                      + exGridE2->data[((yy + exGridE2->size[0] * (NDfactor - 1))
                       + exGridE2->size[0] * exGridE2->size[1] * (zz - 1)) - 1])
                     + exGridE2->data[((yy + exGridE2->size[0] * (xx - 1)) +
                      exGridE2->size[0] * exGridE2->size[1] * (zz - 2)) - 1]) +
              exGridE2->data[((yy + exGridE2->size[0] * (xx - 1)) +
                              exGridE2->size[0] * exGridE2->size[1] * (loop_ub -
              1)) - 1];
            NDfactor = 6;
          }

          /* make sure concentrations do not go negative             */
          E1 = exGridE1->data[((yy + exGridE1->size[0] * (xx - 1)) +
                               exGridE1->size[0] * exGridE1->size[1] * b_zz) - 1];
          if (E1 < 0.0) {
            E1 = 0.0;
          }

          E2 = exGridE2->data[((yy + exGridE2->size[0] * (xx - 1)) +
                               exGridE2->size[0] * exGridE2->size[1] * b_zz) - 1];
          if (E2 < 0.0) {
            E2 = 0.0;
          }

          /* Calculate internal concentrations  */
          if (extendedGridType->data[((yy + extendedGridType->size[0] * (xx - 1))
               + extendedGridType->size[0] * extendedGridType->size[1] * b_zz) -
              1] == 0.0) {
            I1 = Iconst1;
            a_tmp = ru2 + rl2;
            d0 = (a_tmp * a_tmp * (E2 * E2) + 2.0 * (rl2 + 2.0) * a_tmp * E2) +
              rl2 * rl2;
            b_sqrt(&d0);
            errorE2 = 2.0 + 2.0 * rl2;
            I2 = (E2 * a_tmp - rl2) / errorE2 + d0 / errorE2;
          } else {
            a_tmp = ru1 + rl1;
            I2 = 2.0 + 2.0 * rl1;
            I1 = (E1 * a_tmp - rl1) / I2 + sqrt((a_tmp * a_tmp * (E1 * E1) + 2.0
              * (rl1 + 2.0) * a_tmp * E1) + rl1 * rl1) / I2;
            I2 = Iconst2;
          }

          /* update grid point, SOR algorithm */
          d0 = dx * dx;
          exGridE1->data[((yy + exGridE1->size[0] * (xx - 1)) + exGridE1->size[0]
                          * exGridE1->size[1] * b_zz) - 1] = (1.0 - omega) *
            exGridE1->data[((yy + exGridE1->size[0] * (xx - 1)) + exGridE1->
                            size[0] * exGridE1->size[1] * b_zz) - 1] + omega *
            (dDif1 - d0 * (alpha * E1 * (ru1 + rl1) / D1 - alpha * I1 * rl1 / D1))
            / (double)NDfactor;
          exGridE2->data[((yy + exGridE2->size[0] * (xx - 1)) + exGridE2->size[0]
                          * exGridE2->size[1] * b_zz) - 1] = (1.0 - omega) *
            exGridE2->data[((yy + exGridE2->size[0] * (xx - 1)) + exGridE2->
                            size[0] * exGridE2->size[1] * b_zz) - 1] + omega *
            (dDif2 - d0 * (alpha * E2 * (ru2 + rl2) / D2 - alpha * I2 * rl2 / D2))
            / (double)NDfactor;
          I2 = fabs((prevGridE1->data[((yy + prevGridE1->size[0] * (xx - 1)) +
                      prevGridE1->size[0] * prevGridE1->size[1] * b_zz) - 1] -
                     exGridE1->data[((yy + exGridE1->size[0] * (xx - 1)) +
                      exGridE1->size[0] * exGridE1->size[1] * b_zz) - 1]) /
                    exGridE1->data[((yy + exGridE1->size[0] * (xx - 1)) +
                     exGridE1->size[0] * exGridE1->size[1] * b_zz) - 1]);
          errorE2 = fabs((prevGridE2->data[((yy + prevGridE2->size[0] * (xx - 1))
            + prevGridE2->size[0] * prevGridE2->size[1] * b_zz) - 1] -
                          exGridE2->data[((yy + exGridE2->size[0] * (xx - 1)) +
            exGridE2->size[0] * exGridE2->size[1] * b_zz) - 1]) / exGridE2->
                         data[((yy + exGridE2->size[0] * (xx - 1)) +
                               exGridE2->size[0] * exGridE2->size[1] * b_zz) - 1]);
          if (I2 > tolerance) {
            localConvergence = 0;
          }

          if (errorE2 > tolerance) {
            localConvergence = 0;
          }

          if ((I2 > 1.0E+6) || (errorE2 > 1.0E+6)) {
            localDivergence = 1;
          }
        }
      }
    }

    if (localConvergence == 1) {
      isNotConverged = 0;

      /* solved */
    }

    if (localDivergence == 1) {
      isNotConverged = 0;

      /* no convergence */
      *errorCode = 1.0;
    }
  }

  emxFree_real_T(&d_exGridE1);
  emxFree_real_T(&c_exGridE1);
  emxFree_real_T(&b_exGridE1);
  emxFree_real_T(&prevGridE2);
  emxFree_real_T(&prevGridE1);
}

/* End of code generation (SteadyState_3D_SOR_Solver_CoreC.c) */
