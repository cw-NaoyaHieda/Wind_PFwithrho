addpath('functions')
rng(1000)
clear global;
reset(gpuDevice(1));
%���n��
N = 300;

%���l�搶������肵�����̂��g�p���Ă��܂�
sample = csvread("sample_1000.csv",1,1);
sample = sample(1:300,:);
%�ϑ��ϐ��̎��o��(�ϑ��ϐ��Ƃ��Ă͎g��Ȃ����̂�����)
theta = sample(:,1);
v =sample(:,2);
rho =sample(:,3);
alpha =sample(:,4);

y = theta;
v = v;
r = rho;
alp = alpha;


%�p�����[�^�ݒ� �����ɂ��炵�܂�
phi1 = 0.97;
gam = 3; % constants in wind speed
mu_g = 0.0; % location in wind direction for transition
mu_f = 0.0; % location in wind direction for marginal
rho_f = 0.1; % consentration in wind direction for marginal
V = 20;
mu_rho = 0.5;%given
sig_rho=1;%given
par1 = [phi1 gam mu_g mu_f rho_f V];

opt_params = zeros(6,8);
%�����p�����[�^�̐ݒ�
opt_params(1,:) = [0,0,par1];

[pfOut1, pfOut2, wt, pfOut1_mean, pfOut2_mean,rho1] = particlefilter_reallycorrect_notexpress(par1,mu_rho,sig_rho,y, v, r, alp, 2000);
phi1 = par1(1);
i
    [smwt] = particlesmoother(phi1, pfOut1, wt);
    %[smwt] = particlesmoother2(phi1, sig_rho, mu_rho, pfOut1, rho1, wt);
    i
    sm_mean = diag(smwt(2:(N+1),:) * gpuArray(pfOut1(2:(N+1),:)'));
    i+N
    pw_weight = pair_wise(phi1, pfOut1, wt, smwt);
    %pw_weight = pair_wise2(phi1, sig_rho, mu_rho, pfOut1, rho1, wt, smwt);
    i-N
    
    
    
    PMCEM_calc = @(par1)Q_calc_now(par1, pfOut1, pfOut2, rho1,pw_weight, smwt, y, v);
   