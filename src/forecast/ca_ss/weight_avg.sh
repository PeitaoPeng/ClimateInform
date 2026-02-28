#!/bin/sh

set -eaux

lcdir=/home/ppeng/src/forecast/ca_ss
tmp=/home/ppeng/data/tmp
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
nyear=`expr $curyr - 1948`  # total full year data used for CA, 68 for 1948-2015
if [ $cmon -le 2 ]; then nyear=`expr $curyr - 1948 - 1`; fi #for having 12 3-mon avg data for past year
nseason=`expr $nyear - 2` #for eof and ca analysis
caendyr=`expr $curyr - 1` #end year for IC_CA
#
icyr=$curyr
if [ $icmoe = 12 ]; then icyr=`expr $curyr - 1`; fi
datadir=/home/ppeng/data/ss_fcst/ca/$icyr/$icmoe
#
cd $tmp
#
for eof_range in tp_ml; do
#
cp $lcdir/weight_avg.f $tmp/weight_avg.f
#
cat > parm.h << eof
c
      parameter(nseason=$nseason)
      parameter(caendyr=$caendyr)
      parameter(nsst=2)
      parameter(nsic=4)
      parameter(nmod=3)
eof
#
gfortran -o weight.x weight_avg.f
echo "done compiling"

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi
#
ifile=11
for sst_analysis in ersst hadoisst; do
for msic in 1 2 3 4; do
for modemax in 15 25 40; do
#
ln -s $datadir/real_ca_weights.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr fort.$ifile
#
ifile=`expr $ifile + 1` 
#
done  # maxmode
done  # msics
done  # sst_analysis
#
ln -s $datadir/ca_weight_avg.${eof_range}.gr fort.85
#
./weight.x > $datadir/ca_weight_avg.${eof_range}.out
#
cat>$datadir/ca_weight_avg.${eof_range}.ctl<<EOF
dset ^ca_weight_avg.${eof_range}.gr
undef -9.99E+33
title EXP1
XDEF  $nseason LINEAR    0  1.0
YDEF  3 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  4 linear jan2016 1mon
vars  2
er  1 99 ersst
had 1 99 hadsst
endvars
#
EOF

done  # eof_range
