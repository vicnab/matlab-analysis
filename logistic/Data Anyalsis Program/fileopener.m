function fileopener(numberoffiles)
nof=numberoffiles;
ij.IJ.run('Install...')
for i=1:nof
ij.IJ.run('Macro test 042310 v10 AOI multi pic TEST BEAD STATUS')
end