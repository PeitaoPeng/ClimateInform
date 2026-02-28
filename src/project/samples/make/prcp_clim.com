open /export-1/sgi59/wd52pp/data/echam/prcp.50_94clim.ctl
open /export-1/sgi59/wd52pp/data/b9x/prcp.50_94clim.ctl
open /export-1/sgi59/wd52pp/data/ccm3/prcp.50_94clim.ctl
open /export-1/sgi59/wd52pp/data/gfdl/merg/prcp.50_94clim.ctl
 reset
 enable print  meta.clim
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
draw string 5.5 8 prcp (JFM 50-94) clim (mm/day)
**********
set vpage 0.5 5.5 3.5 7.5
set grads off
set gxout contour
set csmooth on
set clevs 1 2 4 8 16 32
d ave(z,t=1,t=3)*86400000
draw title ECHAM
*----------
set vpage 5.5 10.5 3.5 7.5  
set grads off
set gxout contour
set csmooth on
set clevs 1 2 4 8 16 32
d ave(z.2,t=1,t=3)
draw title NCEP(b9x)
*----------
set vpage  0.5 5.5  0 4  
set grads off
set gxout contour
set csmooth on
set clevs 1 2 4 8 16 32
d ave(z.3,t=1,t=3)
draw title CCM3
*----------
set vpage  5.5 10.5 0 4  
set grads off
set gxout contour
set csmooth on
set clevs 1 2 4 8 16 32
define clim=ave(p.4,t=1,t=3)*10
d clim
draw title GFDL
print
c
*********
reset
set string 1 tc 8
set strsiz 0.2 0.2
draw string 5.5 8 prcp (JJA 50-94) clim (mm/day)
**********
set vpage 0.5 5.5 3.5 7.5
set grads off
set gxout contour
set csmooth on
set clevs 1 2 4 8 16 32
d ave(z,t=6,t=8)*86400000
draw title ECHAM
*----------
set vpage 5.5 10.5 3.5 7.5  
set grads off
set gxout contour
set csmooth on
set clevs 1 2 4 8 16 32
d ave(z.2,t=6,t=8)
draw title NCEP(b9x)
*----------
set vpage  0.5 5.5  0 4  
set grads off
set gxout contour
set csmooth on
set clevs 1 2 4 8 16 32
d ave(z.3,t=6,t=8)
draw title CCM3
*----------
set vpage  5.5 10.5 0 4  
set grads off
set gxout contour
set csmooth on
set clevs 1 2 4 8 16 32
d ave(p.4,t=6,t=8)*10
draw title GFDL
print
