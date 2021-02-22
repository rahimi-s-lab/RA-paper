function Error = objectiveFunction(x)
    
    %Note: to change objective function: change interSec and
    %normalizationFactor from GaussianMF.m
    
    NormalizationFactor=0.6250;
    load('TrainSetBalanced.mat');
    TrainSet=[TrainSet(1:5,:);TrainSet(7:end,:)];
    n=numel(x);
    weight=reshape(x,[sqrt(n),sqrt(n)]);
        
    Missed=0;
    Distance=0;
    for i=1:size(TrainSet,1)
          temp=[TrainSet(i,1:end-1),0.5]*weight;
          oneIterSimulation=1./(1+exp(-5*temp));
          temp2=oneIterSimulation*weight;
          twoIterSimulation=1./(1+exp(-5*temp2));
          classDistance = CalculateClassAndDistance(twoIterSimulation(1,end)); %CalculateClassAndDistance returns the class of a sample and its square distance to the nearest borders.
          if (classDistance(1) ~= TrainSet(i,10)) %if the sample was missclassified
            Missed=Missed+1;
          end
          Distance = Distance + classDistance(2);
    end
    Error=(Missed/size(TrainSet,1))+Distance/NormalizationFactor;
    
end
