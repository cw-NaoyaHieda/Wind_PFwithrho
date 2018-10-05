function [newdata1, newdata2, newweight] = simulate_data(data1, data2, weight, NofSample)
  cs_weight = cumsum(weight);
  ch = rand(1,NofSample) < cs_weight';
  
  y =  NofSample - sum(ch) + 1;
  
  newdata1 = data1(y);
  newdata2 = data2(y);
  newweight = weight(y);
end
