clear;
clc;
x=0:0.001:1;
load('TrainSet.mat');

sigma=0.08;
c=[0;0.15;0.3;0.5;0.7;1];  %define center of Gaussian MFs
y1=gaussmf(x,[sigma,c(1)]);
y2=gaussmf(x,[sigma,c(2)]);
y3=gaussmf(x,[sigma,c(3)]);
y4=gaussmf(x,[sigma,c(4)]);
y5=gaussmf(x,[sigma,c(5)]);
y6=gaussmf(x,[sigma,c(6)]);

figure;
hold on;
plot(x,y1,'LineWidth',1.5);
plot(x,y2,'LineWidth',1.5);
plot(x,y3,'LineWidth',1.5);
plot(x,y4,'LineWidth',1.5);
plot(x,y5,'LineWidth',1.5);
plot(x,y6,'LineWidth',1.5);
hold off;

interSec=zeros(size(c,1)+1,1);
%generate intersections of Gaussian MFs
for i=2:size(c,1)
    interSec(i,1)=(sigma*c(i-1)+sigma*c(i))/(sigma+sigma);
end

interSec(size(c,1)+1,1)=1;

NormalizationFactor=(size(TrainSet,1)*(max(diff(interSec)))^2);