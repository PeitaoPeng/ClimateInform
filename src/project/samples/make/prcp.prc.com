open /export-3/sgi57/ocean/wd52pp/ctlxrad/anom/prcp_7180jfm.ctl
open /export-3/sgi57/ocean/wd52pp/ctlxrad/clim/prcp_7180jfm.ctl
open /export-3/sgi57/ocean/wd52pp/ctlxrad/anom/prcpa-c.7180jfm.ctl 
 reset
 enable print  meta.prcp
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set lat -90 90
set lon 0 360
*********
set vpage 1 10 1 7
set grads off
set gxout contour
set csmooth on
set clevs 1 2 4 8 16 32 64
d ave(z,t=1,t=10)*86400
draw title ctlxrad anom_run 10yr JFM prcp (mm/day)
print
c
*----------
set vpage 1 10 1 7
set grads off
set gxout contour
set csmooth on
set clevs 1 2 4 8 16 32 64
d ave(z.2,t=1,t=10)*86400
draw title ctlxrad clim_run 10yr JFM prcp (mm/day)
print
c
*----------
set vpage 1 10 1 7
set grads off
set gxout contour
set csmooth on
set clevs -64 -32 -16 -8 -4 -2 -1 1 2 4 8 16 32 64
d ave(z-z.2,t=1,t=10)*86400
draw title ctlxrad anom-clim 10yr JFM prcp (mm/day)
print
c
*----------
