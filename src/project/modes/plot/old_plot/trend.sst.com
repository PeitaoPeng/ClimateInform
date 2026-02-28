open /export-6/cacsrv1/wd52pp/modes/corr.sst.vs.z500_trend_coef.5001djfm.ctl
 reset
 enable print  meta.cor
*===========================
run /export-6/sgi9/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set lat -30 70
set lon 0 360
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.25 10 SST linear trend
set vpage 2 6.5 6 9  
set grads off
set gxout shaded
set clevs  0
set ccols  35 0
d -regr
set gxout contour
*set clevs   -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5 0.9
set cint 0.1
d -regr
*draw title tp_sst RPC1
*----------
print
c
*----------
reset
*----------
