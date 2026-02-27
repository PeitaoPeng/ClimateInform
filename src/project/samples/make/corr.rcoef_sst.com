*open /export-6/cacsrv1/wd52pp/obs/reanl/corr.rsd_rcoef_vs_sst.jfm5098.nodec.ctl
open /export-6/cacsrv1/wd52pp/obs/reanl/corr.rcoef_cor_vs_sst.jfm5099.ctl
 reset
 enable print  meta.corr
*===========================
run /export-6/sgi9/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set lat -30 70
set lon 0 360
set clopts -1 -1 0.12
*********
set string 1 tc 8
set strsiz 0.2 0.2
*draw string 5.5 8 corr: obs z500_rsd_rcoef_nodec vs SST jfm5098 
draw string 5.5 8 corr: obs z500_rcoef_cor vs SST jfm5098 
set t 1
set vpage 1 5.5 5 8  
set grads off
set gxout shaded
set clevs  -0.270 0.270
set ccols  33 0 37 
d corr
set gxout contour
set clevs    -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5 
d regr
draw title RPC 1 
*----------
set vpage 5.5 10 5 8
set grads off
set gxout shaded
set clevs  -0.270 0.270
set ccols  33 0 37 
set t 2
d corr
set gxout contour
set clevs    -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5 
d regr
draw title RPC 2 
*----------
set vpage 1 5.5 3 6 
set grads off
set gxout shaded
set clevs  -0.270 0.270
set ccols  33 0 37 
set t 3
d corr
set gxout contour
set clevs    -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5 
d regr
draw title RPC 3 
*----------
set vpage 5.5 10 3 6 
set grads off
set gxout shaded
set clevs  -0.270 0.270
set ccols  33 0 37 
set t 4
d corr
set gxout contour
set clevs    -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5 
d regr
draw title RPC 4 
*----------
set vpage 1 5.5 1 4 
set grads off
set gxout shaded
set clevs  -0.270 0.270
set ccols  33 0 37 
set t 5
d corr
set gxout contour
set clevs    -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5 
d regr
draw title RPC 5 
*----------
set vpage 5.5 10 1 4
set grads off
set gxout shaded
set clevs  -0.270 0.270
set ccols  33 0 37 
set t 6
d corr
set gxout contour
set clevs    -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5 
d regr
draw title RPC 6 
print
c
*----------
reset
*----------
set clopts -1 -1 0.12
set lat -30 70
set lon 0 360
set string 1 tc 8
set strsiz 0.2 0.2
draw string 5.5 8 corr: tpsst RPC1 vs SST jfm5098 
*set t 1
set vpage 3 7.5 4 7  
set grads off
set gxout shaded
set clevs  -0.270 0.270
set ccols  33 0 37 
*d corr
set gxout contour
set clevs    -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.6 0.8 1.0
*d regr
*draw title RPC 7 
*----------
*print
*----------
c
*----------
reset
*----------
disable print
