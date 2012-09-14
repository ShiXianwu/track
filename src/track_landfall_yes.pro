function track_landfall_yes, lon, lat, mask

  landfall_test = 0
  
  if lon gt 180 then lon = lon - 360
  x = FIX((lon+180)*10)
  y = FIX((lat+ 90)*10)
  
  if mask[x,y] gt 0 then landfall_test = 1
  
  return,landfall_test
  
end