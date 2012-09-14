function track_read_outflow,oft_file
  
  oftemp_data  = fltarr(144,73,12)
  
  openr,lun_oftemp,oft_file,/get_lun
  readu,lun_oftemp,oftemp_data
  free_lun,lun_oftemp
  
  return,oftemp_data
  
end