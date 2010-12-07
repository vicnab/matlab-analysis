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
    mxArray *centers_in_m, *beaddata, *numlinedata, *radius_in_m, *img_in_m, *maxima_out_m, *avg_out_m;
    const mwSize *dimsimg;
    double *centers, *maxima, *img, *avg;
	double radval;
	int beadnum, xmin, xmax, ymin, ymax, beaditr, dimximg, dimyimg, dimy, numline;
    int y,x,max, sum, counter;
	
	//associate inputs
    centers_in_m = mxDuplicateArray(prhs[0]);
	beaddata = mxDuplicateArray(prhs[1]);
	numlinedata = mxDuplicateArray(prhs[2]);
	radius_in_m = mxDuplicateArray(prhs[3]);
	img_in_m = mxDuplicateArray(prhs[4]);
	
	
	//figure out dimensions
    dimsimg = mxGetDimensions(prhs[4]);
    dimyimg = (int)dimsimg[0]; dimximg = (int)dimsimg[1];
	
	
	//associate input pointers
	
	centers = mxGetPr(centers_in_m);
	//bead = mxGetPr(bead_in_m);
	//radius = mxGetPr(radius_in_m);
	img = mxGetPr(img_in_m);
	//associate outputs
	radval = mxGetScalar(radius_in_m);
	beadnum = (int)(mxGetScalar(beaddata));
	numline = (int)(mxGetScalar(numlinedata));
	//radval = radius[0];
	//dimy = 2*.7*radval+1;
    maxima_out_m = plhs[0] = mxCreateDoubleMatrix(numline,beadnum, mxREAL);
	avg_out_m = plhs[1] = mxCreateDoubleMatrix(beadnum,1,mxREAL);
	//associate output pointers
	maxima = mxGetPr(maxima_out_m);
	avg = mxGetPr(avg_out_m);
	
	
	
	
	//do something
	for(beaditr = 0; beaditr < beadnum; beaditr++){
		
		counter = 0;
		
		xmin = (int)(centers[beaditr] - radval*2);
		xmax = (int)(centers[beaditr] + radval*2);
		ymin = centers[beaditr+beadnum] - 0.5*numline;
		ymax = centers[beaditr+beadnum] + 0.5*numline;
		  sum = 0;
		//mexPrintf("ymin%d ymax:%d xmin:%d xmax:%d dimyimg:%d max:%d\n",ymin,ymax, xmin, xmax,dimyimg, (xmax-1)*dimyimg+y-1);
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
			maxima[counter-1 + beaditr*numline]=max;
			sum+= max;
			//mexPrintf("%d\n", max);
			//mexPrintf("beaditr now: %d\n", counter-1 + beaditr*dimy);
			
		}
		avg[beaditr] = (double)(sum)/(double)(counter);
	}
	
	//mexPrintf("%d\n",dimximg);
	
    return;
}
