 open /export-1/sgi59/wd52pp/data/gfdl/merg/z500_var_intsmp.50_94.ctl
reset
enable print  meta.stdv
*===========================
* tropical heating
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set lat 20 70
set lon 150 300
set mproj nps
set frame off
set gxout contour
set csmooth on 
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 gfdl int_sample var_z500 JFM 50-94 

set vpage 1 7 7 10.5
set grads off
set cint 200
define s=(z(t=3)+z(t=4)+z(t=5)+z(t=8)+z(t=11)+z(t=12)+z(t=15)+z(t=23)+z(t=28)+z(t=30)+z(t=32)+z(t=33)+z(t=41)+z(t=42)+z(t=44)+z(t=45))/16.
d s
draw title normal years  
*----------
set vpage 1 7 4 7.5 
set grads off
set cint 200
define s2=(z(t=9)+z(t=17)+z(t=20)+z(t=24)+z(t=34)+z(t=38)+z(t=43))/7.
d s2
draw title El Nino years
*----------
set vpage 1 7 1 4.5 
set grads off
set cint 200
define s3=(z(t=1)+z(t=6)+z(t=7)+z(t=22)+z(t=25)+z(t=27)+z(t=36)+z(t=40))/8.
d s3
draw title La Nino years
*----------
*print
c
*----------
reset
set lat 20 70
set lon 150 300
set mproj nps
set frame off
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 gfdl int_sample var_z500 JFM 50-94 

set vpage 1 7 7 10.5
set grads off
set gxout shaded
set clevs   1
set ccols   34 0
d (s2/s)
set gxout contour
set csmooth on
set cint 0.2
d (s2/s)
draw title El Nino/normal 
*----------
set vpage 1 7 4 7.5 
set grads off
set gxout shaded
set clevs   1
set ccols   34 0
d (s3/s)
set gxout contour
set csmooth on
set cint 0.2
d (s3/s)
draw title La Nino/normal 
*----------
set vpage 1 7 1 4.5 
set grads off
set gxout shaded
set clevs   1
set ccols   34 0
d (s2/s3)
set gxout contour
set csmooth on
set cint 0.2
d (s2/s3)
draw title El Nino/La Nino 
*----------
print
c
