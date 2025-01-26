 open /export-6/cacsrv1/wd52pp/echam/reof_cor.z500_5894jfm.ctl
 reset
 enable print  meta.eof
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set lat -90 90
set lon 0 360
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 REOF(cor) ECHAM NH Z500 jfm 58-94 
set t 1
set vpage 1 7 7 10.5
set grads off
set gxout shaded
set clevs  -0.500 0.500
set ccols  32 0 37 
d reof
set gxout contour
set clevs   -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8  
d reof
draw title REOF 1 (30.3%)
*----------
set vpage 1 7 4 7.5 
set grads off
set gxout shaded
set clevs  -0.500 0.500
set ccols  32 0 37 
set t 2
d reof
set gxout contour
set clevs   -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8  
d reof
draw title REOF 2 (11.2%)
*----------
set vpage 1 7 1 4.5 
set grads off
set gxout shaded
set clevs  -0.500 0.500
set ccols  32 0 37 
set t 3
d reof
set gxout contour
set clevs   -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8  
d reof
draw title REOF 3 (11.1%)
*----------
print
run cbarn.gs 1 0 4.3 
run /export/sgi57/wd52pp/bin/cbarn.gs
c
*----------
reset
*----------
disable print
