/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * main.c
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include files */
#include "SteadyState_3D_SOR_Solver_CoreC.h"
#include "main.h"
#include "SteadyState_3D_SOR_Solver_CoreC_terminate.h"
#include "SteadyState_3D_SOR_Solver_CoreC_emxAPI.h"
#include "SteadyState_3D_SOR_Solver_CoreC_initialize.h"

/* Function Declarations */
static void argInit_1x3_int32_T(int result[3]);
static void argInit_1x6_real_T(double result[6]);
static int argInit_int32_T(void);
static double argInit_real_T(void);
static emxArray_real_T *c_argInit_UnboundedxUnboundedxU(void);
static void main_SteadyState_3D_SOR_Solver_CoreC(void);

/* Function Definitions */
static void argInit_1x3_int32_T(int result[3])
{
  int result_tmp;

  /* Loop over the array to initialize each element. */
  /* Set the value of the array element.
     Change this value to the value that the application requires. */
  result_tmp = argInit_int32_T();
  result[0] = result_tmp;

  /* Set the value of the array element.
     Change this value to the value that the application requires. */
  result[1] = result_tmp;

  /* Set the value of the array element.
     Change this value to the value that the application requires. */
  result[2] = argInit_int32_T();
}

static void argInit_1x6_real_T(double result[6])
{
  int idx1;

  /* Loop over the array to initialize each element. */
  for (idx1 = 0; idx1 < 6; idx1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result[idx1] = argInit_real_T();
  }
}

static int argInit_int32_T(void)
{
  return 0;
}

static double argInit_real_T(void)
{
  return 0.0;
}

static emxArray_real_T *c_argInit_UnboundedxUnboundedxU(void)
{
  emxArray_real_T *result;
  static int iv1[3] = { 2, 2, 2 };

  int idx0;
  int idx1;
  int idx2;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_real_T(3, iv1);

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
      for (idx2 = 0; idx2 < result->size[2U]; idx2++) {
        /* Set the value of the array element.
           Change this value to the value that the application requires. */
        result->data[(idx0 + result->size[0] * idx1) + result->size[0] *
          result->size[1] * idx2] = argInit_real_T();
      }
    }
  }

  return result;
}

static void main_SteadyState_3D_SOR_Solver_CoreC(void)
{
  emxArray_real_T *exGridE1;
  emxArray_real_T *exGridE2;
  emxArray_real_T *extendedGridType;
  int iv0[3];
  double dv0[6];
  double numIt;
  double errorCode;

  /* Initialize function 'SteadyState_3D_SOR_Solver_CoreC' input arguments. */
  /* Initialize function input argument 'exGridE1'. */
  exGridE1 = c_argInit_UnboundedxUnboundedxU();

  /* Initialize function input argument 'exGridE2'. */
  exGridE2 = c_argInit_UnboundedxUnboundedxU();

  /* Initialize function input argument 'extendedGridType'. */
  extendedGridType = c_argInit_UnboundedxUnboundedxU();

  /* Initialize function input argument 'gridSize'. */
  /* Initialize function input argument 'boundaryType'. */
  /* Call the entry-point 'SteadyState_3D_SOR_Solver_CoreC'. */
  argInit_1x3_int32_T(iv0);
  argInit_1x6_real_T(dv0);
  SteadyState_3D_SOR_Solver_CoreC(exGridE1, exGridE2, extendedGridType, iv0,
    argInit_real_T(), dv0, argInit_real_T(), argInit_real_T(), argInit_real_T(),
    argInit_real_T(), argInit_real_T(), argInit_real_T(), argInit_real_T(),
    argInit_real_T(), argInit_real_T(), argInit_real_T(), argInit_real_T(),
    &numIt, &errorCode);
  emxDestroyArray_real_T(extendedGridType);
  emxDestroyArray_real_T(exGridE2);
  emxDestroyArray_real_T(exGridE1);
}

int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  SteadyState_3D_SOR_Solver_CoreC_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_SteadyState_3D_SOR_Solver_CoreC();

  /* Terminate the application.
     You do not need to do this more than one time. */
  SteadyState_3D_SOR_Solver_CoreC_terminate();
  return 0;
}

/* End of code generation (main.c) */
