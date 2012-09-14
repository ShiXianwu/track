; NAME:
;
;    track_get_sample_by_pdf
;
; PURPOSE:
;
;    Derive samples from the pdf 
;    a input location(x,y) and the historical samples (x,y,z)
;
; CALLING SEQUENCE:
;
;    Result = track_get_sample_by_pdf(target_xy,samples_xyz, R0 = R0, $
;                     R_max = R_max, samples_min = samples_min,max_sample = max_sample, $
;                     min_sample = min_sample, n_bins = n_bins, n_samples = n_samples)
;
; INPUTS:
;
;    target_xy  : a two elements float array, indicating the location of the target point
;    samples_xyz: a 3*n float arrary, the first and the second columns represent the 
;                 location of the historical points. the last column is attribute data, 
;                 such as velocity, direction, pressure, etc.
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;    R0         : the intial radius of the searching circle. default value: 400km
;    R_max      : the maximum radius of the searching circle. default value: 600km
;    samples_min: the minimum number of samples located inside the circel with radius R0
;    max_sample : the maximum edge value
;    min_sample : the minimum edge value
;    n_bins     : the number of bins to use
;    n_samples  : the number of sample desire to be derived
;
; OUTPUTS:
;
;       
;
; OPTIONAL OUTPUTS:
;
;
;
; EXAMPLE:
;
; DESCRIPTION:
;
; 
function track_get_sample_by_pdf,target_xy,samples_xyz, R0 = R0, $
    R_max = R_max, samples_min = samples_min,max_edge = max_edge, $
    min_edge = min_edge, n_bins = n_bins, n_samples = n_samples
    
  if ~keyword_set(n_samples) then n_samples = 1
  
  samples_final = track_select_sample_by_r(target_xy, samples_xyz, R0 = R0, R_max = R_max, samples_min = $
      samples_min)
      
  hist_freq = histogram(samples_final[2,*], max = max_edge, min = min_edge,$
                        binsize = (max_edge- min_edge)/n_bins)
    
  hist_pdf  = float(hist_freq)/total(hist_freq)
  hist_pdf  = float(hist_pdf)/max(hist_pdf)
  
  rst_sample = fltarr(n_samples)
  while n_samples gt 0 do begin
  
    while 1 do begin
      rand_tmp = randomu(seed,2)
      i_bin    = floor(rand_tmp(0)*n_bins)
      if rand_tmp(1) le hist_pdf(i_bin) then begin
        rst_sample[n_samples-1] = min_edge + rand_tmp(0)*n_bins*((max_edge- min_edge)/n_bins)
        break
      endif
    endwhile
    
    n_samples = n_samples - 1
    
  endwhile
  
  return,rst_sample
end