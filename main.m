%GPUのデバイスの数確認
gpuDeviceCount
%現在使用しているデバイスの確認
gpuDevice
%seed
rng(1024)
clear global;
reset(gpuDevice(1));
%ParticleFilter数
%各パラメータ
N = 100;
phi1 = 0.97; % AR in state of wind speed
gam = 3; % constants in wind speed
mu_g = 0.0; % location in wind direction for transition
mu_f = 0.0; % location in wind direction for marginal
rho_f =0.1; % consentration in wind direction for marginal
V = 20;
mu_rho = 0.5;
sig_rho=1;
%パラメータセット
par1 = [phi1 gam mu_g mu_f rho_f V mu_rho sig_rho];


z <- simulate_data(N, par=par1)

%答え
X = ones(dT,1,'gpuArray');
DR = ones(dT,1,'gpuArray');

X(1) = sqrt(beta)*X_0 + sqrt(1 - beta) * random('Normal',0,1);


for i = 2:dT
    X(i) = sqrt(beta)*X(i-1) + sqrt(1 - beta) * random('Normal',0,1);
    DR(i) = r_DR(X(i-1),q_qnorm, rho, beta);
end
fprintf('X DR set\n');
DR(1) = DR(2)*(random('Normal',0,1)*0.05+1);
csvwrite("data_9/X_plot.csv",X);
csvwrite("data_9/DR_plot.csv",DR);
csvwrite("data_9/DR_mean.csv",(q_qnorm-sqrt(beta*rho)*X)/(1-rho));
%data = csvread("data/X.csv");
%X = data(1:98,3);
%pd = makedist('Normal',0,1);
%DR = icdf(pd,data(2:99,5));


X_0_est = X_0;
beta_est = beta;
rho_est = rho;
q_qnorm_est = q_qnorm;

[filter_X, filter_weight, filter_X_mean] = particle_filter(N, dT, DR, beta, q_qnorm, rho, X_0);
fprintf('Filter end\n');
csvwrite('data_9/filter_X.csv',filter_X);
csvwrite('data_9/filter_weight.csv',filter_weight)
csvwrite('data_9/filter_mean.csv',filter_X_mean);
[sm_X, sm_weight, sm_X_mean] = particle_smoother(N, dT, beta, filter_X, filter_weight);
fprintf('Smoothing end\n');
csvwrite('data_9/smoothing_mean.csv',sm_X_mean);
[pw_weight] = pair_wise_weight(N, dT, beta_est, filter_X, filter_weight, sm_weight);
fprintf('pw_weight set\n');
PMCEM = @(params)Q_calc_nf(params, X_0, dT, pw_weight, filter_X, sm_weight, DR);
first_pm = [sig_env(beta),q_qnorm,sig_env(rho)];
%options = optimoptions(@fminunc,'Display','iter','UseParallel',true,'Algorithm','quasi-newton');
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
[params,fval,exitflag,output] = fminunc(PMCEM, first_pm, options);
params
PMCEM(first_pm)
fval
csvwrite("data/matlab_pf_809.csv",filter_X_mean);
csvwrite("data/matlab_sm_809.csv",sm_X_mean);
plot(1:dT,X)
hold on
plot(1:(dT-1),filter_X_mean)
hold on
plot(1:(dT-1),sm_X_mean)
hold off
legend('Answer','filter','smoother')
