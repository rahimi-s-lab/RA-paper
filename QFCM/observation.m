function observedString=observation(qBit)

    nQbit=size(qBit,2);
    r=rand(1,nQbit);
    observedString=r<(qBit(2,:).^2);






end