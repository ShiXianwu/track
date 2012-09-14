;+
; NAME:
;
;    track_get_delt_fd
;
; PURPOSE:
;
;    Derive the change of direction of the next track point
;
; CALLING SEQUENCE:
;
;    Result = track_get_delt_fd(target_xy,samples_xyz, R0 = R0, $
;                     R_max = R_max, samples_min = samples_min)
;
; INPUTS:
;
;    target_xy  : a there elements float array, indicating the location of the target point and its current
;                 forward direction
;    samples_xyz: a 4*n float arrary, the first and the second columns represent the
;                 location of the historical points. the third column is current point forward direction, the
;                 last column is the variation of the last track point
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;    samples_min      : the minimize samples
;    R0               : the radius of the searching extend
;    R_max            : the maximum searching radius
;
; OUTPUTS:
;
;     A scalar,represent the variation of the last track point
;
; OPTIONAL OUTPUTS:
;
;
;
; EXAMPLE:
;
;
function sample_pdf,fd_hist,row,seed = seed

  sz    = size(fd_hist)
  array = fd_hist(*,row)
  
  n_random = 1
  
  n_bin = n_elements(array)
  
  if max(array) eq 0 then begin
  
    hist = total(fd_hist,2)
    tm   = max(hist,sub)
    return,sub-row
    
  endif
  
  array = array/total(array)
  array = array/max(array)
  
  while n_random gt 0 do begin
    while 1 do begin
      temp = randomu(seed,2)
      i_bin = floor(temp(0)*n_bin)
      if(array(i_bin) GT temp(1)) then begin
        n_random = n_random - 1
        break
      endif
    endwhile
    col = temp(0)*n_bin
  endwhile
  
  return,col
  
end
function track_get_delt_fd,target_xy,samples_xyz, R0 = R0, $
    R_max = R_max, samples_min = samples_min
    
  if ~keyword_set(R0) then R0 = 400  ; 400 km
  if ~keyword_set(samples_min) then samples_min = 100
  if ~keyword_set(R_max) then R_max = 700; 700km
  
  kernel3 = [$
    [ 1,2,1], $
    [ 2,8,2], $
    [ 1,2,1]]
    
  samples_final = track_select_sample_by_r(target_xy,samples_xyz, R0 = R0, R_max = R_max, samples_min = $
    samples_min)
    
  sub1 = where(samples_final[3,*] gt 180 ,cnt1)
  if cnt1 gt 0 then samples_final[3,sub1] = samples_final[3,sub1] - 360
  sub2 = where(samples_final[3,*] lt -180,cnt2)
  if cnt2 gt 0 then samples_final[3,sub2] = samples_final[3,sub2] + 360
  
  fd_hist = CONVOL( float(hist_2D(samples_final[3,*], samples_final[2,*], BIN1=2.5, BIN2=22.5 ,MIN1=-40 ,$
    MIN2=-180 ,MAX1 = 40, MAX2 = 180)) , kernel3, /NORMALIZE, /EDGE_ZERO )
    
  delt_sum  = total(fd_hist,1)
  
  for i_delt = 0,n_elements(delt_sum)-2 do begin
  
    if delt_sum(i_delt) le 0.05*total(delt_sum) then begin
    
      delt_mid = samples_final[2,*] - (-180 + (i_delt+0.5)*22.5)
      sub1     = where(delt_mid gt 180 ,cnt1)
      if cnt1 gt 0 then  delt_mid[sub1] = delt_mid[sub1]-360
      sub2     = where(delt_mid lt -180 ,cnt2)
      if cnt2 gt 0 then  delt_mid[sub2] = delt_mid[sub2]+360
      fd_hist[*,i_delt] = histogram(delt_mid,binsize = 2.5,min = -40, max = 40)
      
    endif
    
  endfor
  
  row       = floor((target_xy(2)+180)/22.5)
  
  seed      = (target_xy(0)/target_xy(1)+ target_xy(2)*randomu(seed)*10)*1234
  col       = sample_pdf(fd_hist,row,seed = seed)
  delt_fd   = -40 + col*2.5
  
  return,delt_fd
  
end