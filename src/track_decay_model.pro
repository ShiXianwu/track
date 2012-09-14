function track_decay_model, landfall_pres, a, landfall_time, Pmax = Pmax
  
  if ~keyword_set(Pmax) then Pmax = 1010
  
  t   = landfall_time*6
  dp0 = Pmax - landfall_pres
  dp  = dp0*exp(-a*t)
  pres= Pmax - dp
  
  return,pres
  
end