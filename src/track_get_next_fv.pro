;+
; NAME:
;
;    track_get_next_fv
;
; PURPOSE:
;
;    Derive the next point forward velocity
;
; CALLING SEQUENCE:
;
;    Result = track_get_mean_and_stddev_by_location(cur_point,last_point,his_dat, R0 = R0,
;        samples_min = samples_min)
;
; INPUTS:
;
;    cur_xy               : a two elements array, indicating the current point location
;    his_xy_cur_and_last  : a 4*n float arrary,the first and second column is the location of every historical
;                           point,ths last column is the value to be caclulated of every point
;    last_xyz             : a three elements array, indicating the last point location and its velocity
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;    last_xyz         : a three elements array, indicating the last point location and its velocity
;    samples_min      : the minimize samples
;    R0               : the radius of the searching extend
;    R_max            : the maximum radius
;
; OUTPUTS:
;
;     A scalar,represent the next point forward velocity
;
; OPTIONAL OUTPUTS:
;
;
;
; EXAMPLE:
;
;-
function track_get_next_fv,cur_xy, his_xy_cur_and_last, last_xyz = last_xyz, R0 = R0, $
    R_max = R_max,samples_min = samples_min
    
  if ~keyword_set(R0) then R0 = 400  ; 200 km
  if ~keyword_set(samples_min) then samples_min = 100
  if ~keyword_set(R_max) then R_max = 700; 500km
  
  R_max_degree = R_max * 0.015
  subscript_tmp = where((abs(his_xy_cur_and_last[0,*] - cur_xy[0]) le R_max_degree) $
    and (abs(his_xy_cur_and_last[1,*]-cur_xy[1]) le R_max_degree),count_tmp)
    
  if count_tmp LT samples_min then begin
    return, [!VALUES.F_NAN]
  endif
  
  samples_LE_R_max_degree = his_xy_cur_and_last[*, subscript_tmp]
  
  d_all = track_map_2points_modified(cur_xy[0], cur_xy[1], $
    samples_LE_R_max_degree[0, *], samples_LE_R_max_degree[1, *])*0.001
    
  subscript_LE_R0 = where ( d_all [*] LE R0, count_LE_R0)
  
  if count_LE_R0 GE samples_min then begin
    samples_final = samples_LE_R_max_degree [*, subscript_LE_R0]
    d_final       = d_all [subscript_LE_R0]
  endif else begin
    subscript_sort  = sort(d_all)
    subscript_final = subscript_sort [0:samples_min-1]
    samples_final   = samples_LE_R_max_degree [*, subscript_final]
    d_final         = d_all [subscript_final]
  endelse
  
  R_final   = max([max(d_final),R0])
  N_samples = n_elements(d_final)
  
  weight    = (1 - (d_final[*]/R_final))/(N_samples - total(d_final)/R_final)
  
  cur_mean  = weight##samples_final[2,*]
  cur_std   = sqrt(weight##((samples_final[2,*] - cur_mean[0])^2))
  samples_final[2,*] = (samples_final[2,*] - cur_mean[0])/cur_std[0]
  
  last_mean  = weight##samples_final[3,*]
  last_std   = sqrt(weight##((samples_final[3,*] - last_mean[0])^2))
  samples_final[3,*] = (samples_final[3,*] - last_mean[0])/last_std[0]
  
  std_cur_mean = weight##samples_final[2,*]
  std_cur_std  = sqrt(weight##((samples_final[2,*] - std_cur_mean[0])^2))
  
  std_last_mean = weight##samples_final[3,*]
  std_last_std  = sqrt(weight##((samples_final[3,*] - std_last_mean[0])^2))
  
  a_cov = (weight##((samples_final[2,*] - std_cur_mean[0])*(samples_final[3,*]- $
    std_last_mean[0])))/(std_cur_std[0]*std_last_std[0])
    
  if ~keyword_set(last_xyz) then begin
    next_fv = cur_mean + cur_std*(1-a_cov^2)*randomn(seed,1)
  endif else begin
    maen_and_std = track_get_mean_and_stddev_by_location(last_xyz[0:1],his_xy_cur_and_last[0:2,*],$
      R0 = R0,samples_min = samples_min,R_max = R_max)
    next_fv      = cur_mean + cur_std*(a_cov*(last_xyz[2]-maen_and_std[0])/maen_and_std[1] + $
      sqrt(1-a_cov^2)*randomn(seed,1))
  endelse
  
  return,next_fv
  
end