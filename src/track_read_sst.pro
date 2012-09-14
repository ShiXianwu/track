function track_read_sst,sst_file

  sstemp_data = fltarr(360,180,12)
  
  openr,lun_sstemp,sst_file,/get_lun
  readu,lun_sstemp,sstemp_data
  free_lun,lun_sstemp
  
  return,sstemp_data
  
end