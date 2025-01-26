open /export-6/cacsrv1/wd52pp/obs/reanl/reof.z500_5098jfm.ctl
 reset
 enable print  meta.eof
*===========================
run /export-6/sgi9/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
reset
*----------
set mproj nps
set frame off
set lat 20 90
set lon -270 90
set gxout contour
set csmooth on
set clopts -1 -1 0.16
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 reof OBS NH Z500 JFM 50-98
set t 1
set vpage 1 4.25 6.0 10.0
set grads off
set gxout shaded
set clevs  -60 -40 -20 0 20
set ccols  48 46 44 42 63 66
d regr
set gxout contour
set csmooth on
set cint 20
*d regr
draw title REOF 1 (22.7%) 
*----------
set vpage 4.25 7.5 6.0 10.0
set grads off
set t 2
set gxout shaded
set clevs  -60 -40 -20 0 20
set ccols  48 46 44 42 63 66
d regr
set gxout contour
set csmooth on
set cint 20
*d regr
draw title REOF 2 (18.4%)
*----------
set vpage 1 7.5 5.8 6.5
Set grads off
set t 2
set gxout shaded
set clevs  -60 -40 -20 0 20
set ccols  48 46 44 42 63 66
d regr
run /export-6/sgi9/wd52pp/bin/cbarn.gs
d regr
print
*c
*----------
*reset
*----------
