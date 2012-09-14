pro track_sim

  root_dir = programrootdir(/oneup)
  
  x0          = 100.25
  y0          = 0.25
  n_cols      = 160
  n_rows      = 120
  grid_size   = 0.5
  ;  R           = 400L
  
  fn_lysis_pdf           = filepath('lysis_pdf600',root_dir = root_dir, subdir='mid')
  fn_shape_his_track     = filepath('BEST_6H_C_EXTEND_ALL_1949_2010.shp',root_dir = root_dir, subdir=['dat'])
  fn_shape_genesis_sim   = filepath('genesis_sim_1000a.shp',root_dir = root_dir, subdir='dat')
  fn_track_sim_shp_line  = filepath('track_sim1000a.shp',root_dir = root_dir, subdir='rst')
  fn_track_sim_shp_point = filepath('track_sim1000a_point.shp',root_dir = root_dir, subdir='rst')
  sst_file               = filepath('seasurface_temperature',root_dir = root_dir, subdir=['dat'])
  outflow_file           = filepath('outflow_temperature_level_12',root_dir = root_dir, subdir=['dat'])
  mask_file              = filepath('land_mask',root_dir = root_dir, subdir=['dat'])
  
  his_points           = track_read_his_track(fn_shape_his_track)
  
  lysis_pdf            = track_read_lysis_pdf(fn_lysis_pdf)
  sstemp_data          = track_read_sst(sst_file)
  oftemp_data          = track_read_outflow(outflow_file)
  mask                 = track_read_landmask(mask_file)
  genesis_sim_point    = track_read_sim_genesis_point(fn_shape_genesis_sim)
  
  sz = size(genesis_sim_point)
  n_tracks  = sz(2)
  track_pts = ptrarr(n_tracks)
  num = 0
  for int_track = 0L,n_tracks-1 do begin
  
    track_sim_temp = track_get_one_typhoon(genesis_sim_point[*,int_track],his_points,lysis_pdf,x0,y0, $
      grid_size,sstemp_data,oftemp_data,mask)
    track_pts[int_track]   = ptr_new(track_sim_temp)
    
    if int_track eq 0 then begin
      track_sim = *track_pts[int_track]
    endif else begin
      sim_temp  = *track_pts[int_track]
      track_sim = transpose([transpose(track_sim),transpose(sim_temp)])
    endelse
    
  endfor
  
  flag1 = track_write_shp_line(track_sim,fn_track_sim_shp_line)
  flag2 = track_write_sim_point(fn_track_sim_shp_point,track_sim)
  
  fn_sim_tc_txt = filepath('sim_1000a.txt',root_dir = root_dir, subdir='rst')
  
  openw,lun,fn_sim_tc_txt,/get_lun
  printf,lun,track_sim,FORMAT = '(I4,1X,I4,1X,I2,1X,I2,1X,I2,1X,F9.3,1X,F9.3,1X,F9.3,1X,F9.3,1X,F9.3,1X,F9.3,1X,I1,1x,f8.2,1x,f8.6,1x,f10.8)'
  free_lun,lun
  
  print,'end of track_sim'
  
end