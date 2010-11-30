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
    mxArray *xmin_in_m, *xmax_in_m, *ymin_in_m, *ymax_in_m, *img_in_m, *avg_out_m;
    const mwSize *dimsimg;
    double *xmin, *xmax, *ymin, *ymax, *img, *avg;
    int dimximg, dimyimg;
    int y,x, sum, max, counter;

//associate inputs
    xmin_in_m = mxDuplicateArray(prhs[0]);
    xmax_in_m = mxDuplicateArray(prhs[1]);
	ymin_in_m = mxDuplicateArray(prhs[2]);
	ymax_in_m = mxDuplicateArray(prhs[3]);
	img_in_m = mxDuplicateArray(prhs[4]);

//figure out dimensions
    dimsimg = mxGetDimensions(prhs[4]);
    dimyimg = (int)dimsimg[0]; dimximg = (int)dimsimg[1];
	

	


//associate outputs
    avg_out_m = plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);


//associate pointers
    xmin = mxGetPr(xmin_in_m);
	xmax = mxGetPr(xmax_in_m);
	ymin = mxGetPr(ymin_in_m);
	ymax = mxGetPr(ymax_in_m);
	img = mxGetPr(img_in_m);
	avg = mxGetPr(avg_out_m);
	
	


//do something
    counter = 0;
	sum = 0;
	for(y=ymin[0];y<=ymax[0];y++)
    { counter ++;
		max = 0;
	
        for(x=xmin[0];x<=xmax[0];x++)
        {
           // mexPrintf("x: %d\n",x);

			if(img[x*dimyimg+y]>max){ //adds 5 to every element in a
				max = img[x*dimyimg+y];
			}
        }
		sum+=max;
    }
	avg[0] = (int)(sum/counter);
//	avg[0] =  max;
	

    return;
}
