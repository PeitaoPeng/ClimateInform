open /export/sgi57/wd52pp/data/eof/gfdl/reof.z500_pna_intsmp_noenso_jfm.ctl
*open /export-1/sgi59/wd52pp/data/gfdl/reof.z500_intsmp_noenso_jfm.ctl
 reset
 enable print  meta.eof
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
reset
*----------
set mproj nps
set frame off
set lat 20 70
set lon 150 300
set gxout contour
set csmooth on
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 reof gfdl PNA int_smp Z500 noenso jfm 
set t 1
set vpage 0 4 7.0 10.0
set grads off
set cint 5
d regr
set clevs 0
set cthick 8
d regr
draw title REOF 1 (35.7%) 
*----------
set vpage 4 8 7.0 10.0
set grads off
set t 2
set cint 5
d regr
set clevs 0
set cthick 8
d regr
draw title REOF 2 (14.5%)
*----------
set vpage 0 4 4.0 7.0
set grads off
set t 3
set cint 5
d regr
set clevs 0
set cthick 8
d regr
draw title REOF 3 (9.7%)
*----------
set vpage 4 8  4.0 7.0
set grads off
set t 4
set cint 5
d regr
set clevs 0
set cthick 8
d regr
draw title REOF 4 (9.3%)
*----------
set vpage 0 4 1.0 4.0
set grads off
set t 5
set cint 5
d regr
set clevs 0
set cthick 8
d regr
draw title REOF 5 (8.2%)
*----------
set vpage 4 8  1.0 4.0
set grads off
set t 6
set cint 5
d regr
set clevs 0
set cthick 8
d regr
draw title REOF 6 (6.2%)
print
c
*----------
reset
