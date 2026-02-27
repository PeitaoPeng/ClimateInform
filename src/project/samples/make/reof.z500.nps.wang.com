open /export-6/cacsrv1/wd52pp/obs/reanl/reof_cor.z500_jfm5099.ctl
*open /export-6/cacsrv1/wd52pp/prc_amip/reof.z500_4996jfm.ctl
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
set lat 25 90
set lon 0 360
set gxout contour
set csmooth on
set clopts -1 -1 0.16
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 reof_corr OBS NH Z500 JFM 50-99
*draw string 4.0 10.8 reof prc_amip NH Z500 JFM 49-96
set t 1
set vpage 1 4 7.0 10.0
set grads off
set gxout shaded
set clevs 0
set ccols  47 0
d reof
set gxout contour
set csmooth on
set cint 10
d regr
draw title REOF 1 (27.8%) 
*----------
set vpage 4 7 7.0 10.0
set grads off
set t 2
set gxout shaded
set clevs 0
set ccols  47 0
d reof
set gxout contour
set csmooth on
set cint 10
d regr
draw title REOF 2 (12.3%)
*----------
set vpage 1 4 4.0 7.0
set grads off
set t 3
set gxout shaded
set clevs 0
set ccols  47 0
d reof
set gxout contour
set csmooth on
set cint 10
d regr
draw title REOF 3 (10.0%)
*----------
set vpage 4 7  4.0 7.0
set grads off
set t 4
set gxout shaded
set clevs 0
set ccols  47 0
d reof
set gxout contour
set csmooth on
set cint 10
d regr
draw title REOF 4 (6.4%)
*----------
set vpage 1 4 1.0 4.0
set grads off
set t 5
set gxout shaded
set clevs 0
set ccols  47 0
d reof
set gxout contour
set csmooth on
set cint 10
d regr
draw title REOF 5 (5.6%)
*----------
set vpage 4 7  1.0 4.0
set grads off
set t 6
set gxout shaded
set clevs 0
set ccols  47 0
d reof
set gxout contour
set csmooth on
set cint 10
d regr
draw title REOF 6 (4.6%)
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
draw string 4.0 10.8 reof_corr OBS NH Z500 JFM 50-99
set vpage 1 4 7.0 10.0
set grads off
set t 7
set gxout shaded
set clevs 0
set ccols  47 0
d reof
set gxout contour
set csmooth on
set cint 10
d regr
draw title REOF 7 (4.5%) 
*----------
set vpage 4 7 7.0 10.0
set grads off
set t 8
set gxout shaded
set clevs 0
set ccols  47 0
d reof
set gxout contour
set csmooth on
set cint 10
d regr
draw title REOF 8 (4.5%)
*----------
set vpage 1 4 4.0 7.0
set grads off
set t 9
set gxout shaded
set clevs 0
set ccols  47 0
d reof
set gxout contour
set csmooth on
set cint 9
d regr
draw title REOF 9 (4.4%)
*----------
set vpage 4 7  4.0 7.0
set grads off
set t 10
set gxout shaded
set clevs 0
set ccols  47 0
d reof
set gxout contour
set csmooth on
set cint 10
d regr
draw title REOF 10 (3.8%)
print
c
*----------
