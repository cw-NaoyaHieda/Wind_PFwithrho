function [r] = rwrpcauchy(n, location = 0, rho = exp(-1))
%RのCircStatsのrwrpcauchyと同じ処理
  if rho == 0
    r = randi([0, 2*pi], 1, n);
  else if rho == 1
    r = repmat(location, n);
  else
    scale <- -log(rho);
    pd = makedist('tLocationScale','mu',location,'sigma',scale,'nu',1);
    r = rem(random(pd, N, 1), (2 * pi));
  end
end
