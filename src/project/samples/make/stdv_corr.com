 open /export-1/sgi57/ocean/wd52pp/echam/corr.z500_vs_tpsst.jfm.ctl
 reset
 enable print  meta.cor
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
draw string 4.0 10.8 corr (z500 vs tpsst) echam 58-94jfm
set t 1
define avg=ave(corr,t=1,t=10)
define stdv=sqrt(ave((corr-avg)*(corr-avg),t=1,t=10))
set vpage 0 8 5 10  
set grads off
set gxout contour
set clevs   -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8  
d avg
draw title avg corr of 10 runs
*----------
set vpage 0 8 0 5 
set grads off
set gxout contour
set csmooth on
set cint 0.05
d stdv
draw title stdv of corr
*----------
print
c
