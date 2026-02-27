#!/bin/sh

set -eaux

lcdir=/home/peitao/forecast/ca_ss
tmp=/home/peitao/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/home/peitao/data/downloads
datadir=/home/peitao/data/ca_prd
#
cd $tmp
#
 sst_analysis=ersst
#
clm_bgn=1644  #dec1990
clm_end=`expr $clm_bgn + 360`
#
#=======================================
# have monthly clim
#=======================================#=======================================
cat >clim<<EOF
run haveclim.gs
EOF
cat >haveclim.gs<<EOF
'reinit'
'sdfopen $datadir0/sst.mnmean.nc'
'set x 1 180'
'set y 1  89'
'set t 1 12'
*wmo clim 1991-2020
'define clm=ave(sst,t+$clm_bgn, t=$clm_end,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite clim.gr'
'set t 1 50'
'd clm'
'c'
EOF
#
/usr/bin/grads -l <clim
#
cat>clim.ctl<<EOF
dset ^clim.gr
undef -999000000
*
TITLE SST
*
xdef  180 linear   0. 2.
ydef   89 linear -89. 2.
zdef   01 levels 1
tdef   9999 linear jan1948 1mo
vars 1
sst  1 99 3-mon mean (C)
ENDVARS
EOF
#
#=======================================
# regrid to 1x1
#=======================================
cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open clim.ctl'
'open /home/peitao/utility/intpl/grid.360x180.ctl'
'set gxout fwrite'
'set fwrite clim.1x1.gr'
nt=1
ntend=50
while ( nt <= ntend)

'set t 'nt
say 'time='nt
'set lon   0.5 359.5'
'set lat -89.5  89.5'
'd lterp(sst,sst.2(time=jan1982))'

nt=nt+1
endwhile
gsEOF

/usr/bin/grads -pb <int

cat>clim.1x1.ctl<<EOF
dset ^clim.1x1.gr
undef -9.99E+8
*
options little_endian
*
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  01 levels 1 
tdef  999 linear jan1981 1mo
*
VARS 1
sst 1  99   sst
ENDVARS
EOF
#
#
#=======================================
# have monthly and 3-mon
#=======================================
outfile3=clim.ersst.3mon.1x1
outfile4=clim.ersst.mon.1x1
ts=2
te=49
#
cat >climout<<EOF
run have3mavg.gs
EOF
#
cat >have3mavg.gs<<EOF
'reinit'
'open clim.1x1.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite $outfile3.gr'
'set t '$ts' '$te''
'd ave(sst,t-1,t+1)'
'c'
'disable fwrite'
'set gxout fwrite'
'set fwrite $outfile4.gr'
'set t '$ts' '$te''
'd sst'
'c'
EOF
#
/usr/bin/grads -l <climout
#
cat>$outfile3.ctl<<EOF
dset ^$outfile3.gr
*options little_endian
undef -999000000
TITLE  3mon avg
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
ZDEF 1 LEVELS 1
tdef 999 linear feb1981 1mo
VARS 1
sst  0 99     anom
ENDVARS
EOF
#
cat>$outfile4.ctl<<EOF
dset ^$outfile4.gr
*options little_endian
undef -999000000
TITLE  3mon avg
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
ZDEF 1 LEVELS 1
tdef 999 linear feb1981 1mo
VARS 1
sst  0 99     anom
ENDVARS
EOF
#
mv $outfile3* $datadir
mv $outfile4* $datadir
