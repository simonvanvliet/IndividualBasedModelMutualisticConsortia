/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_SteadyState_3D_SOR_Solver_CoreC_api.h
 *
 * Code generation for function '_coder_SteadyState_3D_SOR_Solver_CoreC_api'
 *
 */

#ifndef _CODER_STEADYSTATE_3D_SOR_SOLVER_COREC_API_H
#define _CODER_STEADYSTATE_3D_SOR_SOLVER_COREC_API_H

/* Include files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_SteadyState_3D_SOR_Solver_CoreC_api.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_real_T*/

#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T

typedef struct emxArray_real_T emxArray_real_T;

#endif                                 /*typedef_emxArray_real_T*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void SteadyState_3D_SOR_Solver_CoreC(emxArray_real_T *exGridE1,
  emxArray_real_T *exGridE2, emxArray_real_T *extendedGridType, int32_T
  gridSize[3], real_T dx, real_T boundaryType[6], real_T ru1, real_T ru2, real_T
  rl1, real_T rl2, real_T D1, real_T D2, real_T Iconst1, real_T Iconst2, real_T
  alpha, real_T tolerance, real_T omega, real_T *numIt, real_T *errorCode);
extern void SteadyState_3D_SOR_Solver_CoreC_api(const mxArray *prhs[17], int32_T
  nlhs, const mxArray *plhs[4]);
extern void SteadyState_3D_SOR_Solver_CoreC_atexit(void);
extern void SteadyState_3D_SOR_Solver_CoreC_initialize(void);
extern void SteadyState_3D_SOR_Solver_CoreC_terminate(void);
extern void SteadyState_3D_SOR_Solver_CoreC_xil_shutdown(void);
extern void SteadyState_3D_SOR_Solver_CoreC_xil_terminate(void);

#endif

/* End of code generation (_coder_SteadyState_3D_SOR_Solver_CoreC_api.h) */
