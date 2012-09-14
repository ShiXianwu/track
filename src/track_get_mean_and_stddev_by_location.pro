function track_get_mean_and_stddev_by_location, target_xy, samples_xyz, R0 = R0, $
    R_max = R_max, samples_min = samples_min
    
  if ~keyword_set(R0) then R0 = 400  ; 200 km
  if ~keyword_set(samples_min) then samples_min = 100
  if ~keyword_set(R_max) then R_max = 700; 500km

  R_max_degree = R_max * 0.015
  subscript_tmp = where((abs(samples_xyz[0,*] - target_xy[0]) le R_max_degree) $
    and (abs(samples_xyz[1,*]-target_xy[1]) le R_max_degree),count_tmp)
    
  if count_tmp LT samples_min then begin
    return, [!VALUES.F_NAN, !VALUES.F_NAN]
  endif
  
  samples_LE_R_max_degree = samples_xyz [*, subscript_tmp]
  
  d_all = track_map_2points_modified( target_xy[0], target_xy[1], $
    samples_LE_R_max_degree[0, *, *], samples_LE_R_max_degree[1, *, *])*0.001
    
  subscript_LE_R0 = where(d_all [*] LE R0, count_LE_R0)
  
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
  
  rst_mean  = weight##samples_final[2,*]
  rst_stddev= sqrt(weight##((samples_final[2,*] - rst_mean(0))^2))
  
  return, [rst_mean, rst_stddev]
  
end