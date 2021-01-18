%Be name Omide darmandeghan; QFCM algorithm by Mojtaba Kolahdoozi, all rights reserved.

clear;
clc;
close all;

%% Problem definition
costFunction = @objectiveFunction;
load('TrainSetBalanced.mat');
missedSample=7;  %a sample (row number) in TrainSetBalanced which is being tested in leave one out
numberOfNodes=size(TrainSet,2);
nVar=numberOfNodes^2;
varMin=-1*ones(1,nVar);
varMax=+1*ones(1,nVar);


%% Parameter setting
nPopStr=100;                  %number of structure population
nLocalGroups=10;             %number of local groups for local migration.NOTE NOTE that rem(nPopStr,nlocalGroups) should be zero.     

nPopWeights=80;             %number of sub populations of weights for each structure
epsilon=0.01;    %0.005;     %epsilon of H-epsilon quantum gate
mu=0.01;                     %probability of uniform mutation
maxIter=20000;               %maximum number of iterations
deltaTheta=0.005*pi;          %rotation angle of H-epsilon gate
globalMigrationPeriod=20;   %global migration period for mutation
localMigrationPeriod=10;    %local migration period for mutation


%% Initialization

%creating population matrix
empty.qBitInd=[];
empty.observed=[];
empty.cost=[];
empty.best=[];
particle.position=[];
particle.velocity=[];
particle.cost=[];
particle.best.position=[];
particle.best.cost=[];
empty.particle=repmat(particle,nPopWeights,1);
Q=repmat(empty,nPopStr,1);

%creating global best particle for each subpopulation
bestParticle.position=[];
bestParticle.cost=[];
bestParticle=repmat(bestParticle,nPopStr,1);

for i=1:nPopStr
    
    Q(i).qBitInd=repmat([1/sqrt(2);1/sqrt(2)],1,nVar);          %initializng qbits with 1/sqrt(2)      
    Q(i).observed=observation(Q(i).qBitInd);                    %Qbit observatioan
    
    for j=1:nPopWeights
        temp=0;
        while(sum(abs(temp)<0.05)~=0)
            temp=unifrnd(varMin,varMax,[1 nVar]);
        end
        Q(i).particle(j).position=temp;                         %initializing particles
        Q(i).particle(j).best.position=temp;                    %initializing self best particle
        Q(i).particle(j).velocity=0;                            %initilizing velocity
        
        Q(i).particle(j).cost=costFunction(Q(i).particle(j).position.*Q(i).observed);       %evaluating jth particle undet the ith structure
        Q(i).particle(j).best.cost=Q(i).particle(j).cost;                                   %initializing self best cost of each particle
        
    end
    [bestParticleCost,IndexBestParticle]=min([Q(i).particle(:).cost]);      %initialize best global particle for each subpopulation
    bestParticle(i).position=Q(i).particle(IndexBestParticle).position;     %initialize position of best global particle for each subpopulation
    bestParticle(i).cost=bestParticleCost;                                  %initialize cost of best global particle for each subpopulation
    Q(i).cost=min([Q(i).particle(:).cost]);                                 %obtain cost of ith qbit with the minimum of its subpopulations                       
    Q(i).best=Q(i);                                               %initialize best cost of qbit   
           
end


%initialize best of qbits (b)
bestMatrix=[];
for i=1:nPopStr
    bestMatrix=[bestMatrix,Q(i).best.cost];
end
[~,indexBestQbit]=min(bestMatrix);
b=Q(indexBestQbit).best;


%% main loop

%obtaining mutation indices for all the subpopulations
    if rem(nPopWeights,2)==0
        indexMutation=randperm(nPopWeights/2,ceil(mu*nPopWeights));
        indexMutation=indexMutation+nPopWeights/2;
    else
        indexMutation=randperm((nPopWeights+1)/2,ceil(mu*nPopWeights));
        indexMutation=indexMutation+(nPopWeights-1)/2;
    end
