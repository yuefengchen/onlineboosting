#ifndef STDAFX_MATLAB_HEADER
#define STDAFX_MATLAB_HEADER
#include "mex.h"
#include "mexutils.h"
#include "string.h"
#define A_IN prhs[0] 
#define B_IN prhs[1]
#define C_IN prhs[2]
#define D_IN prhs[3]
#define E_IN prhs[4]
#define A_OUT plhs[0]
#define B_OUT plhs[1]
#define C_OUT plhs[2]
#define D_OUT plhs[3]
#define E_OUT plhs[4]
#define     AREA            0
#define     TYPE            1
#define     LOCATION        2
#define     WEIGHT          3
#define     INDEX           4
#define     POSGAUSSIAN     5
#define     NEGGAUSSIAN     6
#define     CORRECT         7
#define     WRONG           8

#define     NUMSELECTORS       0
#define     OVERLAP            1
#define     SEARCHFACTOR       2
#define     MINFACTOR          3
#define     ITERATIONINIT      4
#define     NUMWEAKCLASSIFIER  5
#define     MINAREA            6
#define     IMGWIDTH           7
#define     IMGHEIGHT          8
struct patches {
    int x; 
    int y;
    int width;
    int height;
};
#define matrix2d matrix<double> **
#endif