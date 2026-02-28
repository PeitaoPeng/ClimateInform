reinit
open /export-6/cacsrv1/wd52pp/b9x/z500_5094jfm.esm_rsd.reg.ctl
open /export-6/cacsrv1/wd52pp/echam/z500_5094jfm.esm_rsd.reg.ctl
open /export-6/cacsrv1/wd52pp/ccm3/z500_5094jfm.esm_rsd.reg.ctl
open /export-6/cacsrv1/wd52pp/gfdl/z500_5094jfm.esm_rsd.reg.ctl
open /export-6/cacsrv1/wd52pp/b9x/var_z500_5094jfm.reg.ctl
open /export-6/cacsrv1/wd52pp/echam/var_z500_5094jfm.reg.ctl
open /export-6/cacsrv1/wd52pp/ccm3/var_z500_5094jfm.reg.ctl
open /export-6/cacsrv1/wd52pp/gfdl/var_z500_5094jfm.reg.ctl
enable print  meta.var
set mproj nps
set frame off
set lat 25 90
set lon 0 360
set gxout contour
set csmooth on
set clopts -1 -1 0.16
set string 1 tc 8
************
define v1=ave(z*z,t=1,t=45)
define v2=ave(z.2*z.2,t=1,t=45)
define v3=ave(z.3*z.3,t=1,t=45)
define v4=ave(z.4*z.4,t=1,t=45)
set strsiz 0.2 0.2
draw string 4.25 10.8 Z500 `3s`b`0E_rsd`n GCM jfm 50-94
set vpage 0.75 4.25 6.5 10
set grads off
set gxout shaded
set clevs 0.1
set ccols 34 0 
d v1/(int.5+esm.5)
set gxout contour
set csmooth on
set cint 5
d sqrt(v1)
draw title MRF
*----------
set vpage 4.25 7.75 6.5 10
set grads off
set gxout shaded
set clevs 0.12
set ccols 34 0 
d v2/(int.6+esm.6)
set gxout contour
set csmooth on
set cint 5
d sqrt(v2)
draw title ECHAM
*----------
set vpage 0.75 4.25 3 6.5
set grads off
set gxout shaded
set clevs 0.1
set ccols 34 0 
d v3/(int.7+esm.7)
set gxout contour
set csmooth on
set cint 5
d sqrt(v3)
draw title CCM3
*----------
set vpage 4.25 7.75 3 6.5 
set grads off
set gxout shaded
set clevs 0.1
set ccols 34 0 
d v4/(int.8+esm.8)
set gxout contour
set csmooth on
set cint 5
d sqrt(v4)
draw title GFDL
print
c
*----------
reset
*-----
set mproj nps
set frame off
set lat 25 90
set lon 0 360
set gxout contour
set csmooth on
set clopts -1 -1 0.16
set string 1 tc 8
************
set strsiz 0.2 0.2
draw string 4.25 10.8 regr: tpSST vs Z500 jfm 5094
set vpage 0.75 4.25 6.5 10
set grads off
set gxout shaded
set clevs 0
set ccols  35 0 
d z(t=46)
set gxout contour
set csmooth on
set cint 5
d z(t=46)
draw title MRF
*----------
set vpage 4.25 7.75 6.5 10
set grads off
set gxout shaded
set clevs 0
set ccols  35 0 
d z.2(t=46)
set gxout contour
set csmooth on
set cint 5
d z.2(t=46)
draw title ECHAM
*----------
set vpage 0.75 4.25 3 6.5
set grads off
set gxout shaded
set clevs 0
set ccols  35 0 
d z.3(t=46)
set gxout contour
set csmooth on
set cint 5
d z.3(t=46)
draw title CCM3
*----------
set vpage 4.25 7.75 3 6.5 
set grads off
set gxout shaded
set clevs 0
set ccols 35 0 
d z.4(t=46)
set gxout contour
set csmooth on
set cint 5
d z.4(t=46)
draw title GFDL
*print
c
*----------
