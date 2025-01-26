open /disk50/data/wd52pp/ncep/amip_tst/reof.z500_4950-9798djf.arun.ctl
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
draw string 4.0 10.8 GCM test NH Z500 DJF 49/90-91/98
*draw string 4.0 10.8 reof CCM3 NH Z500 ESM JFM 50-94
set t 1
set vpage 1 4 7.0 10.0
set grads off
set gxout shaded
set clevs  -0.28 0.28
set ccols  33 0 37
d reof
set gxout contour
set csmooth on
set cint 10
d rregr
draw title REOF 1 (13.2%) 
*----------
set vpage 4 7 7.0 10.0
set grads off
set t 2
set gxout shaded
set clevs  -0.28 0.28
set ccols  33 0 37
d reof
set gxout contour
set csmooth on
set cint 10
d rregr
draw title REOF 2 (12.7%)
*----------
set vpage 1 4 4.0 7.0
set grads off
set t 3
set gxout shaded
set clevs  -0.28 0.28
set ccols  33 0 37
d reof
set gxout contour
set csmooth on
set cint 10
d rregr
draw title REOF 3 (9.6%)
*----------
set vpage 4 7  4.0 7.0
set grads off
set t 4
set gxout shaded
set clevs  -0.28 0.28
set ccols  33 0 37
d reof
set gxout contour
set csmooth on
set cint 10
d rregr
draw title REOF 4 (7.3%)
*----------
set vpage 1 4 1.0 4.0
set grads off
set t 5
set gxout shaded
set clevs  -0.28 0.28
set ccols  33 0 37
d reof
set gxout contour
set csmooth on
set cint 10
d rregr
draw title REOF 5 (7.1%)
*----------
set vpage 4 7  1.0 4.0
set grads off
set t 6
set gxout shaded
set clevs  -0.28 0.28
set ccols  33 0 37
d reof
set gxout contour
set csmooth on
set cint 10
d rregr
draw title REOF 6 (6.8%)
print
c
*----------
reset
*----------
set mproj nps
set frame off
set lat 25 90
set lon 0 360
set gxout contour
set csmooth on
set clopts -1 -1 0.16
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 reof OBS NH Z500 JFM 50-94
*draw string 4.0 10.8 reof CCM3 NH Z500 ESM JFM 50-94
set vpage 1 4 7.0 10.0
set grads off
set t 7
set gxout shaded
set clevs  -0.28 0.28
set ccols  33 0 37
d reof
set gxout contour
set csmooth on
set cint 10
d rregr
draw title REOF 7 (5.6%) 
*----------
set vpage 4 7 7.0 10.0
set grads off
set t 8
set gxout shaded
set clevs  -0.28 0.28
set ccols  33 0 37
d reof
set gxout contour
set csmooth on
set cint 10
d rregr
draw title REOF 8 (5.2%)
*----------
set vpage 1 4 4.0 7.0
set grads off
set t 9
set gxout shaded
set clevs  -0.28 0.28
set ccols  33 0 37
d reof
set gxout contour
set csmooth on
set cint 9
d rregr
draw title REOF 9 (4.8%)
*----------
set vpage 4 7  4.0 7.0
set grads off
set t 10
set gxout shaded
set clevs  -0.28 0.28
set ccols  33 0 37
d reof
set gxout contour
set csmooth on
set cint 10
d rregr
draw title REOF 10 (2.6%)
*print
c
*----------
