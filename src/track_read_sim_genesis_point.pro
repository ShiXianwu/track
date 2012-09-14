function track_read_sim_genesis_point,fn_shape_genesis_sim

  TC_ID      = shape_attribute_read(fn_shape_genesis_sim,fld_NAME = 'TC_ID')
  Year       = shape_attribute_read(fn_shape_genesis_sim,fld_NAME = 'Year')
  Month      = shape_attribute_read(fn_shape_genesis_sim,fld_NAME = 'Month')
  Day        = shape_attribute_read(fn_shape_genesis_sim,fld_NAME = 'Day')
  Hour       = shape_attribute_read(fn_shape_genesis_sim,fld_NAME = 'Hour')
  Longitude  = shape_attribute_read(fn_shape_genesis_sim,fld_NAME = 'lon')
  Latitude   = shape_attribute_read(fn_shape_genesis_sim,fld_NAME = 'lat')
  
  genesis_sim = transpose([[TC_ID],[Year],[Month], [Day],[Hour],[Longitude], [Latitude]])
  
  return,genesis_sim
  
end