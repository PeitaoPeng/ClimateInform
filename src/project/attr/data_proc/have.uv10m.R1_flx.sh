#!/bin/sh

set -eaux

# have uv10m from R1

tmp=/cpc/home/wd52pp/tmp
cd $tmp
#\rm *gs
#
var=UGRD
vout=u10m
ts=361
tmax=852 #71yr*12mon

cat >int<<fEOF
run temp.gs
fEOF

cat >temp.gs<<EOF
    'reinit'
    'set display color white'
    'c'
* open ctl file
    'open /cpc/analysis/cdas/month/flux/mean/flx.gau.grib.mean.y1949-cur.ctl'
    'set x 1 192'
    'set y 1 94'
    'set gxout fwrite'
    'set fwrite $vout.R1.gau.gr'
* for 34-year run
    nt=$ts
    while(nt<=$tmax)
    'set t 'nt''
*
    'd $var'
*
    nt=nt+1
    endwhile
EOF
 
/cpc/home/wd52pp/bin/grads -p <int

#$mv grads.fwrite $vout.R1.gau.gr

cat>$vout.R1.gau.ctl<<EOF
dset ^$vout.R1.gau.gr
undef 9.999E+20
*
options little_endian
*
xdef   192 linear    0.000  1.875
ydef    94 levels
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
tdef 9999 linear 00Z01jan1979 1mo
zdef 1 levels 1
*
VARS 1
z 1  99   $vout
ENDVARS
EOF

#mv $vout.R1.gau.ctl $datadir

