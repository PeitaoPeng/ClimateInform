open /export-6/cacsrv1/wd52pp/obs/reanl/z500_5099jfm.reg.ctl
 reset
 enable print  meta.var
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
reset
*----------
set mproj nps
set frame off
set lat 25 90
set lon 0 360
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.25 10.8  Z500 `3s`0 obs jfm 50-94 
*define var=ave(z*z,t=1,t=45)
set vpage 2.5 6.0 6.0 9.5
set grads off
set gxout shaded
set clevs 50
set ccols  0 35 
*d sqrt(var)
set gxout contour
set csmooth on
set cint 5
set clopts -1 -1 0.16
*d sqrt(var)
*print
c
reset
*----------
reinit
open /export-6/cacsrv1/wd52pp/b9x/var_z500_5094jfm.reg.ctl
open /export-6/cacsrv1/wd52pp/echam/var_z500_5094jfm.reg.ctl
open /export-6/cacsrv1/wd52pp/ccm3/var_z500_5094jfm.reg.ctl
open /export-6/cacsrv1/wd52pp/gfdl/var_z500_5094jfm.reg.ctl
enable print  meta.var2
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
draw string 4.25 10.8 Z500 `3s`0 GCM jfm 50-94 
set vpage 0.75 4.25 6.5 10
set grads off
set gxout shaded
set clevs 50
set ccols  0 35 
d sqrt(int+esm)
set gxout contour
set csmooth on
set cint 5
d sqrt(int+esm)
draw title MRF
*----------
set vpage 4.25 7.75 6.5 10
set grads off
set gxout shaded
set clevs 50
set ccols  0 35 
d sqrt(int.2+esm.2)
set gxout contour
set csmooth on
set cint 5
d sqrt(int.2+esm.2)
draw title ECHAM
*----------
set vpage 0.75 4.25 3 6.5
set grads off
set gxout shaded
set clevs 50
set ccols  0 35 
d sqrt(int.3+esm.3)
set gxout contour
set csmooth on
set cint 5
d sqrt(int.3+esm.3)
draw title CCM3
*----------
set vpage 4.25 7.75 3 6.5 
set grads off
set gxout shaded
set clevs 50
set ccols  0 35 
d sqrt(int.4+esm.4)
set gxout contour
set csmooth on
set cint 5
d sqrt(int.4+esm.4)
draw title GFDL
*print
c
*----------
reset
*----------
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.25 10.8 Z500 `3s`b`0E`a`02`n/`3s`b`0I`a`02`n GCM jfm 50-94 
set mproj nps
set frame off
set lat 25 90
set lon 0 360
set gxout contour
set csmooth on
set clopts -1 -1 0.16
*********
set vpage 0.75 4.25 6.5 10
set grads off
set gxout shaded
set clevs 0.5
set ccols  0 35 
d esm/int
set gxout contour
set csmooth on
set cint 0.1
d esm/int
draw title MRF
*----------
set vpage 4.25 7.75 6.5 10 
set grads off
set gxout shaded
set clevs 0.5
set ccols  0 35 
d esm.2/int.2
set gxout contour
set csmooth on
set cint 0.2
d esm.2/int.2
draw title ECHAM
*----------
set vpage 0.75 4.25 3 6.5
set grads off
set gxout shaded
set clevs 0.5
set ccols  0 35 
d esm.3/int.3
set gxout contour
set csmooth on
set cint 0.1
d esm.3/int.3
draw title CCM3
*----------
set vpage 4.25 7.75 3 6.5
set grads off
set gxout shaded
set clevs 0.5
set ccols  0 35 
d esm.4/int.4
set gxout contour
set csmooth on
set cint 0.1
d esm.4/int.4
draw title GFDL
*print
c
reset
*----------
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.25 10.8 Z500 `3s`b`0E`a`02`n/(`3s`b`0E`a`02`n+`3s`b`0I`a`02`n) GCM jfm 50-94 
set mproj nps
set frame off
set lat 25 90
set lon 0 360
set gxout contour
set csmooth on
set clopts -1 -1 0.16
*********
set vpage 0.75 4.25 6.5 10
set grads off
set gxout shaded
set clevs 0.1 0.30
set ccols  33 0 38 
d esm/(esm+int)
set gxout contour
set csmooth on
set cint 0.1
d esm/(esm+int)
draw title MRF
*----------
set vpage 4.25 7.75 6.5 10 
set grads off
set gxout shaded
set clevs 0.12 0.30
set ccols  33 0 38
d esm.2/(esm.2+int.2)
set gxout contour
set csmooth on
set cint 0.1
d esm.2/(esm.2+int.2)
draw title ECHAM
*----------
set vpage 0.75 4.25 3 6.5
set grads off
set gxout shaded
set clevs 0.1 0.30
set ccols  33 0 38
d esm.3/(esm.3+int.3)
set gxout contour
set csmooth on
set cint 0.1
d esm.3/(esm.3+int.3)
draw title CCM3
*----------
set vpage 4.25 7.75 3 6.5
set grads off
set gxout shaded
set clevs 0.1 0.30
set ccols  33 0 38
d esm.4/(esm.4+int.4)
set gxout contour
set csmooth on
set cint 0.1
d esm.4/(esm.4+int.4)
draw title GFDL
print
c
