function track_read_lysis_pdf,fn_lysis_pdf

  lysis_pdf   = fltarr(160,120)
  openr,lun,fn_lysis_pdf,/get_lun
  readu,lun,lysis_pdf
  free_lun,lun
  
  return,lysis_pdf
  
end