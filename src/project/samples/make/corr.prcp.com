 open /export-1/sgi59/wd52pp/data/b9x/corr.rain_vs_sst.jfm.ctl
 open /export-1/sgi59/wd52pp/data/echam/corr.prcp_vs_sst.jfm.ctl
 open /export-1/sgi59/wd52pp/data/obs/reanl/corr.prcp_vs_sst.jfm.ctl
reset
 enable print  meta.corr
*===========================
* tropical heating
*===========================
run /export-1/sgi59/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set lat -90 90
set lon 0 360
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 SST-prcp corr JFM 58-94
set vpage 1 7 7 10.5
set grads off
set gxout shaded
set clevs  -0.325 0.325   
set ccols  33 0 37 
d cor.3
set gxout contour
set clevs   -0.9 -0.7 -0.5 -0.3 0.3 0.5 0.7 0.9  
d cor.3
draw title NCEP reanalyses
*----------
set vpage 1 7 4 7.5 
set grads off
set gxout shaded
set clevs  -0.325 0.325   
set ccols  33 0 37 
d cor.2(t=11)
set gxout contour
set clevs   -0.9 -0.7 -0.5 -0.3 0.3 0.5 0.7 0.9  
d cor.2(t=11)
draw title ECHAM 
*----------
set vpage 1 7 1 4.5 
set grads off
set gxout shaded
set clevs  -0.325 0.325   
set ccols  33 0 37 
d cor(t=14)
set gxout contour
set clevs   -0.9 -0.7 -0.5 -0.3 0.3 0.5 0.7 0.9  
d cor(t=14)
draw title NCEP(b9x) 
*----------
*run /export-1/sgi59/wd52pp/bin/cbarn.gs 1 0 4.3 
 print
*c
*----------
reset
*----------
disable print
