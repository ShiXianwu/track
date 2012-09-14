function track_read_landmask,mask_file
  
  samples = 3600
  lines   = 1800
  land_mask_data = bytarr(samples,lines)
  
  openr,lun_land,mask_file,/get_lun
  readu,lun_land,land_mask_data
  free_lun,lun_land
  
  return,land_mask_data
  
end
;
;pro test
;  root_dir = programrootdir(/oneup)
;  mask_file              = filepath('land_mask',root_dir = root_dir, subdir=['dat'])
;  mask = track_read_landmask(mask_file)
;  stop
;end