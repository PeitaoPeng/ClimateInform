#!/bin/sh

set -eaux

#=========================================================
# read data from CORE reanalysis and regrid to 2.5x2.5 
#=========================================================
lcdir=/cpc/home/wd52pp/project/modes/proc_data
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

datain=/cpc/cfsr/reanalyses/corefv3/ens_mean/mon/pgb
dataout=/cpc/consistency/telecon
#
cd $tmp
#
var=hgtprs
level=500
#
yys=1950
yye=2020
totyr=`expr $yye - $yys + 1`
#
totmon=`expr $totyr \* 12`
data_bgn=jan$yys 
data_end=dec$yye
#
filein=pgb
outfile=corefv3.z500.jan1950-dec2020
#
undef_data=-9.99E+8
#
imx=512
jmx=256
#=======================================
# process sst data
#=======================================
cat >havedata<<EOF
run data_rewrite.gs
EOF
#
cat >data_rewrite.gs<<EOF
'open $datain/$filein.ctl'
'set x 1 512'
'set y 1 256'
'set lev $level'
'set gxout fwrite'
'set fwrite $outfile.gr'
it=1
while ( it <= $totmon)
'd ${var}(t='it')'
it=it+1
endwhile
'c'
EOF
#
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
title CORe monthly pgb files in Gaussian grid
xdef 512 linear 0.000000 0.703125
ydef 256 levels
 -89.463 -88.767 -88.067 -87.366 -86.665 -85.963 -85.262 -84.560 -83.859 -83.157 -82.455 -81.754 -81.052 -80.350
 -79.649 -78.947 -78.245 -77.543 -76.842 -76.140 -75.438 -74.736 -74.035 -73.333 -72.631 -71.929 -71.228 -70.526
 -69.824 -69.123 -68.421 -67.719 -67.017 -66.316 -65.614 -64.912 -64.210 -63.509 -62.807 -62.105 -61.403 -60.702
 -60.000 -59.298 -58.596 -57.895 -57.193 -56.491 -55.789 -55.088 -54.386 -53.684 -52.982 -52.281 -51.579 -50.877
 -50.175 -49.474 -48.772 -48.070 -47.368 -46.667 -45.965 -45.263 -44.561 -43.860 -43.158 -42.456 -41.754 -41.053
 -40.351 -39.649 -38.947 -38.246 -37.544 -36.842 -36.140 -35.439 -34.737 -34.035 -33.333 -32.632 -31.930 -31.228
 -30.526 -29.824 -29.123 -28.421 -27.719 -27.017 -26.316 -25.614 -24.912 -24.210 -23.509 -22.807 -22.105 -21.403
 -20.702 -20.000 -19.298 -18.596 -17.895 -17.193 -16.491 -15.789 -15.088 -14.386 -13.684 -12.982 -12.281 -11.579
 -10.877 -10.175  -9.474  -8.772  -8.070  -7.368  -6.667  -5.965  -5.263  -4.561  -3.860  -3.158  -2.456  -1.754
  -1.053  -0.351   0.351   1.053   1.754   2.456   3.158   3.860   4.561   5.263   5.965   6.667   7.368   8.070
   8.772   9.474  10.175  10.877  11.579  12.281  12.982  13.684  14.386  15.088  15.789  16.491  17.193  17.895
  18.596  19.298  20.000  20.702  21.403  22.105  22.807  23.509  24.210  24.912  25.614  26.316  27.017  27.719
  28.421  29.123  29.824  30.526  31.228  31.930  32.632  33.333  34.035  34.737  35.439  36.140  36.842  37.544
  38.246  38.947  39.649  40.351  41.053  41.754  42.456  43.158  43.860  44.561  45.263  45.965  46.667  47.368
  48.070  48.772  49.474  50.175  50.877  51.579  52.281  52.982  53.684  54.386  55.088  55.789  56.491  57.193
  57.895  58.596  59.298  60.000  60.702  61.403  62.105  62.807  63.509  64.210  64.912  65.614  66.316  67.017
  67.719  68.421  69.123  69.824  70.526  71.228  71.929  72.631  73.333  74.035  74.736  75.438  76.140  76.842
  77.543  78.245  78.947  79.649  80.350  81.052  81.754  82.455  83.157  83.859  84.560  85.262  85.963  86.665
  87.366  88.067  88.767  89.463
tdef 852 linear 00Z01jan1950 1mo
zdef 1 levels 500
vars 1
z   0 99   z500
endvars
EOF
#
/usr/local/bin/grads -bl <havedata
#
#=======================================
# regrid to 2.5x2.5
#=======================================
cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $outfile.ctl'
'open /cpc/home/wd52pp/data/obs/R1/s200.djf.1980-cur.ctl'
'set gxout fwrite'
'set fwrite $outfile.2.5x2.5.gr'
nt=1
while ( nt <= $totmon)

'set t 'nt
say 'time='nt
'set lon   0. 357.5'
'set lat -90.  90.'
'd lterp(z,s.2(time=jan1981))'

nt=nt+1
endwhile
gsEOF
#
/usr/local/bin/grads -pb <int
#
cat>$outfile.2.5x2.5.ctl<<EOF
dset ^$outfile.2.5x2.5.gr
undef -9.99E+8
*
options little_endian
*
XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
zdef  01 levels 1 
tdef   9999 linear jan$yys 1mo
*
VARS 1
z   0 99   monthly ave
ENDVARS
EOF
mv $outfile.* $dataout
