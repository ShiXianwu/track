function track_get_mean_angel,angel_arr
  
  k = !dpi/180.
  x_arr = cos(angel_arr*k)
  y_arr = sin(angel_arr*k)
  x = total(x_arr)
  y = total(y_arr)

  case 1 of
    y eq 0 and x ge 0: mean_angel = 0
    y eq 0 and x lt 0: mean_angel = 180
    x gt 0           : mean_angel = atan(y/x)/k
    x lt 0 and y gt 0: mean_angel = atan(y/x)/k+180
    x lt 0 and y lt 0: mean_angel = atan(y/x)/k-180
    else:mean_angel = !VALUES.F_NAN
  endcase
  
  return,mean_angel
end