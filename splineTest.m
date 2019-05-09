points=(1:length(BasePoints));

for 


x = 0:25;
y = besselj(1,x);
xq2 = 0:0.01:25;
p = pchip(x,y,xq2);
s = spline(x,y,xq2);
plot(x,y,'o',xq2,p,'-',xq2,s,'-.')
legend('Sample Points','pchip','spline')

