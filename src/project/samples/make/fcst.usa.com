 open /export-1/sgi59/wd52pp/data/echam/f1098.167.ndj99.ctl
 open /export-1/sgi59/wd52pp/data/echam/f1098.167.jfm99.ctl
 open /export-1/sgi59/wd52pp/data/echam/f1098.260.ndj99.ctl
 open /export-1/sgi59/wd52pp/data/echam/f1098.260.jfm99.ctl
 open /export-1/sgi59/wd52pp/data/echam/f1098.500.ndj99.ctl
 open /export-1/sgi59/wd52pp/data/echam/f1098.500.jfm99.ctl
 open /export-1/sgi59/wd52pp/data/echam/2mt.58_94ndjclim.ctl
 open /export-1/sgi59/wd52pp/data/echam/2mt.58_94jfmclim.ctl
 open /export-1/sgi59/wd52pp/data/echam/prcp.58_94ndjclim.ctl
 open /export-1/sgi59/wd52pp/data/echam/prcp.58_94jfmclim.ctl
 open /export-1/sgi59/wd52pp/data/echam/z500.58_94ndjclim.ctl
 open /export-1/sgi59/wd52pp/data/echam/z500.58_94jfmclim.ctl
 reset
 enable print  meta.fcst
*===========================
* tropical heating
*===========================
set csmooth on
set grid on
*----------
set lat 17 75
set lon 180 320
set mpdset mres
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 ECHAM fcst: 2mt anom (C)
set vpage 1 7 5 9.5
set grads off
set gxout contour
set csmooth on
set cint 0.5      
d z-z.7
draw title ndj 1998
*----------
set vpage 1 7 1 5.5 
set grads off
set gxout contour
set csmooth on
set cint 0.5      
d z.2-z.8
draw title jfm 1999
print
c
*----------
reset
set lat 17 75
set lon 180 320
set mpdset mres
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 ECHAM fcst: prcp anom (mm/day)
set vpage 1 7 5 9.5
set grads off
set gxout contour
set csmooth on
set cint 0.2
d z.3-z.9*86400000
draw title ndj 1998
*----------
set vpage 1 7 1 5.5 
set grads off
set gxout contour
set csmooth on
set cint 0.2
*set clevs -16 -8 -4 -2 -1 -0.5 0.5 1 2 4 8 16
d z.4-z.10*86400000
draw title jfm 1999
print
c
*----------
reset
set lat 17 75
set lon 180 320
set mpdset mres
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 ECHAM fcst: z500 anom (m)
set vpage 1 7 5 9.5
set grads off
set gxout contour
set csmooth on
set cint 5      
d z.5-z.11
draw title ndj 1998
*----------
set vpage 1 7 1 5.5 
set grads off
set gxout contour
set csmooth on
set cint 5      
d z.6-z.12
draw title jfm 1999
print
c
*----------
c
*----------
reset
*----------
disable print
