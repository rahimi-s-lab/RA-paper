function classDistance = CalculateClassAndDistance (x)
    %This function assings a class number to the numerical value of the
    %FCM's output
    
    load ('interSec.mat');  %intersection points of Gaussian MFs wich are calculated by GauusianMF.m
    
    
    x1=find(x>=interSec,1,'last');
    x2=find(x<interSec,1,'first');
    
    
    class = min(x1,x2)-1;
    Distance= (x-interSec(x1))^2+(x-interSec(x2))^2;
    classDistance=[class;Distance];
    


end