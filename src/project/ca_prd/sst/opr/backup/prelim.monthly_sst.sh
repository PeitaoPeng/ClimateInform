#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/opr
tmp=/cpc/home/wd52pp/tmp/opr2
ftpdir=/home/people/cpc/ftp/wd52pp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
curyr=`date --date='today' '+%Y'`  # yr of making fcst
curmo=`date --date='today' '+%m'`  # mo of making fcst
#
if [ $curmo = 01 ]; then cmon=1; icmon_end=jan; icmoe=1; icmon_mid=dec; fi #icmon_mid: mid mon of icss
if [ $curmo = 02 ]; then cmon=2; icmon_end=feb; icmoe=2 ; icmon_mid=jan; fi
if [ $curmo = 03 ]; then cmon=3; icmon_end=mar; icmoe=3 ; icmon_mid=feb; fi
if [ $curmo = 04 ]; then cmon=4; icmon_end=apr; icmoe=4 ; icmon_mid=mar; fi
if [ $curmo = 05 ]; then cmon=5; icmon_end=may; icmoe=5 ; icmon_mid=apr; fi
if [ $curmo = 06 ]; then cmon=6; icmon_end=jun; icmoe=6 ; icmon_mid=may; fi
if [ $curmo = 07 ]; then cmon=7; icmon_end=jul; icmoe=7 ; icmon_mid=jun; fi
if [ $curmo = 08 ]; then cmon=8; icmon_end=aug; icmoe=8 ; icmon_mid=jul; fi
if [ $curmo = 09 ]; then cmon=9; icmon_end=sep; icmoe=9 ; icmon_mid=aug; fi
if [ $curmo = 10 ]; then cmon=10; icmon_end=oct; icmoe=10; icmon_mid=sep; fi
if [ $curmo = 11 ]; then cmon=11; icmon_end=nov; icmoe=11; icmon_mid=oct; fi
if [ $curmo = 12 ]; then cmon=12; icmon_end=dec; icmoe=12; icmon_mid=nov; fi
#
yyyy=$curyr
yyym=`expr $curyr - 1`
#
icmoyr=$icmon_end$yyyy
#
icyr=$curyr
datadir=/cpc/home/wd52pp/data/season_fcst/ca/$icyr/$curmo
#
cd $tmp
#
#===============have monthly SST climatology
#
sstdir=/cpc/home/wd52pp/data/ca_prd
nts=$cmon
nte=`expr $nts + 18`

cat >clim<<EOF
run casstc.gs
EOF

cat >casstc.gs<<EOFgs
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
'open $sstdir/sst.hadoi.jan1948-cur.mon.tot.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite hadoisst.clim.mon.gr'
'set t 1 12'
'define clim=ave(sst,t+516,t=876,1yr)'
'modify clim seasonal'
'set t $nts $nte'
'd clim'
EOFgs
#
cat>hadoisst.clim.mon.ctl<<EOF
dset ^hadoisst.clim.mon.gr
undef -9.99E+08
title EXP1
XDEF  360 LINEAR   0.5   1.0
YDEF  180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef 12 linear $icmoyr 1mon
edef 1  names 1
vars  1
t  1 99 sst
endvars
EOF
#
/usr/local/bin/grads -bl <clim
#
cp $lcdir/prelim.monthly_sst.f $tmp/casst.f
#
cat > parm.h << eof
c
      parameter(imx=360,jmx=180)
      parameter(nld=17,nesm=12)
eof
#
gfortran -o casst.x casst.f
echo "done compiling"

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi
#
eof_range=tp_ml
ifile=11
for msic in 1 2 3 4; do
for modemax in 15 25 40; do
#
ln -s $datadir/prelim_ca_prd.sst.${eof_range}.$modemax.${msic}ics.mon.gr fort.$ifile
#
ifile=`expr $ifile + 1` 
#
done  # maxmode
done  # msics
#
ln -s hadoisst.clim.mon.gr fort.31
ln -s sst.curmon.anom.gr   fort.32
#
ln -s $datadir/casst_ens_${icmoyr}_anomaly_prelim.gr  fort.61
ln -s $datadir/casst_ens_${icmoyr}_prelim.gr fort.62
#
./casst.x > $datadir/prelim.monthly_sst.out
#
cat>$datadir/casst_ens_${icmoyr}_prelim.ctl<<EOF
dset ^casst_ens_${icmoyr}_prelim.gr
undef -9.99E+08
title EXP1
XDEF  360 LINEAR   0.5   1.0
YDEF  180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef 15 linear $icmoyr 1mon
vars  1
sst  1 99 t=1:ic; t=2-15: lead=0-13
endvars
EOF
#
cat>$datadir/casst_ens_${icmoyr}_anomaly_prelim.ctl<<EOF
dset ^casst_ens_${icmoyr}_anomaly_prelim.gr
undef -9.99E+08
title EXP1
XDEF  360 LINEAR   0.5   1.0
YDEF  180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef 15 linear $icmoyr 1mon
vars  1
sst  1 99 t=1:ic; t=2-15: lead=0-13
endvars
EOF
#
scp $datadir/casst_ens_${icmoyr}* wd52pp@vm-lnx-rzdm04:$ftpdir/.
