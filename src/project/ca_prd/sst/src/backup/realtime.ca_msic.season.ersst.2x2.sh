#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp/test
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/export/cpc-lw-mlheureux/wd52ml/enso/oni.v3b/data/errsst.v3b
datadir=/cpc/home/wd52pp/data/ca_prd
outdata=/cpc/home/wd52pp/data/casst
#
cd $tmp
#
#======================================
# have SST IC
#======================================
latest_mon=may2016 # the end-mon of latest IC season
icmon_mid=apr2016 # the mid-mon of latest IC season
icseason=3  #i-th season in the year, jfm=1
ttlong=1949        # total mon of ersst data from jan1854 to latest_mon; dec2015=1944
nyear=68           # total full year data used for CA, here 1948-2015
#
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10
kocn=15
#======================================
# define some parameters
#======================================
 sst_analysis=ersst
#
#for eof_range in tp_ml tp_np; do
for eof_range in tp_ml; do
#
# eof_range=tp_np   #30S-60N
# eof_range=tp_ml   #45S-45N
#
if [ $eof_range == tp_np ]; then neoflat=46; eoflats=-30; lats=30; late=75; ngrd=5670; fi
if [ $eof_range == tp_ml ]; then neoflat=47; eoflats=-46; lats=22; late=68; ngrd=6438; fi
#
clm_bgn=1524  #dec1980
clm_end=`expr $clm_bgn + 360`
nts=1130  # feb1948
nte=`expr $ttlong - 1` # mid-mon of the latest season
#
outfile=${sst_analysis}.3mon.1948-curr
cat >sst3monavg<<EOF
run avg.gs
EOF
cat >avg.gs<<EOF
'reinit'
'open $datadir0/ersst.v3b.1854.2010.ctl'
'set x 1 180'
'set y 1  89'
'set t 1 12'
*anom wrt wmo clim 1981-2010
'define clm=ave(sst,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1948 to curr
*'define clm=ave(sst,t+$clm_bgn, t=$ttlong,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $datadir/$outfile.gr'
'set t $nts $nte'
'd ave(sst-clm,t-1,t+1)'
'c'
EOF
#
grads -l <sst3monavg
#
cat>$datadir/$outfile.ctl<<EOF
dset ^$outfile.gr
undef -999000000
*
TITLE SST
*
xdef  180 linear   0. 2.
ydef   89 linear -89. 2.
zdef   1 linear 1 1
tdef   9999 linear feb1948 1mo
vars 1
t  1 99 3-mon mean (C)
ENDVARS
EOF
#
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
'open $datadir/$outfile.ctl'
'set x 1 180'
'set y 1  89'
'set gxout fwrite'
'set fwrite $datadir/$outfile2.gr'
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
cat>$datadir/$outfile2.ctl<<EOF
dset ^$outfile2.gr
undef -999000000
*
TITLE Tsfc
*
xdef  180 linear   0. 2.
ydef   89 linear -89. 2.
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
mlead=10   #maximum lead
mldp=`expr $mlead + 1` 
#
#
for msic in 1 2 3 4; do
#for modemax in 20 25 30 40 50 60; do
for modemax in 15 20 25 30 35 40; do
#for modemax in 35 40 45 50 55 60; do
#
cp $lcdir/realtime.ca_msic.season.sst.2x2.f $tmp/sst_prd.f
cp $lcdir/eof_4_ca.s.f $tmp/eof_4_ca.s.f

#
cat > parm.h << eof
      parameter(nruneof=$runeof)
c
      parameter(ims=180,jms=89)   !input sst dimension
c
      parameter(lons=1,lone=180)   !lon range for EOFs analysis (0-360)
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
ln -s $datadir/${sst_analysis}.3mon.1948-curr.gr fort.11
#
ln -s $outdata/eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.gr fort.70
#
ln -s $outdata/real_ca_prd.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr fort.85
#
ca.x > $outdata/realtime.${sst_analysis}.${eof_range}.$modemax.${msic}ics.out
#ca.x 
#
cat>$outdata/eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.ctl<<EOF
dset ^eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.gr
undef -9.99E+33
title EXP1
xdef  180 linear   0. 2.
ydef  $neoflat linear $eoflats 2.
zdef  1 linear 1 1
tdef  999 linear jan1949 1mon
vars  1
eof   1 99 constructed
endvars
EOF
#
cat>$outdata/real_ca_prd.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.ctl<<EOF
dset ^real_ca_prd.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr
undef -9.99E+33
title EXP1
xdef  180 linear   0. 2.
ydef   89 linear -88. 2.
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
done  # for EOF cut off
done  # for msic, the # of IC season
done  # for eof_range
