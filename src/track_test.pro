pro track_test

  root_dir = programrootdir(/oneup)
  fn_shape_his_track   = filepath('BEST_6H_C_ALL_1949_2009_I_cn.shp',root_dir = root_dir, subdir=['dat'])
  
  ID_TD      = shape_attribute_read(fn_shape_his_track, 'Uniq_ID')
  UTC_Yr     = shape_attribute_read(fn_shape_his_track, 'UTC_Yr')
  UTC_Mon    = shape_attribute_read(fn_shape_his_track, 'UTC_Mon')
  UTC_Day    = shape_attribute_read(fn_shape_his_track, 'UTC_Day')
  UTC_Hr     = shape_attribute_read(fn_shape_his_track, 'UTC_Hr')
  lon        = shape_attribute_read(fn_shape_his_track, 'lon')
  lat        = shape_attribute_read(fn_shape_his_track, 'lat')
  FV         = shape_attribute_read(fn_shape_his_track, 'C')
  C_d        = shape_attribute_read(fn_shape_his_track, 'C_d')
  Theta      = shape_attribute_read(fn_shape_his_track, 'Theta')
  Theta_d    = shape_attribute_read(fn_shape_his_track, 'Theta_d')
  Gns_Lys    = shape_attribute_read(fn_shape_his_track, 'Gns_Lys')
  
  his_point = transpose([[ID_TD],[UTC_Yr],[UTC_Mon],[UTC_Day],[UTC_Hr],[lon],[lat],[FV],[C_d],[Theta],[Theta_d],[Gns_Lys]])
  his_point[8,*]  = his_point[7,*]- his_point[8,*]
  pts  = n_elements(ID_TD)
  his_point[10,0:pts-2]  = his_point[10,1:pts-1]
  sub = where(his_point[11,*] eq 5,cnt)
  his_points = his_point[*,sub]
;  hist = hist_2D(his_points[10,*], his_points[9,*], BIN1=10, BIN2=45 ,MIN1 = -40 ,MIN2=-180 ,MAX1 = 40, MAX2 = 180)
;  stop
  R = 400l
  cur_xy = [135.0,30.0]
  ;  next_fv = track_get_next_fv(cur_xy, his_point[5:8,*])
  hist = track_get_delt_fd([140,25.0,20],[his_points[5:6,*],his_points[9:10,*]])
  stop
  pacific_mean    = fltarr(160,120)
  pacific_std     = fltarr(160,120)
  for int_row = 0,119 do begin
    for int_col = 0,159 do begin
      x_loc = 100.25 + int_col*0.5
      y_loc = 0.25 + int_row*0.5
      mean_and_std =  track_get_mean_and_stddev_by_location([x_loc,y_loc],his_point[5:7,*])
      pacific_mean[int_col,int_row] = mean_and_std[0]
      pacific_std[int_col,int_row]  = mean_and_std[1]
    endfor
  endfor
  
  fn_pacific_mean   = filepath('out700',root_dir = root_dir, subdir=['tmp'])
  fn_pacific_std   = filepath('out700',root_dir = root_dir, subdir=['tmp'])
  openw,lun,fn_pacific_mean,/get_lun
  writeu,lun,reverse(pacific_mean,2)
  free_lun,lun
  openw,lun,fn_pacific_std,/get_lun
  writeu,lun,reverse(pacific_std,2)
  free_lun,lun
  print,'end of test'
end