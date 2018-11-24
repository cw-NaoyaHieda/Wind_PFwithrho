function [tmp] = psswrappedcauchy(y, mu , rho, lambda)
  tmp1 = (1+rho)./(1-rho).*tan( (y-mu)./2 );
  tmp2 = lambda.*(1-rho.^2)./(4.*pi.*rho).*log( (1+rho.^2-2.*rho.*cos(y-mu))./(1+rho).^2 );
  tmp = (0.5+ atan(tmp1)./pi+tmp2);
end
