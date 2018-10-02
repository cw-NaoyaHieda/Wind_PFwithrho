function [out] = d_conditional_WJ(x, theta0, mu_g, rho_g,  mu_f, rho_f, q=1)
tmp1 = psswrappedcauchy(x, mu=mu_f, rho=rho_f,lambda=0)
tmp2 = psswrappedcauchy(theta0, mu=mu_f, rho=rho_f,lambda=0)
out1 = dsswrpcauchy( 2*pi*(tmp1-q*tmp2), mu =mu_g, rho=rho_g,lambda=0)
out = 2*pi*out1*dsswrpcauchy(x, mu =mu_f, rho=rho_f,lambda=0)
end
