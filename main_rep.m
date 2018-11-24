%GPUのデバイスの数確認
%gpuDeviceCount
%現在使用しているデバイスの確認
%gpuDevice
%seed
addpath('functions')
rng(1000)
clear global;
%ParticleFilter数
%各パラメータ
N = 100;
%phi1 = 0.97 ; % AR in state of wind speed
%gam = 3; % constants in wind speed
%mu_g = 0.0; % location in wind direction for transition
%mu_f = 0.0; % location in wind direction for marginal
%rho_f =0.1; % consentration in wind direction for marginal
%V = 20;
%mu_rho = 0.5;
%sig_rho=1;
%パラメータセット
%par1 = [phi1 gam mu_g mu_f rho_f V mu_rho sig_rho];

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

opt_params = zeros(80,11);

for count = 1:5
  phi1 = 0.97 + random('Normal',0, 0.01); % AR in state of wind speed
  gam = 3 + random('Normal',0, 1); % constants in wind speed
  mu_g = 0.0 + random('Normal',0, 0.1); % location in wind direction for transition
  mu_f = 0.0 + random('Normal',0, 0.1); % location in wind direction for marginal
  rho_f =0.1 + random('Normal',0, 0.1); % consentration in wind direction for marginal
  V = 20+ random('Normal',0, 4);
  mu_rho = 0.5+ random('Normal',0, 0.1);
  sig_rho=1+ random('Normal',0, 0.2);
  %パラメータセット
  par1 = [phi1 gam mu_g mu_f rho_f V mu_rho sig_rho];
  opt_params((count-1)*16 + 1,:) = [count, 0, par1, 0];
  for count2 = 1:15
    [pfOut1, pfOut2, wt, pfOut1_mean, pfOut2_mean, rho1] = particlefilter_reallycorrect(par1, y, v, r, alp, 100);
    [smwt] = particlesmoother(phi1, pfOut1, wt);
    
    sm_mean = diag(smwt(2:(N+1),:) * gpuArray(pfOut1(2:(N+1),:)'));
    pw_weight = pair_wise(phi1, pfOut1, wt, smwt);
    
    PMCEM = @(par1)Q_calc(par1, pfOut1, pfOut2, rho1,pw_weight, smwt, y, v);
    options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
    
    par1(1) = sig_env(par1(1));
    [params,fval,exitflag,output] = fminunc(PMCEM, par1, options);
    params(1) = sig(params(1));
    par1 = params;
    opt_params((count-1)*16 + count2 +1,:) = [count, count2, par1, fval];
  end
end


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



