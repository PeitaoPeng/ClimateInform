open /export-6/cacsrv1/wd52pp/modes/rsd_reof.z500.5001djfm.ntd.ctl
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
draw string 4.0 10.8 Z500 regr to tp_sst_rpc (1950-2001 DJFM)
set t 1
set vpage 1 4 7.0 10.0
set grads off
set gxout shaded
set clevs -0.27 0.27
set ccols  33 0 38
d -corr
set gxout contour
set csmooth on
set cint 5
d -regr
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
set cint 5
d -regr
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
draw string 4.0 10.8 ROEFs of NH Z500_rsd (1950-2001 DJFM)
set t 3
set vpage 1 4 7.0 10.0
set grads off
set gxout shaded
set clevs -0.27 0.27
set ccols  33 0 38
d corr
set gxout contour
set csmooth on
set cint 5
d regr
draw title reof 1
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
set cint 5
d regr
draw title reof 2
*----------
set vpage 1 4 4.0 7.0
set grads off
set t 5
set gxout shaded
set clevs -0.27 0.27
set ccols  33 0 38
d corr
set gxout contour
set csmooth on
set cint 5
d regr
draw title reof 3
*----------
set vpage 4 7  4.0 7.0
set grads off
set t 6
set gxout shaded
set clevs -0.27 0.27
set ccols 33 0 38
d corr
set gxout contour
set csmooth on
set cint 5
d regr
draw title reof 4
*----------
set vpage 1 4 1.0 4.0
set grads off
set t 7
set gxout shaded
set clevs -0.27 0.27
set ccols  33 0 38
d corr
set gxout contour
set csmooth on
set cint 5
d regr
draw title reof 5
*----------
set vpage 4 7  1.0 4.0
set grads off
set t 8
set gxout shaded
set clevs -0.27 0.27
set ccols  33 0 38
d corr
set gxout contour
set csmooth on
set cint 5
d regr
draw title reof 6
print
*c
*----------
