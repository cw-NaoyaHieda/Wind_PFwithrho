function [r] = rwrpcauchy(n, location, rho)
%RのCircStatsのrwrpcauchyと同じ処理
  if rho == 0
    r = randi([0, 2*pi], n, 1);
  else if rho == 1
    r = repmat(location, n, 1);
  else
    scale = -log(rho);
    %pd = makedist('tLocationScale','mu',location,'sigma',scale,'nu',1);
    pd = makedist('Stable','alpha',1,'beta',0,'gam',scale^2,'delta',location);
    r = rem(abs(random(pd, n, 1)), (2 * pi));
  end
end
