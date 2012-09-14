function track_get_next_location,cur_point


  dT         = 6
  lon0       = cur_point[5]
  lat0       = cur_point[6]
  trspeed    = cur_point[7]
  theta      = cur_point[9]
  next_point = cur_point
  k = !dpi/180.
  R = 6378.2064d0 ;Earth equatorial radius, kilometers, Clarke 1866 ellipsoid
  dis  = trspeed*dT
  dlat = dis*cos(theta*k)/R/k
  dlon = dis*sin(theta*k)/(R*cos((lat0+dlat)*k))/k
  
  lon1 = lon0+dlon
  lat1 = lat0+dlat
  
  next_point[5] = lon1
  next_point[6] = lat1
  
  return,next_point
  
end