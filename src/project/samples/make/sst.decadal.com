 open /export-1/sgi59/wd52pp/data/sst/sst.58_94jfm.ctl
 reset
 enable print  meta.sst
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set lat -30 70
set lon 0 360
*********
define vr=ave(sst*sst,t=1,t=37)
define sd=sqrt(vr)
s1=ave(sst,t=1,t=18)
s2=ave(sst,t=18,t=37)
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 SST jfm (76_94)-(58_75) 
set vpage 1 7 7 10.5
set grads off
set gxout shaded
set clevs  -0.500 0.500
set ccols  33 0 37 
d (s2-s1)/sd
set gxout contour
set cint 0.5  
d (s2-s1)/sd
draw title standardized
*----------
set vpage 1 7 4 7.5 
set grads off
set gxout shaded
set clevs  -0.200 0.200
set ccols  33 0 37 
d s2-s1
set gxout contour
set cint 0.2  
d s2-s1
draw title raw data
*----------
run cbarn.gs 1 0 4.3 
run /export/sgi57/wd52pp/bin/cbarn.gs
c
*----------
reset
*----------
