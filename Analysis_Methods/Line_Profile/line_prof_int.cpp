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
    mxArray *centers_in_m, *beaddata, *radius_in_m, *img_in_m, *maxima_out_m;
    const mwSize *dimsimg;
    double *radius, *centers, *maxima, *img;
	double radval;
	int beadnum, xmin, xmax, ymin, ymax, beaditr, dimximg, dimyimg, dimy;
    int y,x, sum,max, counter;
	
	//associate inputs
    centers_in_m = mxDuplicateArray(prhs[0]);
	beaddata = mxDuplicateArray(prhs[1]);
	radius_in_m = mxDuplicateArray(prhs[2]);
	img_in_m = mxDuplicateArray(prhs[3]);
	
	
	//figure out dimensions
    dimsimg = mxGetDimensions(prhs[3]);
    dimyimg = (int)dimsimg[0]; dimximg = (int)dimsimg[1];
	
	
	//associate input pointers
	
	centers = mxGetPr(centers_in_m);
	//bead = mxGetPr(bead_in_m);
	radius = mxGetPr(radius_in_m);
	img = mxGetPr(img_in_m);
	//associate outputs
	beadnum = (int)(mxGetScalar(beaddata));
	radval = radius[0];
	dimy = 2*radval+1;
    maxima_out_m = plhs[0] = mxCreateDoubleMatrix(34,20, mxREAL);
	//associate output pointers
	maxima = mxGetPr(maxima_out_m);
	
	
	
	
	//do something
	for(beaditr = 0; beaditr < beadnum; beaditr++){
		
		counter = 0;
		
		xmin = (int)(centers[beaditr] - radval*2);
		xmax = (int)(centers[beaditr] + radval*2);
		ymin = centers[beaditr+beadnum] - radval;
		ymax = centers[beaditr+beadnum] + radval;
		
		for(y=ymin;y<=ymax;y++)
		{
			
			counter ++;
			max = 0;
			
			for(x=xmin;x<=xmax;x++)
			{
				if(img[(x-1)*dimyimg+y-1]>max){ //adds 5 to every element in a
					max = img[(x-1)*dimyimg+y-1];
				}
			}
			maxima[counter-1 + beaditr*dimy]=max;
			//mexPrintf("%d\n", max);
			//mexPrintf("beaditr now: %d\n", counter-1 + beaditr*dimy);
			//maxima[0] = max;
			//maxima[0] = max;
			
		}
	}

	//mexPrintf("%d\n",dimximg);
	
    return;
}
