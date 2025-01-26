#!/bin/sh

set -eaux

lcdir=/home/peitao/forecast/ca_ss
tmp=/home/peitao/data/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/home/peitao/data/downloads
datadir=/home/peitao/data/ca_prd
#
#
cd $tmp
#
#=======================================
# have OI sst jan1982-cur
#=======================================
outsst=oisst.jan1982-feb2021
times=jan1982
timee=feb2021
#
cat >oisst<<EOF
run haveoisst.gs
EOF
#
cat >haveoisst.gs<<EOF
'reinit'
'sdfopen $datadir0/sst.mon.mean.nc'
'set gxout fwrite'
'set fwrite $outsst.gr'
'set x 1 1440'
'set y 1 720'
'set time '$times' '$timee''
'd sst'
'c'
EOF
#
/usr/bin/grads -l <oisst
#
cat>$outsst.ctl<<EOF
dset ^$outsst.gr
undef -9.99E+8
*
options little_endian
*
XDEF 1440 LINEAR    0.125  0.25
YDEF  720 LINEAR  -89.875  0.25
zdef  01 levels 1
tdef   9999 linear jan1982 1mo
*
VARS 1
sst 1  99   sst
ENDVARS
EOF
#
times=jan1991
timee=feb2021
outsst2=oisst.jan1991-feb2021
cat >intpl<<EOF
run intp.gs
EOF
#
cat >intp.gs<<EOF
'reinit'
'open $outsst.ctl'
'open /home/peitao/utility/intpl/grid.360x180.ctl'
'set gxout fwrite'
'set fwrite $outsst2.gr'
'set lon   0.5 359.5'
'set lat -89.5  89.5'
'set time '$times' '$timee''
'd lterp(sst,sst.2(time=jan1982))'
'c'
EOF
#===========================================
/usr/bin/grads -bl <intpl
#=======================================
#
cat>$outsst2.ctl<<EOF
dset ^$outsst2.gr
*options little_endian
undef -999000000
TITLE  Nr. of Valid Months
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
ZDEF 01 LEVELS 1
tdef 9999 linear jan1991 1mo
VARS 1
sst  0 99     ave
ENDVARS
EOF
#
#=======================================
# have monthly clim 
#=======================================
outfile=mon.clim
#
cat >clim<<EOF
run haveclim.gs
EOF
#
cat >haveclim.gs<<EOF
'reinit'
'open $outsst2.ctl'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set x 1 360'
'set y 1 180'
'set t 1 12'
'define sstc=ave(sst,t+0,t=360,1yr)'
'modify sstc seasonal'
'set t 1 50'
'd sstc'
'c'
EOF
#
grads -l <clim
#
cat>$outfile.ctl<<EOF
dset ^$outfile.gr
*options little_endian
undef -999000000
TITLE  Nr. of Valid Months
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
ZDEF 1 LEVELS 1
tdef 999 linear jan1991 1mo
VARS 1
sst  0 99     clim
ENDVARS
EOF
#
#=======================================
# have monthly and 3-mon
#=======================================
outfile3=clim.hadoisst.3mon.1x1
outfile4=clim.hadoisst.mon.1x1
ts=2
te=49
#
cat >climout<<EOF
run have3mavg.gs
EOF
#
cat >have3mavg.gs<<EOF
'reinit'
'open $outfile.ctl'
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
grads -l <climout
#
cat>$outfile3.ctl<<EOF
dset ^$outfile3.gr
*options little_endian
undef -999000000
TITLE  3mon avg
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
ZDEF 1 LEVELS 1
tdef 999 linear feb1991 1mo
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
tdef 999 linear feb1991 1mo
VARS 1
sst  0 99     anom
ENDVARS
EOF
#
mv $outfile3* $datadir
mv $outfile4* $datadir
