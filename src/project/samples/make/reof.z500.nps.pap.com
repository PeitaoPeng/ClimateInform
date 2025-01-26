open /export-6/cacsrv1/wd52pp/obs/reanl/reof.z500_5094jfm.ctl
 reset
 enable print  meta.eof
*===========================
*run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
reset
*----------
set mproj nps
set frame off
set lat 20 90
set lon 0 360
set gxout contour
set csmooth on
set clopts -1 -1 0.16
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.25 10.8 reof OBS NH Z500 JFM 50-94
set t 1
set vpage 0.75 4.25 6.5 10
set grads off
set cint 10
d regr
set clevs 0
set cthick 8
d regr
draw title REOF 1 (22.7%) 
*----------
set vpage 4.25 7.75 6.5 10
set grads off
set t 2
set cint 10
d regr
set clevs 0
set cthick 8
d regr
draw title REOF 2 (18.4%)
*----------
set vpage 0.75 4.25 3 6.5
set grads off
set t 3
set cint 10
d regr
set clevs 0
set cthick 8
d regr
draw title REOF 3 (7.5%)
*----------
set vpage 4.25 7.75  3 6.5
set grads off
set t 4
set cint 10
d regr
set clevs 0
set cthick 8
d regr
draw title REOF 4 (7.3%)
*----------
print
c
*----------
reset
