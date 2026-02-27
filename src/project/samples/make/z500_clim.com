open /export-1/sgi59/wd52pp/data/obs/reanl/z500.58_94jfm.ctl
 reset
 enable print  meta.eof
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set mproj nps
set frame off
set lat 10 90
set lon 0 360
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 z500 (jfm 58-94) clim & stdv 
define zc=z(t=38)
define zv=ave(z*z,t=1,t=37)
define zs=sqrt(zv)
set vpage 0.7 4.2 5.5 9  
set grads off
set gxout contour
set cint 100
d zc
draw title (a) 
*----------
set vpage 3.8 7.3 5.5 9 
set grads off
set gxout contour
set cint 5
d zs
draw title (b)
print
*----------
*----------
disable print
