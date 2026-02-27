open /export-6/cacsrv1/wd52pp/modes/corr.sst.vs.rsd_rcoef.z500.5001djfm.ntd.ctl
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
draw string 5.5 8 SST regr to tp_sst_rpc
set t 1
set vpage 1 5.5 5 8  
set grads off
set gxout shaded
set clevs  -0.27 0.27
set ccols  33 0 38 
d -corr
set gxout contour
set clevs   -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5 0.9
*set cint 0.1
d -regr
draw title tp_sst RPC1
*----------
set vpage 5.5 10 5 8
set grads off
set gxout shaded
set clevs  -0.27 0.27
set ccols  33 0 38 
set t 2
d -corr
set gxout contour
set clevs   -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5  
d -regr
draw title tp_sst RPC2 
*----------
print
c
*----------
reset
*----------
*----------
set lat -30 70
set lon 0 360
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 5.5 8 SST regr to Z500_rsd_rpc
set t 3
set vpage 1 5.5 5 8  
set grads off
set gxout shaded
set clevs  -0.27 0.27
set ccols  33 0 38 
d corr
set gxout contour
set clevs   -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5 0.9
*set cint 0.1
d regr
draw title Z500_rsd RPC1
*----------
set vpage 5.5 10 5 8
set grads off
set gxout shaded
set clevs  -0.27 0.27
set ccols  33 0 38 
set t 4
d corr
set gxout contour
set clevs   -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5  
d regr
draw title Z500_rsd RPC2
*----------
set vpage 1 5.5 3 6 
set grads off
set gxout shaded
set clevs  -0.27 0.27
set ccols  33 0 38 
set t 5
d corr
set gxout contour
set clevs   -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5  
d regr
draw title Z500_rsd RPC3 
*----------
set vpage 5.5 10 3 6 
set grads off
set gxout shaded
set clevs  -0.27 0.27
set ccols  33 0 38 
set t 6
d corr
set gxout contour
set clevs   -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5  
d regr
draw title Z500_rsd RPC4 
*----------
set vpage 1 5.5 1 4 
set grads off
set gxout shaded
set clevs  -0.27 0.27
set ccols  33 0 38 
set t 7
d corr
set gxout contour
set clevs   -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5  
d regr
draw title Z500_rsd RPC5 
*----------
set vpage 5.5 10 1 4
set grads off
set gxout shaded
set clevs  -0.27 0.27
set ccols  33 0 38 
set t 8
d corr
set gxout contour
set clevs   -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5  
d regr
draw title Z500_rsd RPC6
print
c
*----------
*reset
