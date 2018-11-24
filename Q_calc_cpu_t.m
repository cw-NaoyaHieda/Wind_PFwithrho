function [Q] = Q_calc_cpu(par, pfOut1, rho1, pw_weight, sm_weight, y, v)
  phi1 = sig(par(1)); % AR in state of wind speed 0.99���z�����nan�ɂȂ��Ă��܂�
  gam  = exp(par(2)); % constants in log wind speed
  mu_g = par(3); % location in wind direction for transition
  mu_f = par(4); % location in wind direction for marginal
  rho_f = sig(par(5)); % consentration in wind direction for marginal
  V = exp(par(6));
  mu_rho = par(7); % constants in log wind speed
  sig_rho = exp(par(8));
  
 

  [dT  nParticle]= size(pfOut1);
  Q_state = zeros(dT,1);
  Q_obeserve = zeros(dT,1);
  first_state = 0;

  


  for dt = 2:(dT - 1)
    %alpha_t = ((1/2).*log(rho1(dt,:)./(0.95-rho1(dt,:)))-mu_rho)./(sig_rho);
    rho_t_1 = 0.95 * ( tanh( sig_rho * pfOut1(dt,:) + mu_rho)+1) / 2;
    rho_t_1(rho_t_1 == 0) =  5.2736e-17;
    rho_t_1(rho_t_1 == 0.95) =  0.9499;
    Q_state(dt) = sum(sum(pw_weight(:,:,dt) .* log(normpdf([pfOut1(dt,:)], [phi1 * pfOut1(dt-1,:)]', sqrt(1 - phi1^2)))));
    %tmp1 = arrayfun(@(theta, rho_g) d_conditional_WJ(y(dt-1), theta, mu_g, rho_g, mu_f, rho_f, 1), pfOut2(dt-1,:), rho1(dt-1,:));
    tmp1 = d_conditional_WJ(y(dt), y(dt-1), mu_g, rho_t_1, mu_f, rho_f, 1);
    %tmp2 = gampdf(v(dt-1)./(gam*exp( pfOut1(dt,:) /2)) , V, 1/V) ./ (gam*exp(pfOut1(dt,:)/2));
    tmp2 = gampdf(v(dt)./(gam*exp( pfOut1(dt,:) /2)) , V, 1/V) ./ (gam*exp(pfOut1(dt,:)/2));
    Q_obeserve(dt) = sm_weight(dt,:) * log(tmp1)' + sm_weight(dt,:) * log(tmp2)' ;
    if -100000 > Q_state(dt)
        Q_state(dt);
    end

  end
  %first_state = sm_weight(1,:) * log(normpdf([pfOut1(1,:)], phi1 *  X_0_est, sqrt(1 - phi^2)))';
  Q = -sum(Q_state) - sum(Q_obeserve);
end
