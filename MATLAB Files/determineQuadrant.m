function z=determineQuadrant(qBit)
    
    alpha=qBit(1,1);
    beta=qBit(2,1);
    
    if alpha>0 && beta>0
        z=1;
    elseif alpha<0 && beta>0
        z=-1;
    elseif alpha<0 && beta<0
        z=+1;
    elseif alpha>0 && beta<0
        z=-1;
    else
        z=1;
    end





end