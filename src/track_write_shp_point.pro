function track_write_shp_point, track_sim,fn_track_sim_shp_point
  
  mynewshape = obj_new('IDLffShape',fn_track_sim_shp_point,/update,ENTITY_TYPE = 1)
  mynewshape->AddAttribute,'ID',5,6
  sz = size(track_sim,/dimensions)
  n_points = sz(1)
  for int_pt = 0L,long(n_points-1) do begin
    point_data = track_sim(*,int_pt)
    lonlat     = point_data[5:6]
    
    ; Create structure for new entity.
    entNew = {IDL_SHAPE_ENTITY}
    
    ; Define the values for the new entity
    entNew.SHAPE_TYPE = 1
    entNew.BOUNDS[0] = (lonlat[0])
    entNew.BOUNDS[1] = (lonlat[1])
    entNew.BOUNDS[2] = 0.00000000
    entNew.BOUNDS[3] = 0.00000000
    entNew.BOUNDS[4] = (lonlat[0])
    entNew.BOUNDS[5] = (lonlat[1])
    entNew.BOUNDS[6] = 0.00000000
    entNew.BOUNDS[7] = 0.00000000
    entNew.N_VERTICES = 1
    
    attrNew = mynewshape ->GetAttributes(/ATTRIBUTE_STRUCTURE)
    
    ;Define the values for the new attributes
    attrNew.ATTRIBUTE_0 = point_data(0)
    
    mynewshape->PutEntity, entNew
    ;the new entity is zero.
    entity_index=int_pt
    ;Add the Colorado attributes to new shapefile.
    mynewshape -> SetAttributes, entity_index, attrNew
  endfor
  ; Close the shapefile
  mynewshape->Close
  ; Close the shapefile.
  OBJ_DESTROY, mynewshape
  return,1
  print,'end of track_write_shp_point'
  
end