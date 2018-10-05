function [out] = d_conditional_WJ(x, theta0, mu_g, rho_g,  mu_f, rho_f, q)

if nargin==6
  q= 1;
end
tmp1 = psswrappedcauchy(x, mu_f, rho_f,0);
tmp2 = psswrappedcauchy(theta0, mu_f, rho_f,0);
out1 = dsswrpcauchy( 2*pi*(tmp1-q*tmp2), mu_g, rho_g,0);
out = 2*pi.*out1*dsswrpcauchy(x, mu_f, rho_f, 0);
end
