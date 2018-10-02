function [z] = simulate_data(N, par1)

  phi1    = par[1]; % AR in state of wind speed
  gam     = par[2]; % constants in log wind speed
  mu_g    = par[3]; % location in wind direction for transition
  mu_f    = par[4]; % location in wind direction for marginal
  rho_f   = par[5]; % consentration in wind direction for marginal
  V       = par[6];
  mu_rho  = par[7];
  sig_rho = par[8];


  tmp_theta = rwrpcauchy(N, mu_rho, sig_rho);
  if tmp_theta > pi
    theta = tmp_theta-2*pi;
  else
    theta = tmp_theta;
  end

  alpha = ones(N,1);
  alpha[1] = 10;

  v  = gam * gamrnd(V, V, [1 1]);


  for n = 2:N
    alpha[i] = phi1*alpha[i - 1] + sqrt(1 - phi1^2) * randn(1);


end
