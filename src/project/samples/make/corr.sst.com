open /export-1/sgi59/wd52pp/data/echam/corr.esm_rcoef_cor_vs_sst.jfm.ctl
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
draw string 4.0 10.8 CORR: RPC(echam NHZ500) vs SST jfm 58-94 
set t 1
set vpage 1 7 7 10  
set grads off
set gxout shaded
set clevs  -0.500 0.500
set ccols  33 0 37 
d cor
set gxout contour
set clevs   -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8  
d cor
draw title RPC 1 
*----------
set vpage 1 7 4.5 7.5 
set grads off
set gxout shaded
set clevs  -0.500 0.500
set ccols  33 0 37 
set t 2
d cor
set gxout contour
set clevs   -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8  
d cor
draw title RPC 2 
*----------
set vpage 1 7 2 5 
set grads off
set gxout shaded
set clevs  -0.500 0.500
set ccols  33 0 37 
set t 3
d cor
set gxout contour
set clevs   -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8  
d cor
draw title RPC 3 
*----------
run cbarn.gs 1 0 4.3 
run /export/sgi57/wd52pp/bin/cbarn.gs
c
*----------
reset
*----------
disable print
