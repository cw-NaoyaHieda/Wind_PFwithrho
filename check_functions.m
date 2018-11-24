
data = r_conditional_WJ(10000, 0.3, 0.3, 0.1,  0.4, 0.8, 1);
%hist(data)data = r_conditional_WJ(10000, 0.3, 0.3, 0.1,  0.4, 0.8, 1);
%hist(data)

d_conditional_WJ(2, 0.3, 0.6, 0.1,  0.4, 0.8, 1)

dsswrpcauchy(0.1, 0.4, 0.2, 0.1)

psswrappedcauchy(0.1, 0.4, 0.2, 0)

data = rwrpcauchy(10000, 0.2, 0.01);
hist(data)

pd = makedist('tLocationScale','mu',0.2,'sigma',0.1,'nu',1);
r = random(pd, 10000, 1);
%hist(r)

x = 0:0.01:6;
%pd = makedist('tLocationScale','mu',0.2,'sigma',-log(0.1)),'nu',1);
pd = makedist('Stable','alpha',1,'beta',0,'gam',(-log(0.01))^2,'delta',0.2);
%y = abs(pdf(pd,x));
%hist(y)

%gampdf(20,V,V)

data = r_conditional_WJ(10000, 0.3, 0.3, 0.1,  0.4, 0.8, 1);
%hist(data)

data2 = r_conditional_WJ_GPU(10000, 0.3, 0.3, 0.1,  0.4, 0.8, 1);
hist(data2)