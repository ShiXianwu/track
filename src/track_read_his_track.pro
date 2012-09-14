function track_read_his_track,fn_shape_his_track

  ID_TD      = shape_attribute_read(fn_shape_his_track, fld_NAME = 'Uniq_ID')
  UTC_Yr     = shape_attribute_read(fn_shape_his_track, fld_NAME = 'UTC_Yr')
  UTC_Mon    = shape_attribute_read(fn_shape_his_track, fld_NAME = 'UTC_Mon')
  UTC_Day    = shape_attribute_read(fn_shape_his_track, fld_NAME = 'UTC_Day')
  UTC_Hr     = shape_attribute_read(fn_shape_his_track, fld_NAME = 'UTC_Hr')
  lon        = shape_attribute_read(fn_shape_his_track, fld_NAME = 'lon')
  lat        = shape_attribute_read(fn_shape_his_track, fld_NAME = 'lat')
  FV         = shape_attribute_read(fn_shape_his_track, fld_NAME = 'C')
  C_d        = shape_attribute_read(fn_shape_his_track, fld_NAME = 'C_d')
  Theta      = shape_attribute_read(fn_shape_his_track, fld_NAME = 'Theta')
  Theta_d    = shape_attribute_read(fn_shape_his_track, fld_NAME = 'Theta_d')
  Gns_Lys    = shape_attribute_read(fn_shape_his_track, fld_NAME = 'Gns_Lys')
  pres       = shape_attribute_read(fn_shape_his_track, fld_NAME = 'pres')
  RI         = shape_attribute_read(fn_shape_his_track, fld_NAME = 'RI')
  delta_RI   = shape_attribute_read(fn_shape_his_track, fld_NAME = 'delta_RI')
  
  his_points = transpose([[ID_TD],[UTC_Yr],[UTC_Mon],[UTC_Day],[UTC_Hr],[lon],[lat],[FV],[C_d],[Theta],[Theta_d],[Gns_Lys],$
    [pres],[RI],[delta_RI]])
    
  pts  = n_elements(ID_TD)
  his_points[8,*]   = his_points[7,*] - his_points[8,*]
;  his_points[8,0:pts-2]  = his_points[7,1:pts-1]
  his_points[10,0:pts-2]  = his_points[10,1:pts-1]
;  his_points[14,0:pts-2]  = his_points[13,1:pts-1]
  his_points[14,*]   = his_points[13,*] - his_points[14,*]
  
  return,his_points
  
end