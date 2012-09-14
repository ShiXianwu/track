function track_lysis_yes_by_location,cur_lonlat,lysis_pdf_data,x0,y0,grid_size

  lon = cur_lonlat[0]
  lat = cur_lonlat[1]
 
  if(lon gt 180 or lon lt 100 or lat gt 60 or lat lt 0) then begin
    Lysis_rst = 1
  endif else begin
  
    if (lon-x0) le 0 then begin
      cols = 0
    endif else begin
      cols = round((lon-x0)/grid_size)
    endelse
    
    if (lat-y0) le 0 then begin
      rows = 0
    endif else begin
      rows = round((lat-y0)/grid_size)
    endelse
    
    pdf  = lysis_pdf_data(cols,rows)
    rndp = randomu(seed,1)
    
    if (rndp gt pdf) then begin
      lysis_rst = 0
    endif else begin
      lysis_rst = 1
    endelse
    
  endelse
  
  return,lysis_rst
end