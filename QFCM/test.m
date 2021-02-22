lb=0.5;
ub=0.7;
fun=@(x)(x(1)-lb)^2+(x(1)-ub)^2;
opt=optimoptions('particleswarm','SwarmSize',100,'Display','iter');
y=particleswarm(fun,1,lb,ub,opt);