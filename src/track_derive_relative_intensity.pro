;+
; NAME:
;
;    track_derive_relative_Intensity
;
; PURPOSE:
;
;    Derive the relative intensity of the track point 
;
; CALLING SEQUENCE:
;
;    Result =track_derive_relative_Intensity(oft,sst,ri,pmax=pmax)
;
; INPUTS:
;
;    oft        : outflow temperature of the track point's location(100 hpa high, monthly mean value)
;    sst        : sea surface temperature of the track point's location(monthly mean value)
;    pres       : the central pressure of the track point
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;    pmax        : the external air pressure
;
; OUTPUTS:
;
;     A scalar,represent the track point's relative intensity
;
; OPTIONAL OUTPUTS:
;
;
;
; EXAMPLE:
;
;
function track_derive_relative_Intensity,oft,sst,pres,pmax=pmax

  if(~keyword_set(pmax)) then pmax = 1010
  
  rv = 461
  rh = 0.80
  e = (sst-oft)/sst
  es = 6.112*exp(17.67*(sst-273.)/(sst-29.5))
  Pda = pmax - (rh*es)
  Lv = 2500000 - 2320.0*(sst-273)
  a = e*Lv*es/((1-e)*rv*sst*Pda)
  b = rh*(1+es*alog(rh)/(Pda*a))
  
  x = track_derive_x(a,b)
  
  RI = (pmax - pres + (1-rh)*es )/((1-x)*(pmax-(rh*es)))
  
  return,RI
  
end