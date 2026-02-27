open /export-6/cacsrv1/wd52pp/obs/reanl/corr.decadal_vs_sst.jfm5098.ctl
 reset
 enable print  meta.corr
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set lat -30 70
set lon 0 360
set clopts -1 -1 0.12
*********
*----------
reset
*----------
set clopts -1 -1 0.12
set lat -30 70
set lon 0 360
set string 1 tc 8
set strsiz 0.2 0.2
draw string 5.5 8 corr: decadal mode SST jfm5098 
set t 1
set vpage 3 7.5 4 7  
set grads off
set gxout shaded
set clevs  -0.280 0.280
set ccols  33 0 37 
d corr
set gxout contour
set clevs    -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.6 0.8 1.0
d regr
*----------
print
*----------
c
*----------
reset
*----------
disable print
