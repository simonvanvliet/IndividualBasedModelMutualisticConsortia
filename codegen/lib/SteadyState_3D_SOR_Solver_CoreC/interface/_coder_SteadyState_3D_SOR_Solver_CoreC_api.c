/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_SteadyState_3D_SOR_Solver_CoreC_api.c
 *
 * Code generation for function '_coder_SteadyState_3D_SOR_Solver_CoreC_api'
 *
 */

/* Include files */
#include <string.h>
#include "tmwtypes.h"
#include "_coder_SteadyState_3D_SOR_Solver_CoreC_api.h"
#include "_coder_SteadyState_3D_SOR_Solver_CoreC_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131482U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "SteadyState_3D_SOR_Solver_CoreC",   /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2045744189U, 2170104910U, 2743257031U, 4284093946U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static const mxArray *b_emlrt_marshallOut(const real_T u);
static int32_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *gridSize, const char_T *identifier))[3];
static int32_T (*d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId))[3];
static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *dx, const
  char_T *identifier);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *exGridE1,
  const char_T *identifier, emxArray_real_T *y);
static void emlrt_marshallOut(const emxArray_real_T *u, const mxArray *y);
static void emxEnsureCapacity_real_T(emxArray_real_T *emxArray, int32_T oldNumel);
static void emxFree_real_T(emxArray_real_T **pEmxArray);
static void emxInit_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray,
  int32_T numDimensions, boolean_T doPush);
static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static real_T (*g_emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *boundaryType, const char_T *identifier))[6];
static real_T (*h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[6];
static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static int32_T (*j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[3];
static real_T k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);
static real_T (*l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[6];

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  i_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static const mxArray *b_emlrt_marshallOut(const real_T u)
{
  const mxArray *y;
  const mxArray *m0;
  y = NULL;
  m0 = emlrtCreateDoubleScalar(u);
  emlrtAssign(&y, m0);
  return y;
}

static int32_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *gridSize, const char_T *identifier))[3]
{
  int32_T (*y)[3];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(sp, emlrtAlias(gridSize), &thisId);
  emlrtDestroyArray(&gridSize);
  return y;
}
  static int32_T (*d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId))[3]
{
  int32_T (*y)[3];
  y = j_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *dx, const
  char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = f_emlrt_marshallIn(sp, emlrtAlias(dx), &thisId);
  emlrtDestroyArray(&dx);
  return y;
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *exGridE1,
  const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(exGridE1), &thisId, y);
  emlrtDestroyArray(&exGridE1);
}

static void emlrt_marshallOut(const emxArray_real_T *u, const mxArray *y)
{
  emlrtMxSetData((mxArray *)y, &u->data[0]);
  emlrtSetDimensions((mxArray *)y, u->size, 3);
}

static void emxEnsureCapacity_real_T(emxArray_real_T *emxArray, int32_T oldNumel)
{
  int32_T newNumel;
  int32_T i;
  void *newData;
  if (oldNumel < 0) {
    oldNumel = 0;
  }

  newNumel = 1;
  for (i = 0; i < emxArray->numDimensions; i++) {
    newNumel *= emxArray->size[i];
  }

  if (newNumel > emxArray->allocatedSize) {
    i = emxArray->allocatedSize;
    if (i < 16) {
      i = 16;
    }

    while (i < newNumel) {
      if (i > 1073741823) {
        i = MAX_int32_T;
      } else {
        i <<= 1;
      }
    }

    newData = emlrtCallocMex((uint32_T)i, sizeof(real_T));
    if (emxArray->data != NULL) {
      memcpy(newData, emxArray->data, sizeof(real_T) * oldNumel);
      if (emxArray->canFreeData) {
        emlrtFreeMex(emxArray->data);
      }
    }

    emxArray->data = (real_T *)newData;
    emxArray->allocatedSize = i;
    emxArray->canFreeData = true;
  }
}

static void emxFree_real_T(emxArray_real_T **pEmxArray)
{
  if (*pEmxArray != (emxArray_real_T *)NULL) {
    if (((*pEmxArray)->data != (real_T *)NULL) && (*pEmxArray)->canFreeData) {
      emlrtFreeMex((*pEmxArray)->data);
    }

    emlrtFreeMex((*pEmxArray)->size);
    emlrtFreeMex(*pEmxArray);
    *pEmxArray = (emxArray_real_T *)NULL;
  }
}

