open /export-6/cacsrv1/wd52pp/modes/z500_4950-0001djfm.ntd.reg.ctl
open /export-6/cacsrv1/wd52pp/modes/rsd_reof.z500.5001djfm.ntd.ctl
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
define zw=(z(t=9)+z(t=17)+z(t=24)+z(t=34)+z(t=38)+z(t=43)+z(t=49))/7.
define zc=-(z(t=1)+z(t=22)+z(t=25)+z(t=27)+z(t=36)+z(t=40)+z(t=50)+z(t=51))/8.
define e=-regr.2(t=1)
define p=regr.2(t=4)
*
define sw=sqrt(aave(zw*zw,lon=150,lon=320,lat=20,lat=70))
define sc=sqrt(aave(zc*zc,lon=150,lon=320,lat=20,lat=70))
define se=sqrt(aave(e*e,lon=150,lon=320,lat=20,lat=70))
define sp=sqrt(aave(p*p,lon=150,lon=320,lat=20,lat=70))
*
define wc=aave(zw*zc,lon=150,lon=320,lat=20,lat=70)
define we=aave(zw*e,lon=150,lon=320,lat=20,lat=70)
define ce=aave(zc*e,lon=150,lon=320,lat=20,lat=70)
define wp=aave(zw*p,lon=150,lon=320,lat=20,lat=70)
define cp=aave(zc*p,lon=150,lon=320,lat=20,lat=70)
define ep=aave(e*p,lon=150,lon=320,lat=20,lat=70)
d wc/(sw*sc)
d we/(sw*se)
d ce/(sc*se)
d wp/(sw*sp)
d cp/(sc*sp)
d ep/(se*sp)
*----------
