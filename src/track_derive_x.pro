function func,x,a,b
    return,exp(-a*(1./x-b))-x
end

function track_fx_root, xi,p1,p2, func, double = double, itmax = itmax, $
                                stop = stop, tol = tol

  on_error, 2 ;Return to caller if error occurs.

  x = xi + 0.0 ;Create an internal floating-point variable, x.
  sx = size(x)
  if sx[1] ne 3 then $
    message, 'x must be a 3-element initial guess vector.'

  ;Initialize keyword parameters.
  if keyword_set(double) ne 0 then begin
    if sx[2] eq 4 or sx[2] eq 5 then x = x + 0.0d $
    else x = dcomplex(x)
  endif
  if keyword_set(itmax)  eq 0 then itmax = 100
  if keyword_set(stop)   eq 0 then stop = 0
  if keyword_set(tol)    eq 0 then tol = 1.0e-4

  ;Initialize stopping criterion and iteration count.
  cond = 0  &  it = 0

  ;Begin to iteratively compute a root of the nonlinear function.
  while (it lt itmax and cond ne 1) do begin
    q = (x[2] - x[1])/(x[1] - x[0])
    pls = (1 + q)
    f = call_function(func, x ,p1,p2)
    a = q*f[2] - q*pls*f[1] + q^2*f[0]
    b = (2*q+1)*f[2] - pls^2*f[1] + q^2*f[0]
    c = pls*f[2]
    disc = b^2 - 4*a*c
    roc = size(disc)  ;Real or complex discriminant?
    if roc[1] ne 6 and roc[1] ne 9 then begin ;Proceed toward real root.
        if disc lt 0 then begin ;Switch to complex root.
                                ;Single-precision complex.
            if keyword_set(double) eq 0 and sx[2] ne 9 then begin
                r0 = b + complex(0, sqrt(abs(disc)))
                r1 = b - complex(0, sqrt(abs(disc)))
            endif else begin    ;Double-precision complex.
                r0 = b + dcomplex(0, sqrt(abs(disc)))
                r1 = b - dcomplex(0, sqrt(abs(disc)))
            endelse
            if abs(r0) gt abs(r1) then div = r0 $ ;Maximum modulus.
            else div = r1
        endif else begin        ; real root
            rR0 = b + sqrt(disc)
            rR1 = b - sqrt(disc)
            div = abs(rR0) ge abs(rR1) ? rR0 : rR1
        endelse
    endif else begin            ;Proceed toward complex root.
        c0 = b + sqrt(disc)
        c1 = b - sqrt(disc)
        if abs(c0) gt abs(c1) then div = c0 $ ;Maximum modulus.
        else div = c1
    endelse
    root = x[2] - (x[2] - x[1]) * (2 * c/div)
                                ;Absolute error tolerance.
    if stop eq 0 and abs(root - x[2]) le tol then begin
        cond = 1
    endif else begin
            evalFunc = call_function( func, root ,p1,p2)
                                ;Functional error tolerance.
            if stop ne 0 and abs( evalFunc ) le tol then cond = 1 $
                                ;If func(root) eq 0, we must quit or
                                ;divide by zero next iteration.
            else if evalFunc eq 0 then cond = 1
        endelse
        x = [x[1], x[2], root]
        it = it + 1
    endwhile
    if it ge itmax and cond eq 0 then $
      message, 'Algorithm failed to converge within given parameters.'
    return, root
end
function track_derive_x,a,b

    x = [0.1,0.5,1.9]
    ;solve the nonlinear equations : x=exp(-a*(1./x-b))
    ;The FX_ROOT function computes a real or complex root of a univariate nonlinear function using an optimal Miller's method. 
    ;Here modifyed by Yang Jianshun on Jan,13rd,2010
    y = track_fx_root(x,a,b,'func')
    
    return,y
    
end