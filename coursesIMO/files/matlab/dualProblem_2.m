P = [1;2]*[1 2]+ [2;1]*[2 1];
%P =[2 3;3 5];
%P = [0.5 0.4;0.4 0.5]*100/9
a=sqrt(10)*[1 1];

cvx_begin
variables x(2)
dual variables y
minimize a*x
subject to
y:0.5*x'*P*x-5<=0
cvx_end


L = 1/sqrt(10)*sqrt(a*inv(P)*a');
xx = -1/L*inv(P)*a';
done = 1