#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
curyr=`date --date='today' '+%Y'`  # yr of making fcst
#curmo=`date --date='today' '+%m'`  # mo of making fcst
curmo=11
datadir=/cpc/home/wd52pp/data/season_fcst/ca/$curyr/$curmo
#
if [ $curmo = 01 ]; then cmon=1; icmon_end=dec; icmoe=12; icmon_mid=nov; icssnmb=10; fi #icmon_mid: mid mon of icss
if [ $curmo = 02 ]; then cmon=2; icmon_end=jan; icmoe=1 ; icmon_mid=dec; icssnmb=11; fi #icssnmb: 1st mon of icss
if [ $curmo = 03 ]; then cmon=3; icmon_end=feb; icmoe=2 ; icmon_mid=jan; icssnmb=12 ; fi
if [ $curmo = 04 ]; then cmon=4; icmon_end=mar; icmoe=3 ; icmon_mid=feb; icssnmb=1 ; fi
if [ $curmo = 05 ]; then cmon=5; icmon_end=apr; icmoe=4 ; icmon_mid=mar; icssnmb=2; fi
if [ $curmo = 06 ]; then cmon=6; icmon_end=may; icmoe=5 ; icmon_mid=apr; icssnmb=3; fi
if [ $curmo = 07 ]; then cmon=7; icmon_end=jun; icmoe=6 ; icmon_mid=may; icssnmb=4; fi
if [ $curmo = 08 ]; then cmon=8; icmon_end=jul; icmoe=7 ; icmon_mid=jun; icssnmb=5; fi
if [ $curmo = 09 ]; then cmon=9; icmon_end=aug; icmoe=8 ; icmon_mid=jul; icssnmb=6; fi
if [ $curmo = 10 ]; then cmon=10; icmon_end=sep; icmoe=9 ; icmon_mid=aug; icssnmb=7; fi
if [ $curmo = 11 ]; then cmon=11; icmon_end=oct; icmoe=10; icmon_mid=sep; icssnmb=8; fi
if [ $curmo = 12 ]; then cmon=12; icmon_end=nov; icmoe=11; icmon_mid=oct; icssnmb=9; fi
yyyy=$curyr
yyym=`expr $curyr - 1`
#
icmomidyr=$icmon_mid$yyyy
if [ $cmon -le 2 ]; then icmomidyr=$icmon_mid$yyym; fi
#
cd $tmp
#
#===============have SST climatology
#
sstdir=/cpc/home/wd52pp/data/ca_prd
nts=`expr $cmon + 9`  #align clim season to fcst season
nte=`expr $nts + 18`

for sst_analysis in ersst hadoisst; do

cat >clim<<EOF
run casstc.gs
EOF

cat >casstc.gs<<EOFgs
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
'open $sstdir/clim.${sst_analysis}.3mon.1x1.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite $sstdir/${sst_analysis}.clim.4ca.gr'
'set t $nts $nte'
'd sst'
EOFgs
/usr/local/bin/grads -l <clim
done
#
cp $lcdir/realtime.nino34.f $tmp/nino34.f
#
cat > parm.h << eof
c
      parameter(imx=360,jmx=180)
      parameter(nld=17,nesm=12)
eof
#
gfortran -o nino34.x nino34.f
echo "done compiling"

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi
#
eof_range=tp_ml
ifile=11
for sst_analysis in ersst hadoisst; do
for msic in 1 2 3 4; do
for modemax in 15 25 40; do
#
ln -s $datadir/real_ca_prd.sst.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr fort.$ifile
#
ifile=`expr $ifile + 1` 
#
done  # maxmode
done  # msics
done  # sst_analysis
#
ln -s $sstdir/ersst.clim.4ca.gr fort.61
ln -s $sstdir/hadoisst.clim.4ca.gr fort.62
ln -s $datadir/ca.ersst.nino34.gr fort.71
ln -s $datadir/ca.hadoisst.nino34.gr fort.72
#
nino34.x > $datadir/ca.nino34.out
#
cat>$datadir/ca.ersst.nino34.ctl<<EOF
dset ^ca.ersst.nino34.gr
undef -9.99E+33
title EXP1
XDEF  1 LINEAR    0  1.0
YDEF  1 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef 17 linear $icmomidyr 1mon
edef 13 names 1 2 3 4 5 6 7 8 9 10 11 12 mean
vars  2
a  1 99 anom nino34 sst
t  1 99 total nino34 sst
endvars
#
EOF
cat>$datadir/ca.hadoisst.nino34.ctl<<EOF
dset ^ca.hadoisst.nino34.gr
undef -9.99E+33
title EXP1
XDEF  1 LINEAR    0  1.0
YDEF  1 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef 17 linear $icmomidyr 1mon
edef 13 names 1 2 3 4 5 6 7 8 9 10 11 12 mean
vars  2
a  1 99 anom nino34 sst
t  1 99 total nino34 sst
endvars
#
EOF
cat>$datadir/ersst.clim.ctl<<EOF
dset ^ersst.clim.gr
undef -9.99E+08
title EXP1
XDEF  360 LINEAR   0.5   1.0
YDEF  180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef 12 linear $icmomidyr 1mon
edef 1  names 1
vars  1
t  1 99 sst
endvars
#
EOF
cat>$datadir/hadoisst.clim.ctl<<EOF
dset ^hadoisst.clim.gr
undef -9.99E+08
title EXP1
XDEF  360 LINEAR   0.5   1.0
YDEF  180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef 12 linear $icmomidyr 1mon
edef 1  names 1
vars  1
t  1 99 sst
endvars
#
EOF
