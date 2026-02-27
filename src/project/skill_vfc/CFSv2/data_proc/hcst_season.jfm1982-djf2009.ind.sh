#!/bin/sh

set -eaux

# get 0.5-month lead seasonal forecast from from Wang's archive

#var=T2m
 var=Prec

#
datadir=/cpc/cfsr1/CFSv2/CFSv2HCST4FCST/$var
tmp=/export/hobbes/wd52pp/tmp
 
cd $tmp
#
cat >int<<fEOF
reinit
run temp.gs
fEOF

#  --------------------------------
cat >temp.gs<<EOF
    'reinit'
    'set display color white'
    'c'
* open ctl file
    'open $datadir/CFSv2$var.ctl'
    'set gxout fwrite'
    'set x 1 384'
    'set y 1 190'
*
* have jfm1982 with e=3-7 and z=1-3, because e8-10 are not available for jan1982
*
    nt=1
    'set t 'nt''
    ne=3
    while(ne<=7)
    'set e 'ne''
* z=2: 1-month lead, for the first month of the season
    'set z 1'
    'define m1a=f00'
    'define m1b=f06'
    'define m1c=f12'
    'define m1d=f18'
* z=3: 2-month lead, for the second month of the season
    'set z 2'
    'define m2a=f00'
    'define m2b=f06'
    'define m2c=f12'
    'define m2d=f18'
* z=4: 3-month lead, for the third month of the season
    'set z 3'
    'define m3a=f00'
    'define m3b=f06'
    'define m3c=f12'
    'define m3d=f18'
    'd (m1a+m2a+m3a)/3.'
    'd (m1b+m2b+m3b)/3.'
    'd (m1c+m2c+m3c)/3.'
    'd (m1d+m2d+m3d)/3.'
    ne=ne+1
    endwhile
*
* have fma1982-djf2009 (with dec in 2009) with e=6-10 and z=1-3
*
    nt=2
    while(nt<=336)
    'set t 'nt''
*
    ne=6
    while(ne<=10)
    'set e 'ne''
* z=2: 1-month lead, for the first month of the season
    'set z 1'
    'define m1a=f00'
    'define m1b=f06'
    'define m1c=f12'
    'define m1d=f18'
* z=3: 2-month lead, for the second month of the season
    'set z 2'
    'define m2a=f00'
    'define m2b=f06'
    'define m2c=f12'
    'define m2d=f18'
* z=4: 3-month lead, for the third month of the season
    'set z 3'
    'define m3a=f00'
    'define m3b=f06'
    'define m3c=f12'
    'define m3d=f18'
    'd (m1a+m2a+m3a)/3.'
    'd (m1b+m2b+m3b)/3.'
    'd (m1c+m2c+m3c)/3.'
    'd (m1d+m2d+m3d)/3.'
    ne=ne+1
    endwhile
*
    nt=nt+1
    endwhile
*
EOF

/export/wesley/wd51we/grib2_util/grads2a8.3 -pb <int

mv grads.fwrite ${var}_hcst.jfm1982-djf2009.ind.gr

cat>$tmp/${var}_hcst.jfm1982-djf2009.ind.ctl<<EOF2
dset ^${var}_hcst.jfm1982-djf2009.ind.gr
undef -99999.00
options little_endian
*
xdef 384 linear 0.000000 0.9375
ydef 190 levels
 -89.277 -88.340 -87.397 -86.454 -85.509 -84.565 -83.620 -82.676 -81.731 -80.786 -79.841 -78.897 -77.952 -77.007
 -76.062 -75.117 -74.173 -73.228 -72.283 -71.338 -70.393 -69.448 -68.503 -67.559 -66.614 -65.669 -64.724 -63.779
 -62.834 -61.889 -60.945 -60.000 -59.055 -58.110 -57.165 -56.220 -55.275 -54.330 -53.386 -52.441 -51.496 -50.551
 -49.606 -48.661 -47.716 -46.771 -45.827 -44.882 -43.937 -42.992 -42.047 -41.102 -40.157 -39.212 -38.268 -37.323
 -36.378 -35.433 -34.488 -33.543 -32.598 -31.653 -30.709 -29.764 -28.819 -27.874 -26.929 -25.984 -25.039 -24.094
 -23.150 -22.205 -21.260 -20.315 -19.370 -18.425 -17.480 -16.535 -15.590 -14.646 -13.701 -12.756 -11.811 -10.866
  -9.921  -8.976  -8.031  -7.087  -6.142  -5.197  -4.252  -3.307  -2.362  -1.417  -0.472   0.472   1.417   2.362
   3.307   4.252   5.197   6.142   7.087   8.031   8.976   9.921  10.866  11.811  12.756  13.701  14.646  15.590
  16.535  17.480  18.425  19.370  20.315  21.260  22.205  23.150  24.094  25.039  25.984  26.929  27.874  28.819
  29.764  30.709  31.653  32.598  33.543  34.488  35.433  36.378  37.323  38.268  39.212  40.157  41.102  42.047
  42.992  43.937  44.882  45.827  46.771  47.716  48.661  49.606  50.551  51.496  52.441  53.386  54.330  55.275
  56.220  57.165  58.110  59.055  60.000  60.945  61.889  62.834  63.779  64.724  65.669  66.614  67.559  68.503
  69.448  70.393  71.338  72.283  73.228  74.173  75.117  76.062  77.007  77.952  78.897  79.841  80.786  81.731
  82.676  83.620  84.565  85.509  86.454  87.397  88.340  89.277
*
ZDEF 1 LEVELS 1
*
TDEF 999 LINEAR Jan1982 1mo
*
*
VARS 20
f1  1   99   e1
f2  1   99   e1
f3  1   99   e1
f4  1   99   e1
f5  1   99   e2
f6  1   99   e2
f7  1   99   e2
f8  1   99   e2
f9  1   99   e3
f10 1   99   e3
f11 1   99   e3
f12 1   99   e3
f13 1   99   e4
f14 1   99   e4
f15 1   99   e4
f16 1   99   e4
f17 1   99   e5
f18 1   99   e5
f19 1   99   e5
f20 1   99   e5
ENDVARS
EOF2

mv ${var}_hcst.jfm1982-djf2009.ind.gr /export-12/cacsrv1/wd52pp/CFSv2_vfc/0data
mv ${var}_hcst.jfm1982-djf2009.ind.ctl /export-12/cacsrv1/wd52pp/CFSv2_vfc/0data
