set rgb 20 200 30 25
set rgb 21 150 105 0
set rgb 22 35 20  200
set mproj latlon
set lon 0 360
set lat -90 90
set z 1         
set gxout contour
set csmooth on
set vpage 0 8 5.6 11 
d arv1
draw title avg relative vort  300mb DJF80_89  
set vpage 0 8 0 5.4 
d eds1
draw title avg strm funct   300mb DJF80_89  
print 
set vpage off
c
set gxout vector
set vpage 0 8 5.6 11 
d wvx1;wvy1
draw title stwv flux  300mb DJF80_89  
set gxout contour
set csmooth on
set clevs  -2.e-05 -1.e-05 1.e-05
d hdivg(wvx1,wvy1)
set vpage 0 8 0 5.4 
set gxout vector
d avu1;avv1
draw title avg velocity   300mb DJF80_89  
print 
set vpage off
c
set gxout contour
set csmooth on
set vpage 0 8 5.6 11 
d arv2
draw title avg relative vort  300mb DJF81/82  
set vpage 0 8 0 5.4 
d eds2
draw title avg strm funct   300mb DJF81/82  
print 
set vpage off
c
set gxout vector
set vpage 0 8 5.6 11 
d wvx2;wvy2
draw title stwv flux  300mb DJF81/82  
set gxout contour
set csmooth on
set clevs  -2.e-05 -1.e-05 1.e-05
d hdivg(wvx2,wvy2)
set gxout vector
set vpage 0 8 0 5.4 
d avu2;avv2
draw title avg velocity   300mb DJF81/82  
print 
set vpage off
c
set gxout vector
set vpage 0 8 5.6 11 
d wvx2-wvx1;wvy2-wvy1
draw title stwv flux anom  300mb DJF81/82  
set gxout contour
set csmooth on
set clevs  -2.e-05 -1.e-05 1.e-05
d hdivg(wvx2-wvx1,wvy2-wvy1)
set gxout contour
set csmooth on
set vpage 0 8 0 5.4 
d str2-str1 
draw title strm fun anom    300mb DJF81/82  
print 
set vpage off
c
