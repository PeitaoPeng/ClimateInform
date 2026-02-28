#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/opr
tmp=/cpc/home/wd52pp/tmp
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
nyear=`expr $curyr - 1948`  # total full year data used for CA, 68 for 1948-2015
if [ $cmon -le 1 ]; then nyear=`expr $curyr - 1948 - 1`; fi #for having 12 3-mon avg data for past year
#
nseason=`expr $nyear - 3` #for eof and ca analysis
#
icyr=$curyr
datadir=/cpc/home/wd52pp/data/season_fcst/ca/$icyr/$curmo
#
cd $tmp
#
cp $lcdir/prelim.weight_avg.f $tmp/weight_avg.f
#
cat > parm.h << eof
c
      parameter(nseason=$nseason)
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
for msic in 1 2 3 4; do
for modemax in 15 25 40; do
#
ln -s $datadir/prelim_ca_weights.tp_ml.$modemax.${msic}ics.3mon.gr fort.$ifile
#
ifile=`expr $ifile + 1` 
#
done  # maxmode
done  # msics
#
weight.x > $datadir/prelim.ca_weight_avg.tp_ml.out
#
