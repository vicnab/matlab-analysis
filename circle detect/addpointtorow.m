function extrap = addpointtorow(row,number);
 
if(number == 1)
      rowunknownx = row(1,1) - (row(4,1) - row(1,1))/3;
      rowdistancex = rowunknownx - row(1,1);
      rowslope = (row(4,2) - row(1,2))/(row(4,1)-row(1,1));
      rowunknowny = rowdistancex * rowslope+row(1,2);
      extrap = sortrows([rowunknownx rowunknowny; row]);
end
if (number == 5)
      rowunknownx = row(4,1)+ (row(4,1) - row(1,1))/3;
      rowdistancex = rowunknownx - row(4,1);
      rowslope = (row(4,2) - row(1,2))/(row(4,1)-row(1,1));
      rowunknowny = rowdistancex * rowslope+row(4,2);
      extrap = sortrows([rowunknownx rowunknowny; row]);
end