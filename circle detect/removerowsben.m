function [matout] = removerowsben(matin, ind )
%provides row removal that is backwards compatible because mathworks didn't
if(strcmp(version('-release'), '2010b'))
    matout = removerows(matin, 'Ind', ind);
else
    matout = removerows(matin, ind);

end

