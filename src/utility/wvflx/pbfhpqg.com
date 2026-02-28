*set mproj nps
*set mpvals 0 360 0 90
set mproj latlon
set rgb 20 200 30 25
set rgb 21 150 105 0
set rgb 22 35 20  200
set lon 0 360    
set lat 20 90
set z 5         
set gxout contour
set csmooth on
set vpage 0 8 7.4 11 
*d hcurl(avu,avv)
*d mag(uggq,vggq)
d arv
draw title avg relative vort  200mb DJF8788
set vpage 0 8 3.7 7.3 
d vt3
*d hcurl(avu,avv)
draw title baroclinic part of avg q  200mb DJF8788
set vpage 0 8 0 3.6
d ptv
draw title avg q  200mb DJF8788
print 
set vpage off
c
set vpage 0 8 7.4 11 
d ens
draw title avg eddy enstrophy  200mb DJF8788
set z 5         
set gxout shaded
set vpage 0 8 3.7 7.3 
set clevs -8e-05 -4e-05  
set ccols 21 20 0
d dmr
set gxout contour
set csmooth on
set clevs -8e-05 -4e-05 0
d dmr
draw title div(MR)/pcos(lat) (hp)  300mb DJF8788
set gxout shaded
set vpage 0 8 0 3.6
set clevs -8e-05 -4e-05  
set ccols 21 20 0
d cmr
set gxout contour
set csmooth on
set clevs -8e-05 -4e-05 0
d cmr
draw title avg(v'q')*n (hp)  300mb DJF8788
print
set vpage off
c
set gxout shaded
set vpage 0 8 7.4 11 
set clevs -0.0001 0.0001
set ccols  20 0 21
*d (avu*esx+avv*esy)/mag(pvx,pvy)
d ugq
set gxout contour
set csmooth on
*set clevs -0.0001 0.0  0.0001 
*d (avu*esx+avv*esy)/mag(pvx,pvy)
d ugq
*draw title eV*gr(mod(gr(q)))/(gr(q))**2 300mb DJF8788
draw title lhs-rhs of eq(3.6)                        
set gxout shaded
set vpage 0 8 3.7 7.3 
set clevs -0.0001 0.0001
set ccols  20 0 21
d dmt
set gxout contour
set csmooth on
set clevs  -0.0001 0.0  0.0001
d dmt
draw title div(MT)/pcos(lat) (hp)  300mb DJF8788
set gxout shaded
set vpage 0 8 0 3.6
set clevs  -0.0001  0.0001
set ccols  20 0 21
d cmt
set gxout contour
set csmooth on
set clevs  -0.0001 0.0 0.0001
d cmt
draw title V*grad(e)/mag(grad(q))+avg(v'q')*n 300mb
print
set vpage off
c
set z 5
set gxout vector
set vpage 0 8 7.4 11 
d avu;avv
draw title avg vel  300mb NDJ8788
set vpage 0 8 3.7 7.3 
d evx;evy
set gxout contour
set csmooth on
set clevs -6e-05 -3e-05  3e-05 6e-05
d hdivg(evx,evy)
draw title E VECTOR (hp)  300mb NDJ8788
set gxout vector
set vpage 0 8 0 3.6
set arrscl 0.6 30
d mrx;mry
set gxout contour
set csmooth on
set clevs -6e-06 -3e-06  3e-06 6e-06
d hdivg(mrx,mry)
draw title MR (hp)  300mb NDJ8788
print
set vpage off
c
set gxout vector
set vpage 0 8 7.4 11
*set arrscl 0.6 100
d mtx;mty
set gxout contour
set csmooth on
set clevs  -2e-05  2e-05
d hdivg(mtx,mty)
draw title MT (hp)  200mb NDJ8788
print
set vpage off
c
