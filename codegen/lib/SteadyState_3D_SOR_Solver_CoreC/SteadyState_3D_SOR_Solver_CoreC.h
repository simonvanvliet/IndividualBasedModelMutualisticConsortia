/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * SteadyState_3D_SOR_Solver_CoreC.h
 *
 * Code generation for function 'SteadyState_3D_SOR_Solver_CoreC'
 *
 */

#ifndef STEADYSTATE_3D_SOR_SOLVER_COREC_H
#define STEADYSTATE_3D_SOR_SOLVER_COREC_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "SteadyState_3D_SOR_Solver_CoreC_types.h"

/* Function Declarations */
extern void SteadyState_3D_SOR_Solver_CoreC(emxArray_real_T *exGridE1,
  emxArray_real_T *exGridE2, const emxArray_real_T *extendedGridType, const int
  gridSize[3], double dx, const double boundaryType[6], double ru1, double ru2,
  double rl1, double rl2, double D1, double D2, double Iconst1, double Iconst2,
  double alpha, double tolerance, double omega, double *numIt, double *errorCode);

#endif

/* End of code generation (SteadyState_3D_SOR_Solver_CoreC.h) */
