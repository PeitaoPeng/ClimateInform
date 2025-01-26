#!/bin/sh
set -xe

export GADDIR=/u/wx52cm/grads/dat
export GAUDFT=/u/wx52cm/grads/udf/udf.txt
export GASCRP=/u/wx52cm/grads/scripts

cat >grads.gs<<gsEOF
* write to big endian 
'open LandMaskCONUSdeg0.5pnt.gr.ctl'
'set gxout fwrite'
'set fwrite LandMaskCONUSdeg0.5pnt.big'
'set t 1'
'set z 1'
'set x 1 151'
'set y 1 61'
'd land'
gsEOF

cat >in.dat<< inEOF
reinit
run grads.gs
quit
inEOF
/usrx/local/grads/bin/grads -pb <in.dat

cat >LandMaskCONUSdeg0.5pnt.big.ctl<<ctlEOF
dset ^LandMaskCONUSdeg0.5pnt.big
options  big_endian 
title COUNS land mask
undef -999.0
xdef  151 linear  230.00 0.50
ydef   61 linear   20.00 0.50
zdef 1 linear 1 1
tdef 1 linear 01jan1979 1dy
vars 1
land     1  00 land=1.0
ENDVARS
ctlEOF

cat >glb.f <<fEOF
c
      parameter(im1=151,jm1=61)
      parameter(im2=720,jm2=361)

      real*4 a(im1,jm1)
      real*4 b(im2,jm2)

      bad=-9999.00
      do j=1,jm2
      do i=1,im2
       b(i,j)=bad
      enddo
      enddo
    
      open(11,file='LandMaskCONUSdeg0.5pnt.big'
     1 ,form='unformatted',access='direct',recl=im1*jm1*4)
      read(11,rec=1) a

      open(51,file='LandMaskCONUSdeg0.5pnt.big.glb'
     1 ,form='unformatted',access='direct',recl=im2*jm2*4)
c
      do j=1,61
      do i=1,151
       i1=460+i
       j1=220+j
       if(a(i,j).eq.1.0)then 
        b(i1,j1)=a(i,j)
       endif
      enddo
      enddo
c
      write(51,rec=1) b
      stop
      end
fEOF
f77 glb.f
./a.out

cat >LandMaskCONUSdeg0.5pnt.big.glb.ctl<<ctlEOF
dset ^LandMaskCONUSdeg0.5pnt.big.glb
options  big_endian 
title COUNS land mask
undef -9999.0
xdef  720 linear  0.00 0.50
ydef  361 linear  -90.00 0.50
zdef 1 linear 1 1
tdef 1 linear 01jan1979 1dy
vars 1
land     1  00 land=1.0
ENDVARS
ctlEOF

cat >regrid.gs<<gsEOF
* regrid to 0.5X0.5 grid for T62
'open LandMaskCONUSdeg0.5pnt.big.glb.ctl'
'set lat -90 90'
'set lon  0 360'
'set gxout fwrite'
'set fwrite LandMaskCONUSt62.gr'
'd regrid2(land,192,94,gg)'
gsEOF

cat >in.dat<< inEOF
reinit
run regrid.gs
quit
inEOF

/usrx/local/grads/bin/grads -pb <in.dat
rm grads.gs in.dat udf.regrid.dat udf.regrid.out


cat >LandMaskCONUSt62.ctl <<ctlEOF
dset ^LandMaskCONUSt62.gr
options big_endian
undef -9999.00
title CONUS land mask
xdef 192 linear 0.000000 1.875
ydef 94 levels
-88.542 -86.653 -84.753 -82.851 -80.947 -79.043 -77.139 -75.235 -73.331 -71.426
-69.522 -67.617 -65.713 -63.808 -61.903 -59.999 -58.094 -56.189 -54.285 -52.380
-50.475 -48.571 -46.666 -44.761 -42.856 -40.952 -39.047 -37.142 -35.238 -33.333
-31.428 -29.523 -27.619 -25.714 -23.809 -21.904 -20.000 -18.095 -16.190 -14.286
-12.381 -10.476  -8.571  -6.667  -4.762  -2.857  -0.952   0.952   2.857   4.762
  6.667   8.571  10.476  12.381  14.286  16.190  18.095  20.000  21.904  23.809
 25.714  27.619  29.523  31.428  33.333  35.238  37.142  39.047  40.952  42.856
 44.761  46.666  48.571  50.475  52.380  54.285  56.189  58.094  59.999  61.903
 63.808  65.713  67.617  69.522  71.426  73.331  75.235  77.139  79.043  80.947
 82.851  84.753  86.653  88.542
zdef 1 levels 1
tdef 1 linear jan1979 1mo
vars 1
land     1  00 land=1.0
ENDVARS
ctlEOF
