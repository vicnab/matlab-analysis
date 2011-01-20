/*********************************************************************
 * Demo.cpp
 *
 * This file shows the basics of setting up a mex file to work with
 * Matlab.  This example shows how to use 2D matricies.  This may
 * 
 * Keep in mind:
 * <> Use 0-based indexing as always in C or C++
 * <> Indexing is column-based as in Matlab (not row-based as in C)
 * <> Use linear indexing.  [x*dimy+y] instead of [x][y]
 *
 * For more information, see my site: www.shawnlankton.com
 * by: Shawn Lankton
 *
 ********************************************************************/
#include <matrix.h>
#include <mex.h>   

/* Definitions to keep compatibility with earlier versions of ML */
#ifndef MWSIZE_MAX
typedef int mwSize;
typedef int mwIndex;
typedef int mwSignedIndex;

#if (defined(_LP64) || defined(_WIN64)) && !defined(MX_COMPAT_32)
/* Currently 2^48 based on hardware limitations */
# define MWSIZE_MAX    281474976710655UL
# define MWINDEX_MAX   281474976710655UL
# define MWSINDEX_MAX  281474976710655L
# define MWSINDEX_MIN -281474976710655L
#else
# define MWSIZE_MAX    2147483647UL
# define MWINDEX_MAX   2147483647UL
# define MWSINDEX_MAX  2147483647L
# define MWSINDEX_MIN -2147483647L
#endif
#define MWSIZE_MIN    0UL
#define MWINDEX_MIN   0UL
#endif

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

//declare variables
    mxArray *a_in_m, *b_in_m, *c_out_m, *d_out_m;
    const mwSize *dimsa, *dimsb;
    double *a, *b, *c, *d;
    int dimxa, dimya, numdimsa, dimxb, dimyb, numdimsb;
    int i,j;

//associate inputs
    a_in_m = mxDuplicateArray(prhs[0]);
    b_in_m = mxDuplicateArray(prhs[1]);

//figure out dimensions
    dimsa = mxGetDimensions(prhs[0]);
    numdimsa = mxGetNumberOfDimensions(prhs[0]);
    dimya = (int)dimsa[0]; dimxa = (int)dimsa[1];
	
	dimsb = mxGetDimensions(prhs[1]);
    numdimsb = mxGetNumberOfDimensions(prhs[1]);
    dimyb = (int)dimsb[0]; dimxb = (int)dimsb[1];

//associate outputs
    c_out_m = plhs[0] = mxCreateDoubleMatrix(dimya,dimxa,mxREAL);
    d_out_m = plhs[1] = mxCreateDoubleMatrix(dimyb,dimxb,mxREAL);

//associate pointers
    a = mxGetPr(a_in_m);
    b = mxGetPr(b_in_m);
    c = mxGetPr(c_out_m);
    d = mxGetPr(d_out_m);

//do something
    for(i=0;i<dimxa;i++)
    {
        for(j=0;j<dimya;j++)
        {
            //mexPrintf("element[%d][%d] = %f\n",j,i,a[i*dimya+j]);
            c[i*dimya+j] = a[i*dimya+j]+5; //adds 5 to every element in a
            
        }
    }
	for(i=0;i<dimxb;i++)
    {
        for(j=0;j<dimyb;j++)
        {
           // mexPrintf("element[%d][%d] = %f\n",j,i,a[i*dimyb+j]);
            d[i*dimyb+j] = b[i*dimyb+j]*b[i*dimyb+j]; //squares b
            
        }
    }
	

    return;
}
