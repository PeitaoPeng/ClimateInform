open /export-6/cacsrv1/wd52pp/modes/corr.z500.vs.rsd_rcoef.sst.5001djfm.ntd.ctl
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
define z1=regr(t=3)
define z2=regr(t=4)
define z3=regr(t=5)
*
define s1=sqrt(aave(z1*z1,lon=150,lon=320,lat=20,lat=70))
define s2=sqrt(aave(z2*z2,lon=150,lon=320,lat=20,lat=70))
define s3=sqrt(aave(z3*z3,lon=150,lon=320,lat=20,lat=70))
*
define c12=aave(z1*z2,lon=150,lon=320,lat=20,lat=70)
define c23=aave(z2*z3,lon=150,lon=320,lat=20,lat=70)
define c13=aave(z1*z3,lon=150,lon=320,lat=20,lat=70)
d c12/(s1*s2)
d c23/(s2*s3)
d c13/(s1*s3)
*----------
