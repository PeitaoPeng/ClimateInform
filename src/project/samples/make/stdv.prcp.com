 open /export-1/sgi59/wd52pp/data/b9x/corr.rain_vs_sst.jas.ctl
 open /export-1/sgi59/wd52pp/data/echam/corr.prcp_vs_sst.jas.ctl
 open /export-1/sgi59/wd52pp/data/obs/reanl/corr.prcp_vs_sst.jas.ctl
 reset
 enable print  meta.stdv
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
draw string 4.0 10.8 PRCP stdv JAS 58-94
set vpage 1 7 7 10.5
set grads off
set gxout shaded
set clevs    2 4        
set ccols   0 33 38
d std.3
set gxout contour
set csmooth on
set clevs   1 2 4        
d std.3
draw title NCEP reanalysis
*----------
set vpage 1 7 4 7.5 
set grads off
set gxout shaded
set clevs    2 4        
set ccols   0 33 38
d std.2(t=11)*86400000
set gxout contour
set csmooth on
set clevs   1 2 4        
d std.2(t=11)*86400000
draw title ECHAM
*----------
set vpage 1 7 1 4.5 
set grads off
set gxout shaded
set clevs     2 4       
set ccols   0 33 38
d std(t=14)/30
set gxout contour
set csmooth on
set clevs    1 2 4       
d std(t=14)/30
draw title NCEP(b9x)
*----------
run cbarn.gs 1 0 4.3 
run /export-1/sgi59/wd52pp/bin/cbarn.gs
*print
c
*----------
reset
*----------
disable print
