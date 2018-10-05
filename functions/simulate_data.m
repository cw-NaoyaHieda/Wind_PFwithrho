function [alpha, theta, v, rho] = simulate_data(N, par)

  phi1    = par(1); % AR in state of wind speed
  gam     = par(2); % constants in log wind speed
  mu_g    = par(3); % location in wind direction for transition
  mu_f    = par(4); % location in wind direction for marginal
  rho_f   = par(5); % consentration in wind direction for marginal
  V       = par(6);
  mu_rho  = par(7);
  sig_rho = par(8);

  tmp_theta = rwrpcauchy(1, mu_rho, sig_rho);
  while tmp_theta > pi
    tmp_theta = tmp_theta-2*pi;
  end
  theta = tmp_theta;


  alpha = ones(N,1);
  v = ones(N,1);
  alpha(1) = 0;

  v(1)  = gam * gamrnd(V, V, (1));


  for i = 2:N
    alpha(i) = phi1*alpha(i - 1) + sqrt(1 - phi1^2) * randn(1);
    tmp_theta = r_conditional_WJ(1, theta(i-1), mu_g, 0.95*(tanh(sig_rho*alpha(i-1)+mu_rho)+1)/2, mu_f, rho_f, 1);
    while tmp_theta > pi
      tmp_theta = theta(i)-2*pi;
    end
    while tmp_theta < -pi
      tmp_theta = theta(i)+2*pi;
    end

    theta(i) = tmp_theta;


    v(i) = gam*exp(alpha(i)/2)*gamrnd(V, V, (1));
  end
  rho =0.95*(tanh(sig_rho.*alpha+mu_rho)+1)/2;

end
