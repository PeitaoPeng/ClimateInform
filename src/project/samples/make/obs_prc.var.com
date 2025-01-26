open /export-6/cacsrv1/wd52pp/prc_amip/obs_prc.var.ctl
 reset
 enable print  meta.var
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
reset
*----------
set mproj nps
set frame off
set lat 25 90
set lon 0 360
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.25 10.8  Z500 JFM `3s`0  
set vpage 2.5 6.0 6.0 9.5
set grads off
set gxout shaded
set clevs 50
set ccols  0 35 
d obs
set gxout contour
set csmooth on
set cint 5
set clopts -1 -1 0.16
d obs
draw title obs (50-96)
set vpage 2.5 6.0 2.5 6.0 
set grads off
set gxout shaded
set clevs 50
set ccols  0 35 
d prc
set gxout contour
set csmooth on
set cint 5
set clopts -1 -1 0.16
d prc
draw title prc (49-96)
print
c
reset
*----------
c
