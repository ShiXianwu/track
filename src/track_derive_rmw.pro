;+
;NAME:
;
;   track_derive_RMW
;
;AUTHOR:
;   Shi Xianwu
;   xianwu.shi@mail.bnu.edu.cn
;
;PURPOSE:
;
;   choose proper method to caculate RMW (radius of maximum wind)
;
;CALLING SEQUENCE:
;   result=track_derive_RMW(pres,lat, type = type,Pmax = Pmax)
;
;ARGUMENTS:
;   type:there are 4 type to get the radius of maximum wind
;          default:a statistical relation developed by Lin Wei(2011)
;          1:a statistical relation developed by Vickery(2008)
;          2:a statistical relation developed by Jiangzhihui(2008)
;          3:a statistical relation developed by Willoughby & Rahn(2004)
;   Cp:the central pressure
;   lat:the absolute value of latitude in degrees
;
;KEYWORDS:
;   Pn:the peripheral pressure,default:1010hpa
;
;OUTPUTS:
;   a float number, i.e., RMW of a tropical cyclone
function track_derive_RMW,Cp, lat = lat, type = type, Pmax = Pmax

  if ~keyword_set(Pmax) then Pmax = 1010
  
  if ~keyword_set(type) then begin
  
    RMW = -18.04 * alog(Pmax-Cp) + 110.22
    return,RMW
    
  endif
  
  if keyword_set(type) then begin
  
    case type of
      1: RMW = exp(3.015 - 6.291*10^(-5)*(Pmax - Cp)^2 + 0.0337*lat)
      2: RMW = 1119.0*(Pmax - Cp)^(-0.805)
      3: RMW = exp(3.94- 0.0223*5.402*(Pmax - Cp)^0.464 + 0.0281*lat)
    endcase
    
    return,RMW
  endif
end