function Evaluation(obtainedWeights)
    
    %Data visualization... create plot for classified samples.
    %missclassified samples will be shown in red and correctly classified
    %samples will be shown in green
    
    load('TrainSetBalanced.mat');
    load('interSec.mat');
    y=-1:0.1:+1;
    figure;
    hold on;
    
    %ploting the borders.
    for i=1:size(interSec,1)
        plot(interSec(i)*ones(size(y)),y,'LineWidth',1.2,'color','blue');
    end
    
    for i=1:size(TrainSet,1)
        temp=[TrainSet(i,1:9),0.5]*obtainedWeights;
        oneIterSimulation=1./(1+exp(-5*temp));
        temp2=oneIterSimulation*obtainedWeights;
        twoIterSimulation=1./(1+exp(-5*temp2));
        classDistance = CalculateClassAndDistance(twoIterSimulation(1,end)); %CalculateClassAndDistance returns the class of a sample and its square distance to the nearest borders.
        
        %green for correctly classified samples and red for missclasified
        %samples.
        if (classDistance(1) ~= TrainSet(i,10)) %if the sample was missclassified
            scatter(twoIterSimulation(1,end),0,'MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0],'LineWidth',1.5);
            TXT=sprintf('True class:%d\nidentified class:%d',TrainSet(i,10),classDistance(1));  %add text to missclassified samples
            text(twoIterSimulation(1,end),0,TXT);
        else
            scatter(twoIterSimulation(1,end),0,'MarkerEdgeColor',[0 1 0],'MarkerFaceColor',[0 1 0],'LineWidth',1.5);
        end
    end
    hold off;
    
end
