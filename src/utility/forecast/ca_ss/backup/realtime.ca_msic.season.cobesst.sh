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
cd $tmp
#
#======================================
# have SST IC
#======================================
curyr=`date --date='today' '+%Y'`  # yr of making fcst
curmo=`date --date='today' '+%m'`  # mo of making fcst
#
if [ $curmo = 01 ]; then cmon=1; icmoe=12; icmon_mid=nov; icssnmb=10; fi #icmon_mid: mid mon of icss
if [ $curmo = 02 ]; then cmon=2; icmoe=01 ; icmon_mid=dec; icssnmb=11; fi #icssnmb: 1st mon of icss
if [ $curmo = 03 ]; then cmon=3; icmoe=02 ; icmon_mid=jan; icssnmb=12 ; fi
if [ $curmo = 04 ]; then cmon=4; icmoe=03 ; icmon_mid=feb; icssnmb=1 ; fi
if [ $curmo = 05 ]; then cmon=5; icmoe=04 ; icmon_mid=mar; icssnmb=2; fi
if [ $curmo = 06 ]; then cmon=6; icmoe=05 ; icmon_mid=apr; icssnmb=3; fi
if [ $curmo = 07 ]; then cmon=7; icmoe=06 ; icmon_mid=may; icssnmb=4; fi
if [ $curmo = 08 ]; then cmon=8; icmoe=07 ; icmon_mid=jun; icssnmb=5; fi
if [ $curmo = 09 ]; then cmon=9; icmoe=08 ; icmon_mid=jul; icssnmb=6; fi
if [ $curmo = 10 ]; then cmon=10; icmoe=09 ; icmon_mid=aug; icssnmb=7; fi
if [ $curmo = 11 ]; then cmon=11; icmoe=10; icmon_mid=sep; icssnmb=8; fi
if [ $curmo = 12 ]; then cmon=12; icmoe=11; icmon_mid=oct; icssnmb=9; fi
#
yyyy=$curyr
yyym=`expr $curyr - 1`
#
icmomidyr=$icmon_mid$yyyy  # the mid-mon of the latest IC season
#
if [ $cmon -le 2 ]; then icmomidyr=$icmon_mid$yyym; fi
#
yrn1=`expr $curyr - 1891`
if [ $cmon = 1 ]; then yrn1=`expr $yyym - 1891`; fi
mmn1=`expr $yrn1 \* 12`
ttlong=`expr $mmn1 + $icmoe` # total mon of cobesst data from jan1891 to latest_mon; dec2015=1944
#
yrn2=`expr $curyr - 1948` # total full years,=68 for 1948-2015
if [ $cmon = 1 ]; then yrn2=`expr $yyym - 1948`; fi
mmn2=`expr $yrn2 \* 12`
#
tmax=`expr $mmn2 + $icmoe` # 816=dec2015
#
nyear=`expr $curyr - 1948`  # total full year data used for CA, 68 for 1948-2015
if [ $cmon -le 2 ]; then nyear=`expr $curyr - 1948 - 1`; fi # for having 12 3-mon avg data for past year
#
icyr=$curyr
if [ $icmoe = 12 ]; then icyr=`expr $curyr - 1`; fi
outd=/home/peitao/data/ss_fcst/ca/$icyr
outdata=${outd}/$icmoe
if [ ! -d $outd ] ; then
  mkdir -p $outd
fi
if [ ! -d $outdata ] ; then
  mkdir -p $outdata
fi
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10
kocn=15
#======================================
# define some parameters
#======================================
 sst_analysis=cobesst
