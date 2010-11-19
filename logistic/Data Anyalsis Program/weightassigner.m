function [sda]=weightassigner(sdb)

[m,n]=size(sdb);

for i=1:m
    
    if sdb(i)==0
        sdb(i)=max(sdb);
    end

    sda(i)=1/(sdb(i));

    
end

