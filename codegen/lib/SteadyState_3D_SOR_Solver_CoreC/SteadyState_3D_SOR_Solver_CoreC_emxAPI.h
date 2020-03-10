/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * SteadyState_3D_SOR_Solver_CoreC_emxAPI.h
 *
 * Code generation for function 'SteadyState_3D_SOR_Solver_CoreC_emxAPI'
 *
 */

#ifndef STEADYSTATE_3D_SOR_SOLVER_COREC_EMXAPI_H
#define STEADYSTATE_3D_SOR_SOLVER_COREC_EMXAPI_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "SteadyState_3D_SOR_Solver_CoreC_types.h"

/* Function Declarations */
extern emxArray_real_T *emxCreateND_real_T(int numDimensions, int *size);
extern emxArray_real_T *emxCreateWrapperND_real_T(double *data, int
  numDimensions, int *size);
extern emxArray_real_T *emxCreateWrapper_real_T(double *data, int rows, int cols);
extern emxArray_real_T *emxCreate_real_T(int rows, int cols);
extern void emxDestroyArray_real_T(emxArray_real_T *emxArray);
extern void emxInitArray_real_T(emxArray_real_T **pEmxArray, int numDimensions);

#endif

/* End of code generation (SteadyState_3D_SOR_Solver_CoreC_emxAPI.h) */
