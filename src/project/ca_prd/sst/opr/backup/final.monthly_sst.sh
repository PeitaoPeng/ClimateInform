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
if [ $curmo = 01 ]; then cmon=1; icmon_end=dec; icmoe=12; icmon_mid=nov; icssnmb=10; fi #icmon_mid: mid mon of icss
if [ $curmo = 02 ]; then cmon=2; icmon_end=jan; icmoe=01 ; icmon_mid=dec; icssnmb=11; fi #icssnmb: 1st mon of icss
if [ $curmo = 03 ]; then cmon=3; icmon_end=feb; icmoe=02 ; icmon_mid=jan; icssnmb=12 ; fi
if [ $curmo = 04 ]; then cmon=4; icmon_end=mar; icmoe=03 ; icmon_mid=feb; icssnmb=1 ; fi
if [ $curmo = 05 ]; then cmon=5; icmon_end=apr; icmoe=04 ; icmon_mid=mar; icssnmb=2; fi
if [ $curmo = 06 ]; then cmon=6; icmon_end=may; icmoe=05 ; icmon_mid=apr; icssnmb=3; fi
if [ $curmo = 07 ]; then cmon=7; icmon_end=jun; icmoe=06 ; icmon_mid=may; icssnmb=4; fi
if [ $curmo = 08 ]; then cmon=8; icmon_end=jul; icmoe=07 ; icmon_mid=jun; icssnmb=5; fi
if [ $curmo = 09 ]; then cmon=9; icmon_end=aug; icmoe=08 ; icmon_mid=jul; icssnmb=6; fi
if [ $curmo = 10 ]; then cmon=10; icmon_end=sep; icmoe=09 ; icmon_mid=aug; icssnmb=7; fi
if [ $curmo = 11 ]; then cmon=11; icmon_end=oct; icmoe=10; icmon_mid=sep; icssnmb=8; fi
if [ $curmo = 12 ]; then cmon=12; icmon_end=nov; icmoe=11; icmon_mid=oct; icssnmb=9; fi
#
icyr=$curyr
if [ $icmoe = 12 ]; then icyr=`expr $curyr - 1`; fi
outd=/cpc/home/wd52pp/data/season_fcst/ca/$icyr
outdata=${outd}/$icmoe
if [ ! -d $outd ] ; then
  mkdir -p $outd
fi
if [ ! -d $outdata ] ; then
  mkdir -p $outdata
fi
datadir=$outdata
#
icmoyr=${icmon_end}$icyr
#
cd $tmp
#
#===============have monthly SST climatology
#
sstdir=/cpc/home/wd52pp/data/ca_prd
nts=$icmoe
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
*'define clim=ave(sst,t+396,t=756,1yr)'
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
ln -s $datadir/final_ca_prd.sst.${eof_range}.$modemax.${msic}ics.mon.gr fort.$ifile
#
ifile=`expr $ifile + 1` 
#
done  # maxmode
done  # msics
#
ln -s hadoisst.clim.mon.gr fort.31
ln -s sst.latestmon.anom.gr   fort.32
#
ln -s $datadir/casst_ens_${icmoyr}_anomaly_final.gr  fort.61
ln -s $datadir/casst_ens_${icmoyr}_final.gr fort.62
#
./casst.x > $datadir/final.monthly_sst.out
#
cat>$datadir/casst_ens_${icmoyr}_final.ctl<<EOF
dset ^casst_ens_${icmoyr}_final.gr
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
cat>$datadir/casst_ens_${icmoyr}_anomaly_final.ctl<<EOF
dset ^casst_ens_${icmoyr}_anomaly_final.gr
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
