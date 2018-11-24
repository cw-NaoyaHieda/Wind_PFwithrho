function [smwt] = particlesmoother_cpu(phi1, pfOut1, wt)
  [Xsize Ysize] = size(pfOut1);
  
  smwt = wt;
  
  
  
  for dt = (Xsize - 1):-1:1
    sm_table1 = normpdf([pfOut1(dt+1,:)], [phi1 *  pfOut1(dt, :)]', sqrt(1 - phi1^2));
    bunsi = smwt(dt+1, :) .* sm_table1;
    bunbo = wt(dt, :) * sm_table1;
    smwt(dt,:) = wt(dt,:)' .* (bunsi * (1./bunbo)');
  end
end