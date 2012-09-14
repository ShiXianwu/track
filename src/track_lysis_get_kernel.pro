function track_lysis_get_kernel,samples_lysis,x0,y0,n_cols,n_rows,grid_size,R

  R_degree = float(R) * 0.015
  pdf_rst  = fltarr(n_cols,n_rows)
  
  for int_col = 0L,n_cols-1 do begin
  
    for int_row = 0L,n_rows-1 do begin
      x_grid_centroid = x0 + int_col*grid_size
      y_grid_centroid = y0 + int_row*grid_size
      sub = where((abs(samples_lysis[0,*]-x_grid_centroid) le R_degree) $
        and (abs(samples_lysis[1,*]-y_grid_centroid) le R_degree),count)
      if count gt 0 then begin
        samples_le_R_degree = samples_lysis[*,sub]
        dis = track_map_2points_modified(x_grid_centroid,y_grid_centroid,samples_le_R_degree[0,*],$
          samples_le_R_degree[1,*])*0.001
        sub_dis = where(dis le R, cnt1)
        
        if cnt1 gt 0 then begin
          samples_le_R = samples_le_R_degree[*,sub_dis]
          R_dis        = dis[sub_dis]
          sub_lysis    = where(samples_le_R[2,*] eq 9, cnt2)
          
          if cnt2 gt 0 then begin
            weight = 1.0 - R_dis/R
            pdf_rst[int_col,int_row] = total(weight(sub_lysis))/total(weight)
          endif else begin
            pdf_rst[int_col,int_row] = 0
          endelse
          
        endif else begin
        
          pdf_rst[int_col,int_row] = 1
        endelse
      endif else begin
        pdf_rst[int_col,int_row] = 1
      endelse
    endfor
    
  endfor
  
  pdf_rst = pdf_rst/max(pdf_rst)
  return,pdf_rst
  
end

pro get_lysis_pdf

  root_dir = programrootdir(/oneup)
  
  x0          = 100.25
  y0          = 0.25
  n_cols      = 160
  n_rows      = 120
  grid_size   = 0.5
  R           = 100L
  
  fn_shape_his_track  = filepath('BEST_6H_C_EXTEND_ALL_1949_2010.shp',root_dir = root_dir, subdir=['dat'])
  INFO = FILE_INFO(fn_shape_his_track)
  ;  ID_TD      = shape_read_attribute(fn_shape = fn_shape_his_track, fld_NAME ='Uniq_ID')
  ;  UTC_Yr     = shape_read_attribute(fn_shape = fn_shape_his_track, fld_NAME ='UTC_Yr')
  ;  UTC_Mon    = shape_read_attribute(fn_shape = fn_shape_his_track, fld_NAME ='UTC_Mon')
  ;  UTC_Day    = shape_read_attribute(fn_shape = fn_shape_his_track, fld_NAME ='UTC_Day')
  ;  UTC_Hr     = shape_read_attribute(fn_shape = fn_shape_his_track, fld_NAME ='UTC_Hr')
  lon        = shape_attribute_read(fn_shape_his_track, fld_NAME ='lon')
  lat        = shape_attribute_read(fn_shape_his_track, fld_NAME ='lat')
  ;  FV         = shape_read_attribute(fn_shape = fn_shape_his_track, fld_NAME ='C')
  ;  Theta      = shape_read_attribute(fn_shape = fn_shape_his_track, fld_NAME ='Theta')
  Gns_Lys    = shape_attribute_read(fn_shape_his_track, fld_NAME ='Gns_Lys')
  
  his_point  = transpose([[lon],[lat],[Gns_Lys]])
  
  lysis_pdf  = track_lysis_get_kernel(his_point,x0, y0, n_cols, n_rows,grid_size,R)
  
  fn_lysis_pdf   = filepath('lysis_pdf100',root_dir = root_dir, subdir=['mid'])
  openw,lun,fn_lysis_pdf,/get_lun
  writeu,lun,lysis_pdf
  free_lun,lun
  
  print,'end of get lysis pdf'
  
end

