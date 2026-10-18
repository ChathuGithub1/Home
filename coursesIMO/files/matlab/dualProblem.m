P = [2 0;0 8];
Inv_P = inv(P);
q=[1 -2];
r=1;
l=[-2;0]; u=[1;1];


cvx_begin
cvx_precision best
variables x(2) 
dual variables z1 z2
minimize quad_form(x, Inv_P ) + q*x + r

subject to
z1:l-x<=0
z2:x-u<=0
cvx_end

done_ = 1

