#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/cpc/analysis/verif/ocean/sst/oi/ctl
datadir=/cpc/home/wd52pp/data/ca_prd
outdata=/cpc/home/wd52pp/data/casst
#
latest_mon=aug2016  #the end-mon of latest IC season
icmon_mid=jul2016   #the mid-mon of latest IC season
icseason=6  # jfm=1
tmax=824  # 816=dec2015
nyear=68 # 1948-2015
#
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10 
kocn=15

cd $tmp
#
#================================================
# have IC daily SST from R1(CDAS) data
#================================================
#
analdir=/cpc/analysis/cdas/rot_6hrly
bindir=/cpc/home/wd52pp/bin
#
cd $tmp
rm -f sstgrb*
#
YEAR=`date --date='2 day ago' '+%Y'`
MONTH=`date --date='2 day ago' '+%m'`
DAY=`date --date='2 day ago' '+%d'`
iday=$DAY
dd1=`echo $DAY|cut -c 1-1`
dd2=`echo $DAY|cut -c 2-2`
if [ "$dd1" -eq 0 ]; then iday=$dd2; fi
echo "iday=" $iday
#
cp $analdir/sstgrb${YEAR}${MONTH}*00 $tmp
#
cat sstgrb* > sstgrball

set +e   #recover the environment 
$bindir/grib2ctl.pl sstgrball > sstgrball.ctl
echo "iday=" $iday
$bindir/gribmap -0  -i sstgrball.ctl
set -e   #take off the environment

#
echo "iday=" $iday
#
cat >readsst<<EOF
run read.gs
EOF
cat >read.gs<<EOF
'reinit'
'open sstgrball.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite sst.gr'
'set t 1 'iday''
'd TMPsfc'
'c'
EOF
#
echo "iday=" $iday
$bindir/grads -bl < readsst
#
#======================================
# define some parameters
#======================================
sst_analysis=hadoisst
#
#for eof_range in tp_ml tp_np; do
for eof_range in tp_ml; do
#
#eof_range=tp_np   #30S-60N
#eof_range=tp_ml   #45S-45N
#
if [ $eof_range = tp_np ]; then neoflat=92; eoflats=-30.5; lats=60; late=151; ngrd=20700; fi
if [ $eof_range = tp_ml ]; then neoflat=92; eoflats=-45.5; lats=45; late=136; ngrd=23414; fi
#
#======================================
# have ic data
#======================================
outfile=${sst_analysis}.msic.ic
cat >haveic<<EOF
run sstic.gs
EOF
ic1=`expr $tmax - 2`
ic2=`expr $ic1 - 3`
ic3=`expr $ic1 - 6`
ic4=`expr $ic1 - 9`
cat >sstic.gs<<EOF
'reinit'
'open $datadir/$outfile3.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite $datadir/$outfile.gr'
'set t $ic1'
'd t'
'set t $ic2'
'd t'
'set t $ic3'
'd t'
'set t $ic4'
'd t'
'c'
EOF
#
grads -l <haveic
#
cat>$datadir/$outfile.ctl<<EOF
dset ^$outfile.gr
undef -999000000
*
TITLE Tsfc
*
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef   1 linear 1 1
tdef   9999 linear jan2015 1mo
vars 1
t  1 99 3-mon mean (C)
ENDVARS
EOF
#
nps=11     #width of data window in season
nwextb=10  # 3mon season number to be extended at begining of a row of the array
nwexte=10  # 3mon season number to be extended at the end of a row of the array
runeof=1 # 0: read in ; 1: run eof
nseason=`expr $nyear - 2` #for eof and ca analysis
#
mlead=10  #maximum lead
mldp=`expr $mlead + 1` 
#
#for msic in 1 2 3 4; do
#for modemax in 15 25 40; do
for msic in 1; do
for modemax in 15; do
#
cp $lcdir/realtime.ca_msic.season.sst.f $tmp/sst_prd.f
cp $lcdir/eof_4_ca.s.f $tmp/eof_4_ca.s.f

#
cat > parm.h << eof
      parameter(nruneof=$runeof)
c
      parameter(ims=360,jms=180)   !input sst dimension
c
      parameter(lons=1,lone=360)   !lon range for EOFs analysis (0-360)
      parameter(eoflats=$eoflats,lats=$lats,late=$late)  !lat range for EOFs analysis (25S-65N)
      parameter(imp=lone-lons+1,jmp=late-lats+1)
c
      parameter(modemax=$modemax)
      parameter(nyear=$nyear)
      parameter(nseason=$nseason)
      parameter(nps=$nps)
      parameter(nwextb=$nwextb)
      parameter(nwexte=$nwexte)
c
      parameter(kocn=$kocn)
      parameter(ndec=$ndec)
      parameter(itgtm=$icseason)
      parameter(mlead=$mlead)
      parameter(mldp=$mldp)
      parameter(ngrd=$ngrd)
      parameter(msic=$msic)
eof
#
gfortran -o ca.x sst_prd.f eof_4_ca.s.f
echo "done compiling"

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi
#
ln -s $datadir/${sst_analysis}.msic.ic.gr fort.10
ln -s $datadir/${sst_analysis}.3mon.1948-curr.1x1.gr fort.11
#
ln -s $outdata/eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.gr fort.70
#
ln -s $outdata/real_ca_prd.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr fort.85
ln -s $outdata/real_ca_weights.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr fort.86
#
#ca.x > $outdata/realtime.${sst_analysis}.${eof_range}.$modemax.${msic}ics.out
 ca.x 
#
cat>$outdata/eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.ctl<<EOF
dset ^eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.gr
undef -9.99E+33
title EXP1
xdef  360 linear   0. 2.
ydef  $neoflat linear $eoflats 2.
zdef  1 linear 1 1
tdef  99 linear jan1949 1mon
vars  1
eof   1 999 constructed
endvars
EOF
#
cat>$outdata/real_ca_prd.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.ctl<<EOF
dset ^real_ca_prd.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr
undef -9.99E+33
title EXP1
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  $mldp linear $icmon_mid 1mon
vars  5
sst   1 99 sst prd
sdo   1 99 std of obs
sdf   1 99 std of fcst
ac    1 99 ac skill
rms   1 99 rms skill
endvars
EOF
#
cat>$outdata/real_ca_weights.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.ctl<<EOF
dset ^real_ca_weights.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr
undef -9.99E+33
title EXP1
XDEF  $nseason LINEAR    0  1.0
YDEF  1 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  1 linear $icmon_mid 1mon
vars  1
wt    1 99 CA weights
endvars
EOF
done  # maxmode
done  # msics
done  # eof_range
