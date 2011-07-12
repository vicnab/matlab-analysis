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
#include <math.h>

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
    mxArray *centers_in_m, *beaddata, *radius_in_m, *img_in_m, *minima_out_m, *avg_out_m;
    const mwSize *dimsimg;
    double *centers, *minima, *img, *avg;
    double radval, curavg, dist;
    int beadnum, xmin, xmax, ymin, ymax, beaditr, dimximg, dimyimg, dimy, numcircles;
    int y,x,min, sum, counter, numpts, k;
    int meanval;
    
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
    //radius = mxGetPr(radius_in_m);
    img = mxGetPr(img_in_m);
    //associate outputs
    radval = mxGetScalar(radius_in_m);
    beadnum = (int)(mxGetScalar(beaddata));
    //radval = radius[0];
    //dimy = 2*.7*radval+1;
 
    avg_out_m = plhs[0] = mxCreateDoubleMatrix(numcircles,beadnum, mxREAL);
    minima_out_m = plhs[1] = mxCreateDoubleMatrix(beadnum,1,mxREAL);
    //associate output pointers
    minima = mxGetPr(minima_out_m);
    avg = mxGetPr(avg_out_m);
    
    meanval = (int)(radval);
    numcircles = (int)(meanval-6-2)/2+1;
    
    //do something
     mexPrintf("numcircles%d meanrad:%d beadnum:%d\n", numcircles, meanval, beadnum);
    for(beaditr = 0; beaditr < (int)(beadnum); beaditr++){}
        
        
        
        
       
       // sum = 0;
   //     counter = 0;
     //   counter++;
    //    for(k = 6; k<= meanval-2; k = k+2)
      //  {  
                 
//             min = 256;
//             numpts = 0;
//             for(y=0;y< dimyimg;y++)
//             {
//                 
//                 for(x=0;x< dimximg;x++)
//                 {
//                     mexPrintf("beaditr+beadnum%d\n", beaditr*beadnum);
//                     dist = sqrt(pow(x-centers[beaditr*beadnum],2) + pow(y - centers[beaditr*beadnum + 1],2));
//                     mexPrintf("dist%f\n", dist);
//                     if(dist < meanval - k +2 & dist >meanval - k){
//                         sum = sum + img[(x-1)*dimyimg+y-1];
//                         numpts = numpts + 1;
//                     }
//                 }
//             }
//             curavg = sum/numpts;
//             mexPrintf("curavg%d\n", curavg);
//              avg[counter-1 + beaditr*numcircles]=(double)(sum)/(double)(numpts);
//              if(sum/numpts < min){
//                  min = (double)(sum)/(double)(numpts);
//              }
     //   }
//         minima[beaditr] = (double)(min);
 //   }
    
    
    
    return;
}
