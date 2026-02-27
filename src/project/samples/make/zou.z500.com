set display color white
open /export-1/sgi57/ocean/wd52pp/obs/reanl/z500composite_cold.ctl
open /export-1/sgi57/ocean/wd52pp/obs/reanl/z500composite_warm.ctl
 reset
 enable print  meta.comp
*===========================
run /export/sun10/wd01ak/grd/rgbset.gs
set csmooth on
set grid on
*----------
*set mproj nps
*set frame off
*set lat 10 90
*set lon 0 360
*********
set string 1 tc 8
set strsiz 0.15 0.15
draw string 4.0 10.6 NCEP reanl Z500(m) anom ENSO composite JFM 1950-94
draw string 4.0 9.65 cold cases (50  51  55  56  71  74  76  89)
draw string 4.0 4.65 warm cases (58  66  69  73  83  87  88  92)
set t 1
set vpage 0.5 7.5 5 10
set grads off
set cint 10 
d z
*********
set vpage 0.5 7.5 0 5
set grads off
d z.2
print
c
*===========================
reset
set string 1 tc 8
set strsiz 0.15 0.15
draw string 4.0 10.6 NCEP reanl Z500(m) anom ENSO composite JAS 1950-94
draw string 4.0 9.65 cold cases (50  54  55  56  64  73  75  88)
draw string 4.0 4.65 warm cases (65  72  82  87  91  93  94)
set t 7
set vpage 0.5 7.5 5 10
set grads off
set cint 10 
d z
*********
set vpage 0.5 7.5 0 5
set grads off
d z.2
print
c
*===========================
