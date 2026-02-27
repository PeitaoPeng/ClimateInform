open /export-6/cacsrv1/wd52pp/modes/corr.trs_hgt500.vs.rsd_rcoef.z500.5001djfm.ctl
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
draw string 4.0 10.8 HP_trs regr to tp_sst_rpc (100 m*m)
set t 1
set vpage 1 4 7.0 10.0
set grads off
set gxout shaded
set clevs -0.27 0.27
set ccols  33 0 38
d -corr
set gxout contour
set csmooth on
set clevs -5 -4 -3 -2 -1 1 2 3 4 5 6 7
d -regr/100
draw title tp_sst RPC1
*----------
set vpage 4 7 7.0 10.0
set grads off
set t 2
set gxout shaded
set clevs -0.27 0.27
set ccols  33 0 38
d -corr
set gxout contour
set csmooth on
set clevs -5 -4 -3 -2 -1 1 2 3 4 5 6 7
d -regr/100
draw title tp_sst RPC2
*----------
print
c
*----------
reset
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
draw string 4.0 10.8 HP_trs regr to rsd_z500_rpc (100 m*m)
set t 3
set vpage 1 4 7.0 10.0
set grads off
set gxout shaded
set clevs -0.27 0.27
set ccols  33 0 38
d corr
set gxout contour
set csmooth on
set clevs -5 -4 -3 -2 -1 1 2 3 4 5 6 7
d regr/100
draw title rsd_z500_rpc 1
*----------
set vpage 4 7 7.0 10.0
set grads off
set t 4
set gxout shaded
set clevs -0.27 0.27
set ccols  33 0 38
d corr
set gxout contour
set csmooth on
set clevs -5 -4 -3 -2 -1 1 2 3 4 5 6 7
d regr/100
draw title rsd_z500_rpc 2
*----------
set vpage 1 4 4.0 7.0
set grads off
set t 5
set gxout shaded
set clevs -0.27 0.27
set ccols  33 0 38
d -corr
set gxout contour
set csmooth on
set clevs -5 -4 -3 -2 -1 1 2 3 4 5 6 7
d -regr/100
draw title rsd_z500_rpc 3
*----------
set vpage 4 7  4.0 7.0
set grads off
set t 8
set gxout shaded
set clevs -0.27 0.27
set ccols 33 0 38
d corr
set gxout contour
set csmooth on
set clevs -5 -4 -3 -2 -1 1 2 3 4 5 6 7
d regr/100
draw title rsd_z500_rpc 6
*----------
set vpage 1 4 1.0 4.0
set grads off
set t 10
set gxout shaded
set clevs -0.27 0.27
set ccols  33 0 38
d corr
set gxout contour
set csmooth on
set clevs -5 -4 -3 -2 -1 1 2 3 4 5 6 7
d regr/100
draw title rsd_z500_rpc 8
*----------
set vpage 4 7  1.0 4.0
set grads off
set t 12
set gxout shaded
set clevs -0.27 0.27
set ccols  33 0 38
d -corr
set gxout contour
set csmooth on
set clevs -5 -4 -3 -2 -1 1 2 3 4 5 6 7
d -regr/100
draw title rsd_z500_rpc 10
print
c
*----------
