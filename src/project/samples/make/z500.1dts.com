 open /export-1/sgi59/wd52pp/data/obs/reanl/z500.58_94jas.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_esm_58_94jas.ctl
 open /export-1/sgi59/wd52pp/data/echam/z500_esm_58_94jas.ctl
 open /export-1/sgi59/wd52pp/data/sst/sst.58_94jas.ctl
 reset
 enable print  meta.z
*===========================
set csmooth on
*----------
set lon 60
set lat 0
*********
set grads off
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 500mb Z(60E-120E,10S-10N) JAS 58-94 
*----------
set vpage 1 7 7.5 10.
set grads off
set t 1 37
d tloop(aave(z,lon=60,lon=120,lat=-10,lat=10))
draw title NCEP reanl 
*----------
set vpage 1 7 5.5 8.
set grads off
set t 1 37
d tloop(aave(z.2,lon=60,lon=120,lat=-10,lat=10))
draw title NCEP(b9x)  
*----------
set vpage 1 7 3.5 6.
set grads off
set t 1 37
d tloop(aave(z.3,lon=60,lon=120,lat=-10,lat=10))
draw title ECHAM  
*----------
set vpage 1 7 1.5 4
set grads off
set t 1 37
d tloop(aave(sst.4,lon=60,lon=120,lat=-10,lat=10))
draw title SST  
