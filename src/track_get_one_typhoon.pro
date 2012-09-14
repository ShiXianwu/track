; NAME:
;
;    track_get_one_typhoon
;
; PURPOSE:
;
;    simulate one typhoon
;
; CALLING SEQUENCE:
;
;    Result = track_get_one_typhoon(genesis_sim_point,his_points,lysis_pdf,x0,y0,$
;    grid_size,R0 = R0,R_max = R_max,samples_min = samples_min)
;
; INPUTS:
;
;    genesis_sim_point  : a 7 elements float array, the genesis pint of one typhoon,representing the genesis time,
;                         location,typhoon NO
;    his_points         : a 12*n float arrary, respectively,every column represents the genesis time, location, velocity,
;                         forward direcction,the Variation of last point's velocity and forwar direction,the flag to
;                         judge where current point is the lysis point
;    x0,y0              : the central location of the left-down grid
;    grid_size          : the width of each gird
;
; OPTIONAL INPUTS:
;
;
; KEYWORD PARAMETERS:
;    R0         : the intial radius of the searching circle. default value: 400km
;    R_max      : the maximum radius of the searching circle. default value: 600km
;    samples_min: the minimum number of samples located inside the circel with radius R0
;
; OUTPUTS:
;
;
;
; OPTIONAL OUTPUTS:
;
;
; EXAMPLE:
;
; DESCRIPTION:
;
;
function track_get_one_typhoon,genesis_sim_point,his_points,lysis_pdf,x0,y0,$
    grid_size,R0 = R0,R_max = R_max,samples_min = samples_min, sstemp_data,oftemp_data,mask
    
  if ~keyword_set(R0) then R0 = 400
  if ~keyword_set(samples_min) then samples_min = 100
  if ~keyword_set(R_max) then R_max = 700
  
  gensis_point = fltarr(17)
  gensis_point[0:6] = genesis_sim_point
  
  sub_genesis       = where(his_points[11,*] eq 0,cnt)
  his_genesis_point = his_points[*,sub_genesis]
  
  tmp = track_get_mean_and_stddev_by_location(gensis_point[5:6],his_genesis_point[5:7,*],R0 = R0,$
    R_max = R_max,samples_min = 10)
  gensis_point[7]   = tmp[0]
  gensis_point[8]   = -9999
  
  samples_xyz       = [his_genesis_point[5:6,*],his_genesis_point[9,*]]
  samples_final     = track_select_sample_by_r(gensis_point[5:6,*],samples_xyz, R0 = R0, R_max = R_max, $
    samples_min = 10)
  gensis_point[9,*] = track_get_mean_angel(samples_final[2,*])
  gensis_point[10]  = -9999
  
  gensis_point[11]  = 0
  samples_xyz       = [his_genesis_point[5:6,*],his_genesis_point[12,*]]
  tmp = track_get_mean_and_stddev_by_location(gensis_point[5:6,*],samples_xyz, R0 = 200, R_max = 700, $
    samples_min = 10)
  gensis_point[12]  = tmp[0]
  
  xs = fix(gensis_point[5]-0.5) < 360-1 > 0
  ys = fix(gensis_point[6]+ 89.5) < 180-1 > 0
  
  xo = fix(gensis_point[5]/2.5) < 144-1 > 0
  yo = fix((90 - gensis_point[6])/2.5 + 0.5) < 73-1 > 0
  z = gensis_point[2]-1 < 12-1 > 0
  
  oftemp = oftemp_data[xo,yo,z]
  sstemp = sstemp_data[xs,ys,z]
  
  gensis_point[13]    = track_derive_relative_Intensity(oftemp, sstemp, gensis_point[12])
  gensis_point[14]    = -9999
  gensis_point[15]    = track_pres_to_wind(gensis_point[12])
  gensis_point[16]    = track_derive_RMW(gensis_point[12])
  sub_track           = where(his_points[11,*] eq 5,cnt)
  track_forward_point = his_points[*,sub_track]
  
  pts_of_track     = 1
  landfall_flag    = -1
  cur_point        = gensis_point
  track_sim_points = cur_point
  genesis_time     = julday(gensis_point[2],gensis_point[3],gensis_point[1],gensis_point[4])
  lysis_test       = 0
  
  while 1 do begin
  
    next_point = track_get_next_location(cur_point)
    
    total_time = genesis_time + float(pts_of_track*6)/24.0
    CALDAT, total_time, Month, Day, Year, Hour
    next_point[1] = Year
    next_point[2] = Month
    next_point[3] = Day
    next_point[4] = Hour
    
    xs = fix(next_point[5]-0.5) < 360-1 > 0
    ys = fix(next_point[6]+ 89.5) < 180-1 > 0
    xo = fix(next_point[5]/2.5) < 144-1 > 0
    yo = fix((90 - next_point[6])/2.5 + 0.5) < 73-1 > 0
    z  = next_point[2]-1 < 12-1 > 0
    
    oftemp = oftemp_data[xo,yo,z]
    sstemp = sstemp_data[xs,ys,z]
    
    if pts_of_track eq 1 then begin
      next_point[7]   = track_get_next_fv(next_point[5:6],track_forward_point[5:8,*])
    endif else begin
      next_point[7]   = track_get_next_fv(next_point[5:6],last_xyz = track_sim_points[5:7,pts_of_track-1],$
        track_forward_point[5:8,*])
    endelse
    
    next_point[8]     = track_sim_points[7,pts_of_track-1]
    
    next_point[10]    = track_get_delt_fd([track_sim_points[5:6,pts_of_track-1],track_sim_points[9,pts_of_track-1]],$
      [track_forward_point[5:6,*],track_forward_point[9:10,*]])
      
    next_point[9]     =  track_sim_points[9,pts_of_track-1] + next_point[10]
    
    if(next_point[9] GT  180 ) then next_point[9] = next_point[9] - 360
    if(next_point[9] LT -180 ) then next_point[9] = next_point[9] + 360
    
    if next_point(7) lt 0 or FINITE(next_point[7],/NAN) or FINITE(next_point[9],/NAN) then begin
    
      track_sim_points[11,pts_of_track-1] = 9
      break
      
    endif
    
    landfall_test  = track_landfall_yes(next_point[5],next_point[6],mask)
    
    if landfall_test eq 1 then begin
    
      if landfall_flag eq -1 then begin
      
        landfall_flag = 1
        landfall_time = 0
        landfall_pres = track_sim_points[12,pts_of_track-1]
        a   = track_drive_decay_parameter(track_sim_points[6,pts_of_track-1],landfall_pres)
        
      endif
      
      next_point[12]  = track_decay_model(landfall_pres,a,landfall_time)
      next_point[13]  = track_derive_relative_Intensity(oftemp,sstemp,next_point[12])
      next_point[14]  = track_sim_points[13,pts_of_track-1]
      
      landfall_time   = landfall_time + 1
      
      lysis_test      = track_lysis_by_pres(next_point[12])
      if lysis_test eq 1 then begin
        next_point[11]   = 9
        track_sim_points = transpose([transpose(track_sim_points),transpose(next_point)])
        break
      end
      
    endif else begin
    
      if landfall_flag eq 1 then begin
      
        landfall_flag = -1
        landfall_time = -1
        landfall_pres = -1
        
      endif
      
      if pts_of_track eq 1 then begin
      
        next_point[13]   = track_get_next_fv(next_point[5:6],[track_forward_point[5:6,*],$
          track_forward_point[13:14,*]])
      endif else begin
      
        next_point[13]   = track_get_next_fv(next_point[5:6],last_xyz = [track_sim_points[5:6,pts_of_track-1],$
          track_sim_points[13,pts_of_track-1]],[track_forward_point[5:6,*],track_forward_point[13:14,*]])
      endelse
      
      
      next_point[14]  = track_sim_points[13,pts_of_track-1]
      next_point[12]  = track_derive_ocean_pres(oftemp,sstemp,next_point[13])
      
    endelse
    
    next_point[15] = track_pres_to_wind(next_point[12])
    next_point[16] = track_derive_RMW(next_point[12])
    lysis_test     = track_lysis_yes_by_location(next_point[5:6],lysis_pdf,x0,y0,grid_size)
    
    if  next_point(12) gt 1010 then begin
    
      track_sim_points[11,pts_of_track-1] = 9
      break
      
    endif
    
    if lysis_test eq 0 then begin
    
      next_point[11]   = 5
      track_sim_points = transpose([transpose(track_sim_points),transpose(next_point)])
      cur_point        = next_point
      pts_of_track     = pts_of_track + 1
      
    endif else begin
    
      next_point[11]   = 9
      track_sim_points = transpose([transpose(track_sim_points),transpose(next_point)])
      break
      
    endelse
    
  endwhile
  
  return,track_sim_points
  
end