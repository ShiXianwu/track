function track_lysis_by_pres,pres
  
  prob = 0.0076*exp(0.0894*(pres-965))
  rand = randomu(seed,1)
  
  if rand gt prob then begin
    lysis_test = 0 
  endif else begin
    lysis_test = 1
  endelse
  
  return,lysis_test
  
end