static void emxInit_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray,
  int32_T numDimensions, boolean_T doPush)
{
  emxArray_real_T *emxArray;
  int32_T i;
  *pEmxArray = (emxArray_real_T *)emlrtMallocMex(sizeof(emxArray_real_T));
  if (doPush) {
    emlrtPushHeapReferenceStackR2012b(sp, (void *)pEmxArray, (void (*)(void *))
      emxFree_real_T);
  }

  emxArray = *pEmxArray;
  emxArray->data = (real_T *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int32_T *)emlrtMallocMex(sizeof(int32_T) * numDimensions);
  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = k_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T (*g_emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *boundaryType, const char_T *identifier))[6]
{
  real_T (*y)[6];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = h_emlrt_marshallIn(sp, emlrtAlias(boundaryType), &thisId);
  emlrtDestroyArray(&boundaryType);
  return y;
}
  static real_T (*h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId))[6]
{
  real_T (*y)[6];
  y = l_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[3] = { -1, -1, -1 };

  const boolean_T bv0[3] = { true, true, true };

  int32_T iv0[3];
  int32_T i0;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 3U, dims, &bv0[0],
    iv0);
  ret->allocatedSize = iv0[0] * iv0[1] * iv0[2];
  i0 = ret->size[0] * ret->size[1] * ret->size[2];
  ret->size[0] = iv0[0];
  ret->size[1] = iv0[1];
  ret->size[2] = iv0[2];
  emxEnsureCapacity_real_T(ret, i0);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static int32_T (*j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[3]
{
  int32_T (*ret)[3];
  static const int32_T dims[2] = { 1, 3 };

  emlrtCheckBuiltInR2012b(sp, msgId, src, "int32", false, 2U, dims);
  ret = (int32_T (*)[3])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}
  static real_T k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T (*l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[6]
{
  real_T (*ret)[6];
  static const int32_T dims[2] = { 1, 6 };

  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims);
  ret = (real_T (*)[6])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}
  void SteadyState_3D_SOR_Solver_CoreC_api(const mxArray *prhs[17], int32_T nlhs,
  const mxArray *plhs[4])
{
  emxArray_real_T *exGridE1;
  emxArray_real_T *exGridE2;
  emxArray_real_T *extendedGridType;
  const mxArray *prhs_copy_idx_0;
  const mxArray *prhs_copy_idx_1;
  int32_T (*gridSize)[3];
  real_T dx;
  real_T (*boundaryType)[6];
  real_T ru1;
  real_T ru2;
  real_T rl1;
  real_T rl2;
  real_T D1;
  real_T D2;
  real_T Iconst1;
  real_T Iconst2;
  real_T alpha;
  real_T tolerance;
  real_T omega;
  real_T numIt;
  real_T errorCode;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &exGridE1, 3, true);
  emxInit_real_T(&st, &exGridE2, 3, true);
  emxInit_real_T(&st, &extendedGridType, 3, true);
  prhs_copy_idx_0 = emlrtProtectR2012b(prhs[0], 0, true, -1);
  prhs_copy_idx_1 = emlrtProtectR2012b(prhs[1], 1, true, -1);

  /* Marshall function inputs */
  exGridE1->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs_copy_idx_0), "exGridE1", exGridE1);
  exGridE2->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs_copy_idx_1), "exGridE2", exGridE2);
  extendedGridType->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "extendedGridType",
                   extendedGridType);
  gridSize = c_emlrt_marshallIn(&st, emlrtAlias(prhs[3]), "gridSize");
  dx = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[4]), "dx");
  boundaryType = g_emlrt_marshallIn(&st, emlrtAlias(prhs[5]), "boundaryType");
  ru1 = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[6]), "ru1");
  ru2 = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[7]), "ru2");
  rl1 = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[8]), "rl1");
  rl2 = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[9]), "rl2");
  D1 = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[10]), "D1");
  D2 = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[11]), "D2");
  Iconst1 = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[12]), "Iconst1");
  Iconst2 = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[13]), "Iconst2");
  alpha = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[14]), "alpha");
  tolerance = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[15]), "tolerance");
  omega = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[16]), "omega");

  /* Invoke the target function */
  SteadyState_3D_SOR_Solver_CoreC(exGridE1, exGridE2, extendedGridType,
    *gridSize, dx, *boundaryType, ru1, ru2, rl1, rl2, D1, D2, Iconst1, Iconst2,
    alpha, tolerance, omega, &numIt, &errorCode);

  /* Marshall function outputs */
  exGridE1->canFreeData = false;
  emlrt_marshallOut(exGridE1, prhs_copy_idx_0);
  plhs[0] = prhs_copy_idx_0;
  emxFree_real_T(&extendedGridType);
  emxFree_real_T(&exGridE1);
  if (nlhs > 1) {
    exGridE2->canFreeData = false;
    emlrt_marshallOut(exGridE2, prhs_copy_idx_1);
    plhs[1] = prhs_copy_idx_1;
  }

  emxFree_real_T(&exGridE2);
  if (nlhs > 2) {
    plhs[2] = b_emlrt_marshallOut(numIt);
  }

  if (nlhs > 3) {
    plhs[3] = b_emlrt_marshallOut(errorCode);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

void SteadyState_3D_SOR_Solver_CoreC_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  SteadyState_3D_SOR_Solver_CoreC_xil_terminate();
  SteadyState_3D_SOR_Solver_CoreC_xil_shutdown();
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void SteadyState_3D_SOR_Solver_CoreC_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

void SteadyState_3D_SOR_Solver_CoreC_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (_coder_SteadyState_3D_SOR_Solver_CoreC_api.c) */