#
#for eof_range in tp_ml tp_np; do
for eof_range in tp_ml; do
#
# eof_range=tp_np   #30S-60N
# eof_range=tp_ml   #45S-45N
#
if [ $eof_range == tp_np ]; then neoflat=92; eoflats=-30.5; lats=60; late=151; ngrd=20700; fi
if [ $eof_range == tp_ml ]; then neoflat=92; eoflats=-45.5; lats=45; late=136; ngrd=23414; fi
#
clm_bgn=1200  #dec1990
clm_end=`expr $clm_bgn + 360`
nts=686  # feb1948
nte=`expr $ttlong - 1` # mid-mon of the latest season
#
outfile=${sst_analysis}.3mon.1948-curr
cat >sst3monavg<<EOF
run avg.gs
EOF
cat >avg.gs<<EOF
'reinit'
'sdfopen $datadir0/sst.mon.mean.nc'
'set x 1 360'
'set y 1 180'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(sst,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1948 to curr
*'define clm=ave(sst,t+$clm_bgn, t=$ttlong,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $datadir/$outfile.1x1.gr'
'set t $nts $nte'
'd ave(sst-clm,t-1,t+1)'
'c'
EOF
#
/usr/bin/grads -bl <sst3monavg
#
cat>$datadir/$outfile.1x1.ctl<<EOF
dset ^$outfile.1x1.gr
undef -999000000
*
TITLE SST
*
xdef  360 linear   0.5  1.
ydef  180 linear -89.5  1.
zdef   01 levels 1
tdef   9999 linear feb1948 1mo
vars 1
sst  1 99 3-mon mean (C)
ENDVARS
EOF
#
#=======================================
#
outfile2=${sst_analysis}.msic.ic
cat >haveic<<EOF
run sstic.gs
EOF
ic1=`expr $nte - $nts + 1`
ic2=`expr $ic1 - 3`
ic3=`expr $ic1 - 6`
ic4=`expr $ic1 - 9`
cat >sstic.gs<<EOF
'reinit'
'open $datadir/$outfile.1x1.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite $datadir/$outfile2.gr'
'set t $ic1'
'd sst'
'set t $ic2'
'd sst'
'set t $ic3'
'd sst'
'set t $ic4'
'd sst'
'c'
EOF
#
/usr/bin/grads -bl <haveic
#
cat>$datadir/$outfile2.ctl<<EOF
dset ^$outfile2.gr
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
nps=17     #width of data window in season
nwextb=10  # 3mon season number to be extended at begining of a row of the array
nwexte=16  # 3mon season number to be extended at the end of a row of the array
runeof=1 # 0: read in ; 1: run eof
nseasonp=`expr $nyear - 1` #for eof and ca analysis
nseason=`expr $nyear - 3` #for 3-yr CV
#
mlead=16   #maximum lead
mldp=`expr $mlead + 1` 
#
#
#for msic in 1 2 3 4; do
for msic in 1; do
#for modemax in 15 25 40; do
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
      parameter(nseasonp=$nseasonp)
      parameter(nps=$nps)
      parameter(nwextb=$nwextb)
      parameter(nwexte=$nwexte)
c
      parameter(kocn=$kocn)
      parameter(ndec=$ndec)
      parameter(itgtm=$icssnmb)
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
ln -s $outdata/real_ca_prd.sst.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr fort.85
ln -s $outdata/real_ca_weights.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr fort.86
#
./ca.x > $outdata/realtime.${sst_analysis}.${eof_range}.$modemax.${msic}ics.out
#ca.x 
#
cat>$outdata/eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.ctl<<EOF
dset ^eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.gr
undef -9.99E+8
title EXP1
XDEF  360 LINEAR    0.5  1.0
ydef  $neoflat linear $eoflats 1.
zdef  1 linear 1 1
tdef  999 linear jan1949 1mon
vars  1
eof   1 99 constructed
endvars
EOF
#
cat>$outdata/real_ca_prd.sst.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.ctl<<EOF
dset ^real_ca_prd.sst.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr
undef -9.99E+8
title EXP1
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  $mldp linear $icmomidyr 1mon
vars  5
sst   1 99 sst prd
sdo   1 99 std of obs
sdf   1 99 std of fcst
ac    1 99 ac skill
rms   1 99 rms skill
endvars
EOF
#
#
cat>$outdata/real_ca_weights.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.ctl<<EOF
dset ^real_ca_weights.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr
undef -9.99E+8
title EXP1
XDEF  $nseasonp LINEAR    0  1.0
YDEF  1 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  1 linear $icmomidyr 1mon
vars  1
wt    1 99 CA weights
endvars
EOF
#
done  # for EOF cut off
done  # for msic, the # of IC season
done  # for eof_range
