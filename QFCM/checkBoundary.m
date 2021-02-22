function [position,velocity]=checkBoundary(position,velocity,varMax,varMin)

    position(position<varMin)=varMin(position<varMin);
    velocity(position<varMin)=-1*velocity(position<varMin);
    
    position(position>varMax)=varMax(position>varMax);
    velocity(position>varMax)=-1*velocity(position>varMax);
    
    position(abs(position)<0.05)=0;
    




end