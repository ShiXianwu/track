function track_write_shp_line,track_sim,fn_track_sim_shp_line

  mynewshape = obj_new('IDLffShape',fn_track_sim_shp_line,/update,ENTITY_TYPE=3)
  mynewshape->AddAttribute, 'ID' ,5,6
  
  ID_tmp = track_sim(0,*)
  ID     = ID_tmp(uniq(ID_tmp,sort(ID_tmp)))
  
  for int_id = 0,n_elements(ID)-1 do begin
    sub = where(track_sim(0,*) eq ID(int_id),cnt)
    if cnt gt 0 then begin
      line_data = track_sim(*,sub)
      lonlat    = line_data(5:6,*)
      ; Create structure for new entity.
      entNew = {IDL_SHAPE_ENTITY}
      
      ; Define the values for the new entity.
      entNew.SHAPE_TYPE = 3
      entNew.BOUNDS[0] = min(lonlat[0,*])
      entNew.BOUNDS[1] = min(lonlat[1,*])
      entNew.BOUNDS[2] = 0.00000000
      entNew.BOUNDS[3] = 0.00000000
      entNew.BOUNDS[4] = max(lonlat[0,*])
      entNew.BOUNDS[5] = max(lonlat[1,*])
      entNew.BOUNDS[6] = 0.00000000
      entNew.BOUNDS[7] = 0.00000000
      
      size_track = size(lonlat)
      if size_track[0] eq 1 then begin
        entNew.N_VERTICES = 1
      endif else begin
        entNew.N_VERTICES = size_track[2]
      endelse
      entNew.VERTICES = ptr_new(lonlat)
      ;Create structure for new attributes
      attrNew = mynewshape ->GetAttributes(/ATTRIBUTE_STRUCTURE)
      
      ;Define the values for the new attributes
      attrNew.ATTRIBUTE_0 = line_data(0,0)
      
      mynewshape->PutEntity, entNew
      ;the new entity is zero.
      entity_index=int_id
      ;Add the Colorado attributes to new shapefile.
      mynewshape -> SetAttributes, entity_index, attrNew
      
    endif
  endfor
  ; Close the shapefile
  mynewshape->Close
  ; Close the shapefile.
  OBJ_DESTROY, mynewshape
  
  return,1
  
end