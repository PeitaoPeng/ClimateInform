*open /export-6/cacsrv1/wd52pp/modes/z500_4950-0001djfm.ntd.reg.ctl
open /export-6/cacsrv1/wd52pp/modes/z500_4950-0001djfm.no_wpo.reg.ctl
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
draw string 4.0 10.8 DJFM Z500 tp_ntd_SST_rpc2 comp (no ENSO)
* ENSO according to tp_sst_rcp1_ntd
*define warm=(z(t=9)+z(t=17)+z(t=24)+z(t=34)+z(t=38)+z(t=43)+z(t=49))/7.
*define cold=-(z(t=1)+z(t=22)+z(t=25)+z(t=27)+z(t=36)+z(t=40)+z(t=50)+z(t=51))/8.
*ENSO according to Hoerling
define warm=(z(t=9)+z(t=17)+z(t=20)+z(t=24)+z(t=34)+z(t=38)+z(t=39)+z(t=43)+z(t=46))/9.
define cold=-(z(t=1)+z(t=2)+z(t=6)+z(t=7)+z(t=16)+z(t=22)+z(t=25)+z(t=27)+z(t=36))/9.
* ENSO according to Eric
*define warm=(z(t=9)+z(t=17)+z(t=20)+z(t=24)+z(t=34)+z(t=38)+z(t=43)+z(t=49))/8.
*define cold=-(z(t=1)+z(t=22)+z(t=25)+z(t=27)+z(t=36)+z(t=40)+z(t=50)+z(t=51))/8.
* according to tp_sst_rcp2_ntd
*define warm=(z(t=10)+z(t=19)+z(t=20)+z(t=39)+z(t=41)+z(t=42)+z(t=44)+z(t=46)+z(t=48))/9.
*define cold=-(z(t=2)+z(t=6)+z(t=28)+z(t=34)+z(t=35)+z(t=40)+z(t=49)+z(t=50)+z(t=51)+z(t=52))/10.
* according to tp_sst_rcp2_ntd (no ENSO included)
*define warm=(z(t=10)+z(t=19)+z(t=20)+z(t=39)+z(t=41)+z(t=42)+z(t=44)+z(t=46)+z(t=48))/9.
*define cold=-(z(t=2)+z(t=6)+z(t=25)+z(t=28)+z(t=52))/5.
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
