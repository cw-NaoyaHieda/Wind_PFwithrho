�%GPU縺?���??繝�?�う繧?��縺?��謨?��遒ｺ隱?
%gpuDeviceCount
%迴?��蝨?��菴?��逕ｨ縺励※縺?繧九ョ繝�?�う繧?��縺?��遒ｺ隱?
%gpuDevice
%seed
addpath('functions')
rng(1000)
clear global;
%ParticleFilter謨?��
%蜷?繝代Λ繝｡繝ｼ繧?��
N = 100;
phi1 = 0.97; % AR in state of wind speed
gam = 3; % constants in wind speed
mu_g = 0.0; % location in wind direction for transition
mu_f = 0.0; % location in wind direction for marginal
rho_f =0.1; % consentration in wind direction for marginal
V = 20;
mu_rho = 0.5;
sig_rho=1;
%繝代Λ繝｡繝ｼ繧?��繧?���??�??
par1 = [phi1 gam mu_g mu_f rho_f V mu_rho sig_rho];

%[alpha, theta, v, rho] = simulate_data(N, par1);
sample = csvread("sample.csv",1,1);
theta = sample(:,1);
v =sample(:,2);
rho =sample(:,3);
alpha =sample(:,4);
%plot(1:N,alpha)
%plot(1:N,theta)
%plot(1:N,v)
%plot(1:N,rho)

y = theta;
v = v;
r = rho;
alp = alpha;

[pfOut1, pfOut2, wt, pfOut1_mean, pfOut2_mean] = particlefilter_reallycorrect(par1, y, v, r, alp, 1024);
[smwt] = particlesmoother(phi1, pfOut1, wt);

sm_mean = diag(smwt(2:(N+1),:) * gpuArray(pfOut1(2:(N+1),:)'));


plot(2:(N+1),alp)
hold on
plot(2:(N+1),pfOut1_mean(2:(N+1)))
hold on
plot(2:(N+1),sm_mean)
%csvwrite("filterdata/out1_1024really.csv",pfOut1);
%csvwrite("filterdata/out2_1024really.csv",pfOut2);
%csvwrite("filterdata/weight_1024really.csv",wt);
%csvwrite("filterdata/out1_mean_1024really.csv",pfOut1_mean(1:(N+1)));
%csvwrite("filterdata/out2_mean_1024really.csv",pfOut2_mean(1:(N+1)));
%csvwrite("filterdata/sm_mean_1024.csv",sm_mean);
%csvwrite("filterdata/smwt.csv",smwt);



