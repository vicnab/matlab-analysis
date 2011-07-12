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
    mxArray *centers_in_m, *beaddata, *radius_in_m, *img_in_m, *minima_out_m, *avg_out_m, *new_img_in_m, *new_img_out_m;
    const mwSize *dimsimg;
    double *centers, *minima, *img, *avg, *newimgin,*newimgout;
    double radval, curavg, dist, numcircles;
    int beadnum, xmin, xmax, ymin, ymax, beaditr, dimximg, dimyimg, dimy;
    int y,x,min, sum, counter, numpts, k;
    int meanval;
    int step, start;
    start = 6;
    step = 1;
    //associate inputs
    centers_in_m = mxDuplicateArray(prhs[0]);
    beaddata = mxDuplicateArray(prhs[1]);
    radius_in_m = mxDuplicateArray(prhs[2]);
    img_in_m = mxDuplicateArray(prhs[3]);
    new_img_in_m = mxDuplicateArray(prhs[4]);
    
    
    //figure out dimensions
    dimsimg = mxGetDimensions(prhs[3]);
    dimyimg = (int)dimsimg[0]; dimximg = (int)dimsimg[1];
    
    
    //associate input pointers
    
    centers = mxGetPr(centers_in_m);
    //bead = mxGetPr(bead_in_m);
    //radius = mxGetPr(radius_in_m);
    img = mxGetPr(img_in_m);
    newimgin = mxGetPr(new_img_in_m);
    //associate outputs
    radval = mxGetScalar(radius_in_m);
    beadnum = (int)(mxGetScalar(beaddata));
    //radval = radius[0];
    //dimy = 2*.7*radval+1;
    //meanval = (int)(radval);
      numcircles = floor((radval-start-step)/step+1);
    
    //numcircles = 12;
        mexPrintf("numcircles%d meanrad:%d beadnum:%d\n", (int)(numcircles), (int)(radval), beadnum);
    avg_out_m = plhs[0] = mxCreateDoubleMatrix(beadnum,(int)(numcircles), mxREAL);
    minima_out_m = plhs[1] = mxCreateDoubleMatrix(beadnum,1,mxREAL);
    new_img_out_m = plhs[2] = mxCreateDoubleMatrix(dimyimg,dimximg,mxREAL);
    //associate output pointers
    newimgout = mxGetPr(new_img_out_m);
    minima = mxGetPr(minima_out_m);
    avg = mxGetPr(avg_out_m);
   minima[0] = 1; 
     for(y=0;y< dimyimg;y++) {
            for(x=0;x< dimximg;x++){
                newimgout[x*dimyimg+y] = img[x*dimyimg+y];
            }
     }
                    
    
    //do something
     mexPrintf("numcircles%d meanrad:%d beadnum:%d\n",(int) numcircles, (int)(radval), beadnum);
     counter = 0;
     for(beaditr = 0; beaditr < (beadnum); beaditr++){
   //       for(beaditr = 0; beaditr < 1; beaditr++){
        
        
           counter = 0;
       
      
      
       
  for(k = start; k<= floor(radval)-step; k = k+step){
//       for(k = 6; k<= 6; k = k+2){
         
          counter++;
         
               sum = 0;    
             min = 256;
             numpts = 0;
            for(y=1;y<= dimyimg;y++)
             {
                
                for(x=1;x<= dimximg;x++)
                {
                    
                    dist = sqrt(pow(x-centers[beaditr],2) + pow(y - centers[beadnum +beaditr],2));
                    
                    if(dist < radval - k +step && dist >radval - k){
                        
                        sum = sum + img[(x-1)*dimyimg+y-1];
                     //   mexPrintf("sum: %d numpts: %d imgval: %f\n", sum, numpts, img[(x-1)*dimyimg+y-1]);
                        newimgout[(x-1)*dimyimg+y-1] = 255;
                        numpts = numpts + 1;
                    }
                }
            }
            
            curavg = double(sum)/double(numpts);
           
             avg[(counter-1)*beadnum+beaditr]=(double)(sum)/(double)(numpts);
             if(curavg < min){
                 min = curavg;
                // mexPrintf("Success\n");
             }
      }
            mexPrintf("Centers x for beaditr %d: %f Centers y for beaditr %d: %f\n\n", beaditr, centers[beaditr], beaditr, centers[beadnum +beaditr]);
       minima[beaditr] = min;
    }
    
    mexPrintf("counter: %d \n",counter);
    
    return;
}
