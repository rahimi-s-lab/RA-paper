function class = missedSampleEvaluation(missedSample,obtainedWeights)
    
    %this function assign a class to a sample which is not present in the
    %leave-one-out method
    load('TrainSetBalanced.mat');
    load('interSec.mat');
    sample = TrainSet(missedSample,:);
    
        temp=[sample(1,1:9),0.5]*obtainedWeights;
        oneIterSimulation=1./(1+exp(-5*temp));
        temp2=oneIterSimulation*obtainedWeights;
        twoIterSimulation=1./(1+exp(-5*temp2));
        classDistance = CalculateClassAndDistance(twoIterSimulation(1,end)); %CalculateClassAndDistance returns the class of a sample and its square distance to the nearest borders.
        class=classDistance(1);
    
end
