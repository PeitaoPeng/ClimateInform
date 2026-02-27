 open /export-1/sgi59/wd52pp/data/b9x/corr.z500stdv_vs_sst.jfm.ctl
 open /export-1/sgi59/wd52pp/data/echam/corr.z500stdv_vs_sst.jfm.ctl
 open /export-1/sgi59/wd52pp/data/ccm3/corr.z500stdv_vs_sst.jfm.ctl
 open /export-1/sgi59/wd52pp/data/gfdl/merg/corr.z500stdv_vs_sst.jfm.ctl
reset
* enable print  meta.corr
*===========================
* tropical heating
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set lat -90 90
set lon 0 360
set gxout contour
set csmooth on 
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 CORR(tpSST vs int_stdv of z500) JFM 50-94 

set vpage 1 7 7 10.5
set grads off
set cint 0.05  
d cor
draw title NCEP(b9x)  
*----------
set vpage 1 7 4 7.5 
set grads off
set cint 0.05
d cor.2
draw title ECHAM  
*----------
set vpage 1 7 1 4.5 
set grads off
set cint 0.05
d cor.3
draw title CCM3   
*----------
*print
c
*----------
reinit
open /export-1/sgi59/wd52pp/data/gfdl/merg/corr.z500stdv_vs_sst.jfm.ctl
 enable print  meta.corr
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 CORR(tpSST vs int_stdv of z500) JFM 50-94 
*----------
set lat -90 90
set lon 0 360
set gxout contour
set csmooth on 
set vpage 1 7 7 10.5
set grads off
set cint 0.05  
d cor
draw title GFDL  
disable print
print
c
*----------
