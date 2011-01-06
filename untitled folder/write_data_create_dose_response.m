load forbentrial.mat
fid = fopen('Dose_Response.txt', 'wt');
[conditions categories] = size(everything{1});

%%Create a file to record dose response data. Records red, green, blue,
%%gray mean intensity values and standard deviation for each test
%%condition, control condition, exposure and concentration. Saves in a
%%comma separated value text file for easy excel importation
fprintf(fid,'%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s \n', everything{1}{1,1}, 'Concentration', everything{1}{1,2:end});
for i = 1:num_exp
    for j = 2:conditions
        redmeanvec = [];
        greenmeanvec = [];
        bluemeanvec = [];
        graymeanvec = [];
        redstdvec = [];
        greenstdvec = [];
        bluestdvec = [];
        graystdvec = [];
        for k = 1:num_conc
            fprintf(fid, '%s',everything{k}{j,1});
            fprintf(fid, ', %3.2f', conc_vec(k));
            for m = 2:categories
                fprintf(fid, ', %3.2f', everything{k}{j,m}(i));
                switch m
                    case 3
                        redmeanvec = [redmeanvec everything{k}{j,m}(i)];
                    case 4
                        redstdvec = [redstdvec everything{k}{j,m}(i)];
                    case 5
                        greenmeanvec = [greenmeanvec everything{k}{j,m}(i)];
                    case 6
                        greenstdvec = [greenstdvec everything{k}{j,m}(i)];
                    case 7
                       bluemeanvec = [bluemeanvec everything{k}{j,m}(i)];
                    case 8
                        bluestdvec = [bluestdvec everything{k}{j,m}(i)];
                    case 9
                        graymeanvec = [graymeanvec everything{k}{j,m}(i)];
                    case 10
                         graystdvec = [graystdvec everything{k}{j,m}(i)];
                    otherwise
                        
                end
            end
            fprintf(fid, '\n');
        end
        if  mod(j,2) == 0
            subplot(2,2,1)
            dose_response(conc_vec, redmeanvec);
            hold on; errorbar(conc_vec,redmeanvec, redstdvec, 'r*');
            title_text = sprintf('Dose response for %s using the red spectrum at %3.1f ms exposure', everything{1}{j,1}, everything{1}{j,2}(i));
            title(title_text);
            subplot(2,2,2);
            dose_response(conc_vec, greenmeanvec);
            hold on; errorbar(conc_vec,greenmeanvec, greenstdvec, 'r*');
            title_text = sprintf('Dose response for %s using the green spectrum at %3.1f ms exposure', everything{1}{j,1}, everything{1}{j,2}(i));
            title(title_text);      
            subplot(2,2,3);
            dose_response(conc_vec, bluemeanvec);
            hold on; errorbar(conc_vec,bluemeanvec, bluestdvec, 'r*');
            title_text = sprintf('Dose response for %s using the blue spectrum at %3.1f ms exposure', everything{1}{j,1}, everything{1}{j,2}(i));
            title(title_text);   
            subplot(2,2,4);
            
            dose_response(conc_vec, graymeanvec);
            hold on; errorbar(conc_vec,graymeanvec, graystdvec, 'r*');
            title_text = sprintf('Dose response for %s using the gray spectrum at %3.1f ms exposure', everything{1}{j,1}, everything{1}{j,2}(i));
            title(title_text);   
            pause;
        end
    end
    fprintf(fid, '\n');
end