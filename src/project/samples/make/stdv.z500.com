 open /export-6/cacsrv1/wd52pp/b9x/corr.z500_vs_tpsst.jas.ctl
 open /export-6/cacsrv1/wd52pp/echam/corr.z500_vs_tpsst.5894jas.ctl
 open /export-6/cacsrv1/wd52pp/obs/reanl/corr.z500_vs_tpsst.5894jas.ctl
 reset
 enable print  meta.stdv
*===========================
* tropical heating
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
draw string 4.0 10.8 Z(500mb) stdv JAS 58-94 
set vpage 1 7 7 10.5
set grads off
set gxout shaded
set clevs   30 60      
set ccols   0 33 38
d stdv.3
set gxout contour
set cint 10
d stdv.3
draw title NCEP reanalysis  
*----------
set vpage 1 7 4 7.5 
set grads off
set gxout shaded
set clevs   30 60      
set ccols   0 33 38
d stdv.2(t=11)
set gxout contour
set cint 10
d stdv.2(t=11)
draw title ECHAM  
*----------
set vpage 1 7 1 4.5 
set grads off
set gxout shaded
set clevs   30 60      
set ccols   0 33 38
d stdv(t=13)
set gxout contour
set cint 10
d stdv(t=13)
draw title NCEP(b9x)   
*----------
*run cbarn.gs 1 0 4.3 
*run /export/sgi57/wd52pp/bin/cbarn.gs
print
c
*----------
reset
*----------
disable print
