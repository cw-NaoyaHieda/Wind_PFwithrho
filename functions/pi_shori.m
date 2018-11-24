function [y] = pi_shori(x)
  while x> pi
    x = x-2*pi;
  end
  while x < -pi
    x = x+2*pi;
  end
  y = x;
end
