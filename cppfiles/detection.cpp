/* ==========================================================================
 * detection.cpp
 * example for illustrating how to manipulate structure and cell array
 *
 * takes a (MxN) structure matrix and returns a new structure (1x1)
 * containing corresponding fields: for string input, it will be (MxN)
 * cell array; and for numeric (noncomplex, scalar) input, it will be (MxN)
 * vector of numbers with the same classID as input, such as int, double
 * etc..
 *
 * This is a MEX-file for MATLAB.
 * Copyright 1984-2006 The MathWorks, Inc.
 *==========================================================================*/
/* $Revision: 1.6.6.2 $ */

#include "stdafx.h"
#include "cppmatrix.h"
#include "classifier.h"
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
    
    const mxArray * haar_ptr;
    const mxArray * parameter_ptr;
    const mxArray * selector_ptr;
    const mxArray * alpha_ptr;
    
    int nfields, NStructElems, ifield, jstruct;
    matrix2d  haarfeature;
    mxArray * tmp;
    
    if(nrhs != 2) {
        mexErrMsgTxt("tow input argument required.");
    }
    // read the prhs[0]  sumimagedata
    // read the prhs[1]  the patches [x , y, w , h]
    // 
    matrix<double> sumimagedata = matrix<double>(A_IN);
    matrix<double> patches = matrix<double>(B_IN);
    
    // global values
    haar_ptr      = mexGetVariablePtr("caller", "haarfeature");
    selector_ptr  = mexGetVariablePtr("caller", "selectors");
    alpha_ptr     = mexGetVariablePtr("caller", "alpha");
    
    // read haar_ptr
    nfields = mxGetNumberOfFields(haar_ptr);
    NStructElems = mxGetNumberOfElements(haar_ptr);
    haarfeature = new matrix<double> * [NStructElems];
    for(jstruct  = 0; jstruct < NStructElems; jstruct ++)
        haarfeature[jstruct] = new matrix<double>[nfields];
    
    // haarfeature is the mxArray point the struct
    // haarfeature[jstruct][ifield] means the i(th) field in j(th) struct
    for(ifield = 0; ifield < nfields; ifield ++) {
        for(jstruct = 0; jstruct < NStructElems; jstruct ++) {
            // get the haarfeature(jstruct).field(ifield)
            tmp = mxGetFieldByNumber(haar_ptr, jstruct, ifield);
            if(tmp == NULL) {
            mexPrintf("%s%d\t%s%d\n", "FIELD: ", ifield+1, "STRUCT INDEX :", jstruct+1);
            mexErrMsgTxt("Above field is empty!"); 
            } 
            haarfeature[jstruct][ifield] = matrix<double>(tmp);
            //haarfeature[jstruct][ifield] = tmp;
        }
    }
    
    matrix<double> selector = matrix<double>(selector_ptr);
    matrix<double> alpha = matrix<double>(alpha_ptr);
    /*
    mexPrintf("M= %d  \t  N = %d\n", haarfeature[0][0].M, haarfeature[0][0].N);
    for(int row = 0 ; row < haarfeature[0][0].M; row ++){
        for(int col = 0 ; col < haarfeature[0][0].N; col ++)
            mexPrintf("%lf ", haarfeature[0][0].data[col*haarfeature[0][0].M + row]);
        mexPrintf("\n");
    }
     */
    A_OUT = mxCreateDoubleMatrix(sumimagedata.M - 1, sumimagedata.N - 1, mxREAL);
    matrix<double> confidencemap = matrix<double>(A_OUT);
    classify(&patches, &alpha, &selector, &haarfeature, &sumimagedata, confidencemap);
   
    for(jstruct  = 0; jstruct < NStructElems; jstruct ++)
        delete [] haarfeature[jstruct];
    delete [] haarfeature;
    
}