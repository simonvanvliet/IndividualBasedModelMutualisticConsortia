/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_SteadyState_3D_SOR_Solver_CoreC_mex.c
 *
 * Code generation for function '_coder_SteadyState_3D_SOR_Solver_CoreC_mex'
 *
 */

/* Include files */
#include "_coder_SteadyState_3D_SOR_Solver_CoreC_api.h"
#include "_coder_SteadyState_3D_SOR_Solver_CoreC_mex.h"

/* Function Declarations */
static void c_SteadyState_3D_SOR_Solver_Cor(int32_T nlhs, mxArray *plhs[4],
  int32_T nrhs, const mxArray *prhs[17]);

/* Function Definitions */
static void c_SteadyState_3D_SOR_Solver_Cor(int32_T nlhs, mxArray *plhs[4],
  int32_T nrhs, const mxArray *prhs[17])
{
  const mxArray *outputs[4];
  int32_T b_nlhs;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 17) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 17, 4,
                        31, "SteadyState_3D_SOR_Solver_CoreC");
  }

  if (nlhs > 4) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 31,
                        "SteadyState_3D_SOR_Solver_CoreC");
  }

  /* Call the function. */
  SteadyState_3D_SOR_Solver_CoreC_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(SteadyState_3D_SOR_Solver_CoreC_atexit);

  /* Module initialization. */
  SteadyState_3D_SOR_Solver_CoreC_initialize();

  /* Dispatch the entry-point. */
  c_SteadyState_3D_SOR_Solver_Cor(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  SteadyState_3D_SOR_Solver_CoreC_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_SteadyState_3D_SOR_Solver_CoreC_mex.c) */
