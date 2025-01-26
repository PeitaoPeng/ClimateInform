*reinit
set display color white
open tpsst_regr.ctl
reset
enable print  meta.regr
run /export/sun10/wd01ak/grd/rgbset.gs
*=============================
set mproj nps
set frame off
set lat 20 70
set lon 150 300
set gxout contour
set csmooth on
set clopts -1 -1 0.16
set string 1 tc 8
************
set strsiz 0.2 0.2
draw string 4.25 10 Regression: tpSST vs Z500 50-94JFM
set vpage 2.125 6.375 3.5 6.5
set grads off
set gxout shaded
set clevs -50 -40 -30 -20 -10 10 20 30 
set ccols  49 48 47 45 43 31 23 25 27 
d z
set gxout contour
set csmooth on
set cint 10
d z
draw title OBS
*----------
set vpage 0.0 4.25 5.5 8.5
set t 2
set grads off
set gxout shaded
set clevs -50 -40 -30 -20 -10 10 20 30 
set ccols  49 48 47 45 43 31 23 25 27 
d z
set gxout contour
set csmooth on
set cint 10
d z
draw title NCEP(AC=0.85,rms=8)
*----------
set vpage 4.25 8.5 5.5 8.5
set t 3
set grads off
set gxout shaded
set clevs -50 -40 -30 -20 -10 10 20 30 
set ccols  49 48 47 45 43 31 23 25 27 
d z
set gxout contour
set csmooth on
set cint 10
d z
draw title ECHAM(AC=0.89,rms=12)
*----------
set vpage 0.0 4.25 1.5 4.5
set t 4
set grads off
set gxout shaded
set clevs -50 -40 -30 -20 -10 10 20 30 
set ccols  49 48 47 45 43 31 23 25 27 
d z
set gxout contour
set csmooth on
set cint 10
d z
draw title CCM3(AC=0.95;rms=5)
*----------
set vpage 4.25 8.5 1.5 4.5
set t 5
set grads off
set gxout shaded
set clevs -50 -40 -30 -20 -10 10 20 30 
set ccols  49 48 47 45 43 31 23 25 27 
d z
set gxout contour
set csmooth on
set cint 10
d z
draw title GFDL(AC=0.81;rms=9)
print
define s1=sqrt(aave(z(t=1)*z(t=1),lon=150,lon=300,lat=20,lat=70))
define s2=sqrt(aave(z(t=5)*z(t=5),lon=150,lon=300,lat=20,lat=70))
define xy=aave(z(t=1)*z(t=5),lon=150,lon=300,lat=20,lat=70)
d xy/(s1*s2)
define rms2=sqrt(aave((z(t=2)-z(t=1))*(z(t=2)-z(t=1)),lon=150,lon=300,lat=20,lat=70))
define rms3=sqrt(aave((z(t=3)-z(t=1))*(z(t=3)-z(t=1)),lon=150,lon=300,lat=20,lat=70))
define rms4=sqrt(aave((z(t=4)-z(t=1))*(z(t=4)-z(t=1)),lon=150,lon=300,lat=20,lat=70))
define rms5=sqrt(aave((z(t=5)-z(t=1))*(z(t=5)-z(t=1)),lon=150,lon=300,lat=20,lat=70))
d rms2
d rms3
d rms4
d rms5
c
*----------
