open /export-6/cacsrv1/wd52pp/modes/z500_4950-0001djfm.ntd.reg.ctl
 reset
 enable print  meta.eof
*===========================
run /export-6/sgi9/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
reset
*----------
set mproj nps
set frame off
set lat 20 90
set lon 0 360
set gxout contour
set csmooth on
set clopts -1 -1 0.16
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 DJFM Z500 ENSO composites
define warm=(z(t=9)+z(t=17)+z(t=24)+z(t=34)+z(t=38)+z(t=43)+z(t=49))/7.
define cold=-(z(t=1)+z(t=22)+z(t=25)+z(t=27)+z(t=36)+z(t=40)+z(t=50)+z(t=51))/8.
set vpage 1 4 7.0 10.0
set grads off
set gxout shaded
set clevs 0
set ccols  35 0
d warm
set gxout contour
set csmooth on
set cint 10
d warm
draw title warm
*----------
set vpage 4 7 7.0 10.0
set grads off
set gxout shaded
set clevs 0
set ccols  35 0
d cold
set gxout contour
set csmooth on
set cint 10
d cold
draw title cold x (-1)
*----------
print
c
*----------
