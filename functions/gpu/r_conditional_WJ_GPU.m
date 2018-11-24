function [result] = r_conditional_WJ_GPU(n, theta0, mu_g, rho_g,  mu_f, rho_f, q)
  dx = -pi:0.01:pi;
  M = max(arrayfun(@(x) d_conditional_WJ(x, theta0, mu_g, rho_g, mu_f, rho_f, q),dx));

  i = 1;
  result = 1:n;
  while i <= n
    x = rand(1) * 2 * pi-pi;
    y = M * rand(1);
    f = d_conditional_WJ(x, theta0, mu_g, rho_g,  mu_f, rho_f,q);
    if y <= f
      result(i) = x;
      i = i+1;
    end
  end
end
