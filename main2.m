
%関数の読み込み

addpath('functions')
rng(1000)
clear global;
reset(gpuDevice(1));
%時系列数
N = 800;

%塩浜先生がお作りしたものを使用しています
sample = csvread("sample_1000.csv",1,1);
sample = sample(1:800,:);
%観測変数の取り出し(観測変数としては使わないものもある)
theta = sample(:,1);
v =sample(:,2);
rho =sample(:,3);
alpha =sample(:,4);

y = theta;
v = v;
r = rho;
alp = alpha;


%パラメータ設定 微妙にずらします
phi1 = 0.97;
gam = 3; % constants in wind speed
mu_g = 0.0; % location in wind direction for transition
mu_f = 0.0; % location in wind direction for marginal
rho_f = 0.1; % consentration in wind direction for marginal
V = 20;
mu_rho = 0.5;
sig_rho=1;
par1 = [phi1 gam mu_g mu_f rho_f V mu_rho sig_rho];
i = 1;
opt_params = zeros(6,10);
%初期パラメータの設定
opt_params(1,:) = [0,0,par1]

while(i == 1 || check/N > 0.0001 || i == 5)

    %ここは計算の関係でCPUでやってます
   [pfOut1,  wt, pfOut1_mean, pfOut2_mean,rho1]  = particle__filter_now(par1,mu_rho,sig_rho,y, v, r, alp, 100);
    phi1 = par1(1);
    i
    [smwt] = particlesmoother(phi1, pfOut1, wt);
    %[smwt] = particlesmoother2(phi1, sig_rho, mu_rho, pfOut1, rho1, wt);
    i
    %sm_mean = diag(smwt(2:(N+1),:) * gpuArray(pfOut1(2:(N+1),:)'));
    i+N
    pw_weight = pair_wise(phi1, pfOut1, wt, smwt);
    %pw_weight = pair_wise2(phi1, sig_rho, mu_rho, pfOut1, rho1, wt, smwt);
    i-N
    PMCEM_calc = @(par1)Q_calc(par1, pfOut1, rho1,pw_weight, smwt, y, v);
    options = optimoptions(@fminunc,'Algorithm','quasi-newton','Display','iter');

    par1(1) = sig_env(par1(1));
    par1(2) = log(par1(2));
    par1(5) = sig_env(par1(5));
    par1(6) = log(par1(6));
    par1(8) = log(par1(8));

    i = i+1;
    [params,fval,exitflag,output] = fminunc(PMCEM_calc, par1, options);

    params(1) = sig(params(1));
    params(2) = exp(params(2));
    params(5) = sig(params(5));
    params(6) = exp(params(6));
    params(8) = exp(params(8));

    par1 = params;
    opt_params(i+1,:) = [i, fval, par1];
    opt_params(:,3:10)
    check = opt_params(i+1,1) - opt_params(i+1,1);
    reset(gpuDevice(1));
end



