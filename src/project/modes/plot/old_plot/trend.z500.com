open /export-6/cacsrv1/wd52pp/modes/corr.z500.vs.trend.ctl
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
set lon 0 360
set gxout contour
set csmooth on
set clopts -1 -1 0.16
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 Z500 linear trend
set vpage 2.8 5.8 6.0 9
set grads off
set gxout shaded
set clevs 0
set ccols  35 0 
d -regr
set gxout contour
set csmooth on
*set cint 5
d -regr
*draw title tp_sst RPC1
*----------
print
c
*----------
