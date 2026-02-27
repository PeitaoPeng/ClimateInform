#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
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
latest_mon=jul2016 # the end-mon of latest IC season
icmon_mid=jun2016 # the mid-mon of latest IC season
icseason=5  #i-th season in the year, jfm=1
tmax=811           # from jan1949, 804=dec2015
nyear=67           # 1949-latest full-data year, here 1949-2015
#
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10
kocn=15
#======================================
# define some parameters
#======================================
#
#for var in temp prec z200; do
for var in temp; do
for sst_analysis in hadoisst ersst; do
#for sst_analysis in hadoisst; do
#
for eof_range in tp_ml tp_np; do
#for eof_range in tp_ml; do
#
# eof_range=tp_np   #30S-60N
# eof_range=tp_ml   #45S-45N
#
if [ $eof_range == tp_np ]; then neoflat=92; eoflats=-30.5; lats=60; late=151; ngrd=20700; fi
if [ $eof_range == tp_ml ]; then neoflat=92; eoflats=-45.5; lats=45; late=136; ngrd=23414; fi
#
clm_bgn=384  #dec1980
clm_end=`expr $clm_bgn + 360`
nts=2  # feb1949
nte=`expr $tmax - 1` # mid-mon of the latest season
outfile=$var.1949_cur.3mon.R1
imax=192
jmax=94
#=======================================
# rewrite R1 temp data from grib to ieee
#=======================================
cat >havedata<<EOF
run data_rewrite.gs
EOF
#
if [ "$var" = temp ]; then
cat >data_rewrite.gs<<EOF
    'reinit'
'open /cpc/analysis/cdas/month/flux/mean/flx.gau.grib.mean.y1949-cur.ctl'
'set x 1 $imax'
'set y 1 $jmax'
'set t 1 12'
*anom wrt wmo clim 1981-2010
'define clm=ave(TMP2m,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1949 to curr
*'define clm=ave(TMP2m,t+0, t=$tmax,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set t $nts $nte'
'd ave(TMP2m-clm,t-1,t+1)'
'c'
EOF
fi
#
#=======================================
# rewrite R1 prec data
#=======================================
undef_data=-9.99E+8
#
if [ "$var" = prec ]; then
cat >data_rewrite.gs<<EOF3
    'reinit'
'open /cpc/analysis/cdas/month/flux/mean/flx.gau.grib.mean.y1949-cur.ctl'
'set x 1 $imax'
'set y 1 $jmax'
'set t 1 12'
*anom wrt wmo clim 1981-2010
'define clm=ave(PRATE,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1949 to curr
*'define clm=ave(PRATE,t+0, t=$tmax,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set t $nts $nte'
'd ave(PRATE-clm,t-1,t+1)'
'c'
EOF3
fi
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
xdef   192 linear    0.000  1.875
ydef    94 levels
 -88.542 -86.653 -84.753 -82.851 -80.947 -79.043 -77.139 -75.235 -73.331 -71.426
 -69.522 -67.617 -65.713 -63.808 -61.903 -59.999 -58.094 -56.189 -54.285 -52.380
 -50.475 -48.571 -46.666 -44.761 -42.856 -40.952 -39.047 -37.142 -35.238 -33.333
 -31.428 -29.523 -27.619 -25.714 -23.809 -21.904 -20.000 -18.095 -16.190 -14.286
 -12.381 -10.476  -8.571  -6.667  -4.762  -2.857  -0.952   0.952   2.857   4.762
   6.667   8.571  10.476  12.381  14.286  16.190  18.095  20.000  21.904  23.809
  25.714  27.619  29.523  31.428  33.333  35.238  37.142  39.047  40.952  42.856
  44.761  46.666  48.571  50.475  52.380  54.285  56.189  58.094  59.999  61.903
  63.808  65.713  67.617  69.522  71.426  73.331  75.235  77.139  79.043  80.947
  82.851  84.753  86.653  88.542
tdef 9999 linear feb1949 1mo
zdef  01 levels 1
vars 1
$var  0 99 obs
ENDVARS
EOF
#=======================================
# rewrite z200
#=======================================
if [ "$var" = z200 ]; then
cat >data_rewrite.gs<<EOF3
    'reinit'
'open /cpc/analysis/cdas/month/prs/mean/prs.grib.mean.y1949-cur.ctl'
'set x 1 144'
'set y 1  73'
'set z 10'
'set t 1 12'
*anom wrt wmo clim 1981-2010
'define clm=ave(HGT,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1949 to curr
*'define clm=ave(HGT,t+0, t=$tmaxz,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set t $nts $nte'
'd ave(HGT-clm,t-1,t+1)'
'c'
EOF3
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
xdef 144 linear 0 2.5
ydef  73 linear -90 2.5
tdef 9999 linear feb1949 1mo
zdef  01 levels 1
vars 1
$var  0 99 regression
ENDVARS
EOF
fi
#
grads -l <havedata
#
#=======================================
# regrid to 1x1
#=======================================
ntend=`expr $tmax -  2` # from feb1949 to the mid of latest season
cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $outfile.ctl'
'open /cpc/home/wd52pp/data/obs/sst/grid.1x1.ctl'
'set gxout fwrite'
'set fwrite $datadir/$outfile.1x1.gr'
nt=1
while ( nt <= $ntend)

'set t 'nt
say 'time='nt
'set lon   0.5 359.5'
'set lat -89.5  89.5'
'd lterp($var,sst.2(time=jan1950))'

nt=nt+1
endwhile
gsEOF

grads -pb <int

cat>$datadir/$outfile.1x1.ctl<<EOF
dset ^$outfile.1x1.gr
undef -9.99E+8
*
options little_endian
*
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  01 levels 1 
tdef   9999 linear feb1949 1mo
*
VARS 1
$var 1  99   3mon ave
ENDVARS
EOF
#=======================================
#
outfile2=${sst_analysis}.msic.ic
cat >haveic<<EOF
run sstic.gs
EOF
ic1=`expr $tmax + 12 - 2`
ic2=`expr $ic1 - 3`
ic3=`expr $ic1 - 6`
ic4=`expr $ic1 - 9`
cat >sstic.gs<<EOF
'reinit'
'open $datadir/${sst_analysis}.3mon.1948-curr.1x1.ctl'
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
grads -l <haveic
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
#for msic in 1; do
for modemax in 15 25 40; do
#for modemax in 40; do
#
cp $lcdir/realtime.ca_msic.season.sst_tpz.f $tmp/sst_prd.f
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
ln -s $datadir/$outfile.1x1.gr fort.12
#
ln -s $outdata/eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.gr fort.70
#
ln -s $outdata/real_ca_prd.$var.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.R1.gr fort.85
#
ca.x > $outdata/realtime.$var.${sst_analysis}.${eof_range}.$modemax.${msic}ics.out
#ca.x 
#
cat>$outdata/eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.ctl<<EOF
dset ^eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.gr
undef -9.99E+33
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
cat>$outdata/real_ca_prd.$var.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.R1.ctl<<EOF
dset ^real_ca_prd.$var.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.R1.gr
undef $undef_data
title EXP1
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  $mldp linear $icmon_mid 1mon
vars  8
$var  1 99 $var prd
sdo   1 99 std of obs $var
sdf   1 99 std of prd $var
ac    1 99 ac skill since 1981
rms   1 99 rms skill since 1981
sst   1 99 sst prd
sac   1 99 ac skill of sst
srms  1 99 rms skill of sst
endvars
EOF
#
done  # for EOF cut off
done  # for msic, the # of IC season
done  # for eof_range
done  # for sst analysis
done  # for var
