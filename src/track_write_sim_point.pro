function track_write_sim_point,fn_shape_track_sim,track_sim
  
  longitude     = track_sim [5,*]
  latitude      = track_sim [6,*]
  pts_VALUES    = [track_sim [0:4,*],track_sim[7:16,*]]
  fld_NAME      = ['Uniq_ID', 'UTC_Yr', 'UTC_Mon', 'UTC_Day', 'UTC_Hr','C','C_d','Theta','Theta_d','Gns_Lys',$
                     'Pres','RI','delta_RI','MWS','RMS']
  fld_TYPE      = [3, 3, 3, 3, 3, 5, 5, 5, 5, 3, 5, 5, 5, 5, 5]
  fld_WIDTH     = [8, 4, 2, 2, 2, 8, 8, 8, 8, 2, 8, 8, 10,8, 8]
  fld_PRECISION = [0, 0, 0, 0, 0, 3, 3, 3, 3, 0, 2, 6, 8, 4, 4]
  
  tag  =  shape_create_points( fn_shape_track_sim, longitude, latitude, $
    fld_NAME = fld_NAME, fld_TYPE = fld_TYPE, fld_WIDTH = fld_WIDTH, $
    fld_PRECISION = fld_PRECISION, pts_VALUES = pts_VALUES)
    
  return,1
end