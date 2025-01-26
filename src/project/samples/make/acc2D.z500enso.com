 open /export-1/sgi59/wd52pp/data/tony/acc2d_vs_obs_z500.jfm.ctl
 open /export-1/sgi59/wd52pp/data/echam/acc2d_vs_obs_z500enso.jfm.ctl
 open /export-1/sgi59/wd52pp/data/b9x/acc2d_vs_obs_z500enso.jfm.ctl
 reset
 enable print  meta.corr
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
draw string 4.0 10.8 corr(model.vs.obs) Z(500mb) JFM 58-94 ENSO
set vpage 1 7 7 10.5
set grads off
set gxout shaded
set clevs  -0.500 0.500
set ccols  32 0 37 
d cor2
set gxout contour
set clevs  -0.7 -0.6 -0.5 -0.4 -0.3 0.3 0.4 0.5 0.6 0.7 0.8 0.9  
d cor2
draw title statistical
*----------
set vpage 1 7 4 7.5 
set grads off
set gxout shaded
set clevs  -0.500 0.500
set ccols  32 0 37 
d cor.2
set gxout contour
set clevs  -0.7 -0.6 -0.5 -0.4 -0.3 0.3 0.4 0.5 0.6 0.7 0.8 0.9  
d cor.2
draw title ECHAM  
*----------
set vpage 1 7 1 4.5 
set grads off
set gxout shaded
set clevs  -0.500 0.500
set ccols  32 0 37 
d cor.3
set gxout contour
set clevs  -0.7 -0.6 -0.5 -0.4 -0.3 0.3 0.4 0.5 0.6 0.7 0.8 0.9  
d cor.3
draw title NCEP(b9x) 
*----------
run cbarn.gs 1 0 4.3 
run /export/sgi57/wd52pp/bin/cbarn.gs
*print
c
*----------
reset
*----------
disable print
