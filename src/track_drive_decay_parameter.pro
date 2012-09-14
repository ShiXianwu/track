function track_drive_decay_parameter, lat, landfall_pres, Pmax = Pmax

  if ~keyword_set(Pmax) then Pmax = 1010
  
  delta_pres = Pmax - landfall_pres
  
  case 1 of
  
    lat gt 0 and lat le 20.8 : a = 0.0124 + 0.0010*delta_pres
    lat gt 20.8 and lat le 22.8 : a = 0.0000 + 0.0012*delta_pres
    lat gt 22.8 and lat le 25.5 : a = 0.0046 + 0.0008*delta_pres
    lat gt 25.5 and lat lt 48.2 : a = 0.0025 + 0.0006*delta_pres
    
  else : a = 0.0524 + 0.0011*delta_pres
  
endcase
return,a

end