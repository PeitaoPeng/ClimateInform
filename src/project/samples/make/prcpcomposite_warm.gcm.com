set display color white
open /export-6/cacsrv1/wd52pp/amip/prcpjas_warm_composite.ctl
 reset
 enable print  meta.comp
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
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
draw string 4.0 10.6 NCEP jas prate(mm/mon) warm case composite 1950-94
draw string 4.0 10.3 7x9 cases (65  72  82  87  91  93  94)
draw string 4.0 9.65 Physical anom (contours) & % cases with anom in top 33.3%
draw string 4.0 4.65 SD anom (contours) & % cases with anom in bottom 33.3%
set vpage 0.5 7.5 5 10
set grads off
set gxout shaded
set clevs 10 20 30 40 50 60 70 80 90
set ccols 49 43 31 0 71 23 25 27 29 79
d tp*100
set gxout contour
set csmooth on
set clevs -160 -80 -40 -20 -10 -5 5 10 20 40  80 160
 d z*86400*30
*d z*86400000*30
*d z*30
*d z
run /export/sgi57/wd52pp/bin/cbarn.gs
*********
set vpage 0.5 7.5 0 5
set grads off
set gxout shaded
set clevs 10 20 30 40 50 60 70 80 90
set ccols 49 43 31 0 71 23 25 27 29 79
d bp*100
set gxout contour
set csmooth on
set cint 0.4
d s
run /export/sgi57/wd52pp/bin/cbarn.gs
print
c
*===========================
reset
set mproj nps
set frame off
set mpdset mres
set lat 15 75
set lon 180 310
set string 1 tc 8
set strsiz 0.15 0.15
draw string 4.0 10.6 NCEP jas prate(mm/mon) warm case composite 1950-94
draw string 4.0 10.3 7x9 cases (65  72  82  87  91  93  94)
draw string 4.0 9.65 Physical anom (contours) & % cases with anom in top 33.3%
draw string 4.0 4.65 SD anom (contours) & % cases with anom in bottom 33.3%
set vpage 0.5 7.5 5 10
set grads off
set gxout shaded
set clevs 10 20 30 40 50 60 70 80 90
set ccols 49 43 31 0 71 23 25 27 29 79
d tp*100
set gxout contour
set csmooth on
set clevs -160 -80 -40 -20 -10 -5 5 10 20 40  80 160
 d z*86400*30
*d z*86400000*30
*d z*30
*d z
run /export/sgi57/wd52pp/bin/cbarn.gs
*********
set vpage 0.5 7.5 0 5
set grads off
set gxout shaded
set clevs 10 20 30 40 50 60 70 80 90
set ccols 49 43 31 0 71 23 25 27 29 79
d bp*100
set gxout contour
set csmooth on
set cint 0.2 
d s
run /export/sgi57/wd52pp/bin/cbarn.gs
print
c
*===========================
reset
set mproj latlon
set frame off
set lat -30 30
set lon 120 280
set string 1 tc 8
set strsiz 0.15 0.15
draw string 4.0 10.6 NCEP jas prate(mm/mon) warm case composite 1950-94
draw string 4.0 10.3 7x9 cases (65  72  82  87  91  93  94)
draw string 4.0 9.65 Physical anom (contours) & % cases with anom in top 33.3%
draw string 4.0 4.65 SD anom (contours) & % cases with anom in bottom 33.3%
set vpage 0.5 7.5 5 10
set grads off
set gxout shaded
set clevs 10 20 30 40 50 60 70 80 90
set ccols 49 43 31 0 71 23 25 27 29 79
d tp*100
set gxout contour
set csmooth on
set clevs -160 -80 -40 -20 -10 -5 5 10 20 40  80 160
 d z*86400*30
*d z*86400000*30
*d z*30
*d z
run /export/sgi57/wd52pp/bin/cbarn.gs
*********
set vpage 0.5 7.5 0 5
set grads off
set gxout shaded
set clevs 10 20 30 40 50 60 70 80 90
set ccols 49 43 31 0 71 23 25 27 29 79
d bp*100
set gxout contour
set csmooth on
set cint 0.2 
d s
run /export/sgi57/wd52pp/bin/cbarn.gs
print
c
*===========================
