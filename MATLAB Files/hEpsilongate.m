function outQBit=hEpsilongate(qBit,deltaTheta,epsilon,x,b,fx,fb)

    %look up tables 
    firsThirdQuadrantTable=[0 0 0 0;0 0 1 0;0 1 0 0;0 1 1 +1*deltaTheta;1 0 0 0;1 0 1 -1*deltaTheta;1 1 0 0; 1 1 1 0];    
    
    nQBit=size(qBit,2);
    outQBit=zeros(2,nQBit);
    for i=1:nQBit
        
        lightening=[x(i),b(i),fx>=fb];
        idx = ismember(firsThirdQuadrantTable(:,1:3),lightening,'rows');
        rotationAngle=firsThirdQuadrantTable(logical(idx),4);
        rotationAngle=determineQuadrant(qBit(:,i))*rotationAngle;        %determineQuadrant returns +1 for first and third quadrants and -1 for 2nd and 4th quadrants
        outQBit(:,i)=[cos(rotationAngle) -sin(rotationAngle);sin(rotationAngle) cos(rotationAngle)]*qBit(:,i);
        if outQBit(1,i)^2<=epsilon
            outQBit(:,i)=[sqrt(epsilon);sqrt(1-epsilon)];
        elseif outQBit(1,i)^2>=(1-epsilon)
            outQBit(:,i)=[sqrt(1-epsilon);sqrt(epsilon)];
            
        end
                  
        
        
    end
    

    








end