function [ETnew,xarray,ET]=cellmaker(noe,noc)

for i=1:noe
    
    value=input('Enter Exposure time in for #.### ')
    ETnew{i}=[num2str(value)]
    ET(i)=value
    
end

for i=1:noc
    value=input('Enter Concentration value')
    xarray(i)=value
end