for iter=1:maxIter
    
    for i=1:nPopStr
        
        %observing qbit individual
        Q(i).observed=observation(Q(i).qBitInd);
        
        
        %for each particle in the ith structure do these things:
        for j=1:nPopWeights
            
            Q(i).particle(j).velocity=unifrnd(0.1,0.5)*Q(i).particle(j).velocity+...        %update velocity
                unifrnd(1.5,2)*rand([1 nVar]).*(Q(i).particle(j).best.position-Q(i).particle(j).position)+...
                unifrnd(1.5,2)*rand([1 nVar]).*(bestParticle(i).position-Q(i).particle(j).position);
            
            Q(i).particle(j).position=Q(i).particle(j).position+Q(i).particle(j).velocity;   %update position  
            %perform uniform mutation
            if (sum(indexMutation==j)~=0)
                Q(i).particle(j).position=(varMax-varMin).*rand([1 nVar]) + varMin;
                
            end
            %check boundary
            [Q(i).particle(j).position,Q(i).particle(j).velocity]=checkBoundary(Q(i).particle(j).position,Q(i).particle(j).velocity,varMax,varMin);             %check boundary
            %evaluate jth particl under ith structure
            Q(i).particle(j).cost=costFunction(Q(i).particle(j).position.*Q(i).observed);
            
            %update self best of jth particle
            if (Q(i).particle(j).cost<Q(i).particle(j).best.cost) 
                
                Q(i).particle(j).best.cost=Q(i).particle(j).cost;
                Q(i).particle(j).best.position=Q(i).particle(j).position;                
            end
                        
        end
        %update best global particle inside ith subpopulation
        if (min([Q(i).particle(:).cost])<bestParticle(i).cost)
            [bestParticleCost,IndexBestParticle]=min([Q(i).particle(:).cost]);
            bestParticle(i).cost=bestParticleCost;
            bestParticle(i).position=Q(i).particle(IndexBestParticle).position;
            
        end
        
        %update cost of ith qbit
        Q(i).cost=min([Q(i).particle(:).cost]);
        
        %update ith q-bit individual
        Q(i).qBitInd=hEpsilongate(Q(i).qBitInd,deltaTheta,epsilon,Q(i).observed,Q(i).best.observed,Q(i).cost,Q(i).best.cost);
        
        %update best cost and observed of ith qbit individual
        if Q(i).cost<Q(i).best.cost
            Q(i).best=Q(i);
        end
               
    end
    
    %update b (best qbit individual)
    bestMatrix=[];
    for i=1:nPopStr
        bestMatrix=[bestMatrix,Q(i).best.cost];
    end
    if min(bestMatrix)<b.cost        
        [~,indexBestQbit]=min(bestMatrix);
        b=Q(indexBestQbit).best;                
    end
    
    %perform global migration
    if rem(iter,globalMigrationPeriod)==0
        for i=1:nPopStr
            Q(i).best.observed=b.observed;
            Q(i).best.cost=b.cost;
        end
        
    end
    
    
    %perform local migration
    if rem(iter,localMigrationPeriod)==0
        localMutationIndex=1:(nPopStr/nLocalGroups):nPopStr;
        for i=1:nLocalGroups
            [minLocal,indexMinLocal]=min([Q(localMutationIndex(i):localMutationIndex(i)+(nPopStr/nLocalGroups)-1).cost]);
            for j=localMutationIndex(i):(localMutationIndex(i)+(nPopStr/nLocalGroups)-1)
                Q(j).best.cost=minLocal;
                Q(j).best.observed=Q(indexMinLocal+localMutationIndex(i)-1).best.observed;
            end

        end
    end
    
    %density=sum(b.observed==1)/numel(b.observed);
    [Min,IDX]=min([b.particle(:).cost]);
    obtainedWeights=(reshape(b.particle(IDX).position,numberOfNodes,numberOfNodes).*reshape(b.observed,numberOfNodes,numberOfNodes));
    realDensity=sum(sum((reshape(b.particle(IDX).position,numberOfNodes,numberOfNodes).*reshape(b.observed,numberOfNodes,numberOfNodes))~=0))/numberOfNodes^2;
    Error=b.cost;
    predictedClass = missedSampleEvaluation(missedSample,obtainedWeights);
    
    fprintf('Iteration:%d\tdensity:%f\tError:%f\ttrue class:%d\tpredicted class:%d\n',iter,realDensity,Error,TrainSet(missedSample,10),predictedClass);    
    
     
    
end














