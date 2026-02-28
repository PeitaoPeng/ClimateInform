 open /export-1/sgi59/wd52pp/data/obs/reanl/corr.rcoef_cor_vs_sst.jfm.ctl
 reset
 enable print  meta.cor
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set lat -30 60
set lon 0 360
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 CORR: RPC(obs NHZ500) vs SST jfm 58-94 
set t 1
set vpage 1 7 7 10  
set grads off
set gxout shaded
set clevs -0.7 -0.5 -0.3 0.3 0.5 0.7  
set ccols 39 36 33 0 45 47 49
d cor
set gxout contour
set clevs -0.7 -0.5 -0.3 -0.1 0.1 0.3 0.5 0.7  
d cor
draw title RPC 1 
*----------
set vpage 1 7 4.5 7.5 
set grads off
set gxout shaded
set clevs -0.7 -0.5 -0.3 0.3 0.5 0.7  
set ccols 39 36 33 0 45 47 49
set t 2
d cor
set gxout contour
set clevs -0.7 -0.5 -0.3 -0.1 0.1 0.3 0.5 0.7  
d cor
draw title RPC 2 
*----------
set vpage 1 7 2 5 
set grads off
set gxout shaded
set clevs -0.7 -0.5 -0.3 0.3 0.5 0.7  
set ccols 39 36 33 0 45 47 49
set t 3
d cor
set gxout contour
set clevs -0.7 -0.5 -0.3 -0.1 0.1 0.3 0.5 0.7  
d cor
draw title RPC 3 
*----------
run /export/sgi57/wd52pp/bin/cbarn.gs
print
c
*----------
reset
*----------
disable print
