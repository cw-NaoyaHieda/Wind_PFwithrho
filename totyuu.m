
%関数の読み込み
addpath('functions')
rng(8123431)
clear;
%時系列数
N = 800;

parpool(12)

sample = csvread("2017-12_for_matlab.csv",1,1);
%観測変数の取り出し(観測変数としては使わないものもある)

theta = sample(:,2);
v =sample(:,1);
totyuu = csvread("opt_para_totyuu.csv",1,1);
y = theta;
v = v;

k = 0;
opt_params = zeros(1,11);
chekcer = 0;
for j = 1:10
    %パラメータ設定 微妙にずらします
    phi1 = totyuu(j,1);
    gam = totyuu(j,2); % constants in wind speed
    mu_g = totyuu(j,3); % location in wind direction for transition
    mu_f = totyuu(j,4); % location in wind direction for marginal
    rho_f =totyuu(j,5); % consentration in wind direction for marginal
    V = totyuu(j,6);
    mu_rho = totyuu(j,7);
    sig_rho= totyuu(j,8);
    par1 = [phi1 gam mu_g mu_f rho_f V mu_rho sig_rho];

    i=1;
    opt_params(k+1,:) = [j,i,0,par1]
    chekcer(k+1) = 0;
    k = k+1;
    
    %初期パラメータの設定
    
    while(i == 1 || i==2||(abs(check) > 0.00001 && i <= 50))
    
        %ここは計算の関係でCPUでやってます
       [pfOut1,  wt, pfOut1_mean, pfOut2_mean,rho1]  = particle__filter_now_cpu(par1,mu_rho,sig_rho,y, v, 0, 0, 100);
        phi1 = par1(1);
        i
        [smwt] = particlesmoother_cpu(phi1, pfOut1, wt);
        %[smwt] = particlesmoother2(phi1, sig_rho, mu_rho, pfOut1, rho1, wt);
        i
        %sm_mean = diag(smwt(2:(N+1),:) * gpuArray(pfOut1(2:(N+1),:)'));
        i+N
        pw_weight = pair_wise_cpu(phi1, pfOut1, wt, smwt);
        %pw_weight = pair_wise2(phi1, sig_rho, mu_rho, pfOut1, rho1, wt, smwt);
        i-N
        
        PMCEM_calc = @(par1)Q_calc_cpu(par1, pfOut1, rho1,pw_weight, smwt, y, v);
        options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','UseParallel',true);
        
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
        opt_params(k+1,:) = [j,i,fval,par1]
        check = (opt_params(k+1,3) - opt_params(k,3))/opt_params(k,3);
        chekcer(k+1) = check
        k = k+1;
        opt_params(:,4:11)
        abs(check)
        j
    end
end
%目的関数　最初は0にしているので、x=1から始まっています

csvwrite('/home/naoya/opt_params_shirahama201712_2_kouhann.csv',[opt_params, chekcer'])

