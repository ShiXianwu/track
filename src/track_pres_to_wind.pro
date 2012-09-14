function track_pres_to_wind,pres, Pmax = Pmax
  
  if~keyword_set(Pmax) then Pmax = 1010 
  ws = 4.405*(Pmax - pres)^0.579
  
  return,ws
  
end