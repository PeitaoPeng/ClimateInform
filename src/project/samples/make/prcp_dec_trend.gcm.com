set display color white
open /export-6/cacsrv1/wd52pp/obs/reanl/prcp_5094.trend_tony.ctl
open /export-6/cacsrv1/wd52pp/obs/reanl/prcp_5094.trend_pivot.ctl
*open /export-6/cacsrv1/wd52pp/echam/prcp_5094.trend_tony.ctl
*open /export-6/cacsrv1/wd52pp/echam/prcp_5094.trend_pivot.ctl
 reset
 enable print  meta.z
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set t 1 12
* x30-b9x; x30*86400000-echam
define zz1=z
define zz2=z.2
modify zz1 seasonal
modify zz2 seasonal
set t 1
define z1=ave(zz1,t=1,t=3)
define z2=ave(zz2,t=1,t=3)
*********
set string 1 tc 8
set strsiz 0.15 0.15
draw string 4.0 10.5 OBS jfm prcp decadal tendency ((mm/mon)/10yr)
draw string 4.0 9.65 (1984-94) - (1950-66)
draw string 4.0 4.65 piecewise linear trend fit (pivot year 1966) 
*********
set vpage 0.5 7.5 5 10
set grads off
set gxout shaded
*set clevs -50 -40 -30 -20 -10 0 10 20 30 40 50
set clevs -25 -20 -15 -10 -5 0 5 10 15 20 25
set ccols 49 47 45 43 41 31 71 21 23 25 27 29 
d z1
run /export/sgi57/wd52pp/bin/cbarn.gs
*********
set vpage 0.5 7.5 0 5
set grads off
set gxout shaded
*set clevs -50 -40 -30 -20 -10 0 10 20 30 40 50
set clevs -25 -20 -15 -10 -5 0 5 10 15 20 25
set ccols 49 47 45 43 41 31 71 21 23 25 27 29 
d z2
run /export/sgi57/wd52pp/bin/cbarn.gs
print
c
*===========================
reset
set mproj nps
set frame off
set mpdset mres
set lat 15 75
set lon 180 310
*********
set string 1 tc 8
set strsiz 0.15 0.15
draw string 4.0 10.5 OBS jfm prcp decadal tendency ((mm/mon)/10yr)
draw string 4.0 9.65 (1984-94) - (1950-66)
draw string 4.0 4.65 piecewise linear trend fit (pivot year 1966) 
*********
set vpage 0.5 7.5 5 10
set grads off
set gxout shaded
*set clevs -50 -40 -30 -20 -10 0 10 20 30 40 50
set clevs -25 -20 -15 -10 -5 0 5 10 15 20 25
set ccols 49 47 45 43 41 31 71 21 23 25 27 29 
d z1
run /export/sgi57/wd52pp/bin/cbarn.gs
*********
set vpage 0.5 7.5  0 5
set grads off
set gxout shaded
*set clevs -50 -40 -30 -20 -10 0 10 20 30 40 50
set clevs -25 -20 -15 -10 -5 0 5 10 15 20 25
set ccols 49 47 45 43 41 31 71 21 23 25 27 29 
d z2
run /export/sgi57/wd52pp/bin/cbarn.gs
print
c
*===========================
