function [out] = dsswrpcauchy(theta, mu, rho, lambda)
  out = (1 - rho.^2)./((2 * pi) .* (1 + rho.^2 - 2 * rho .* cos(theta - mu))).*(1+lambda*sin(theta-mu));
end
