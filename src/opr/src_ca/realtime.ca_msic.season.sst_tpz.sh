#!/bin/sh

set -eaux

lcdir=/home/ppeng/src/forecast/ca_ss
tmp=/home/ppeng/data/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/home/ppeng/data/downloads
datadir=/home/ppeng/data/ca_prd
#
cd $tmp
#
#======================================
# have SST IC
#======================================
#curyr=`date --date='today' '+%Y'`  # yr of making fcst
#curmo=`date --date='today' '+%m'`  # mo of making fcst
for curyr in 2024; do
for curmo in 01 02 03 04 05 06 07 08; do
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
yyyy=$curyr
yyym=`expr $curyr - 1`
#
icmomidyr=$icmon_mid$yyyy
if [ $cmon -le 2 ]; then icmomidyr=$icmon_mid$yyym; fi
#
icseason=$icssnmb  # jfm=1
#
yrn=`expr $curyr - 1948` # total full years,=68 for 1948-2015
if [ $cmon = 1 ]; then yrn=`expr $yyym - 1948`; fi
mmn=`expr $yrn \* 12`
#
tmax=`expr $mmn + $icmoe` # 816=dec2015
#
nyear=`expr $curyr - 1948`  # total full year data used for CA
if [ $cmon -le 2 ]; then nyear=`expr $curyr - 1948 - 1`; fi # for having 12 3-mon avg data for past year
#
icyr=$curyr
if [ $icmoe = 12 ]; then icyr=`expr $curyr - 1`; fi
outd=/home/ppeng/data/ss_fcst/ca/$icyr
outdata=${outd}/$icmoe
#
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10
kocn=15
dridge=0.01
#======================================
# define some parameters
#======================================
#
#for var in t2m prec hgt; do
for var in t2m prec; do
#for var in prec; do
for sst_analysis in ersst hadoisst; do
#for sst_analysis in ersst; do
#
#for eof_range in tp_ml tp_np; do
for eof_range in tp_ml; do
#
# eof_range=tp_np   #30S-60N
# eof_range=tp_ml   #45S-45N
#
if [ $eof_range == tp_np ]; then neoflat=92; eoflats=-30.5; lats=60; late=151; fi
if [ $eof_range = 'tp_ml' ]; then neoflat=92; eoflats=-45.5; lats=45; late=136; fi 
#
if [ $eof_range = 'tp_ml' ]; then
if [ $sst_analysis = 'hadoisst' ]; then  ngrd=25057; fi
if [ $sst_analysis = 'ersst' ]; then  ngrd=23414; fi
fi
#
clm_bgn=516  #dec1990
clm_end=`expr $clm_bgn + 360`
nts=2  # feb1948
nte=`expr $tmax - 1` # mid-mon of the latest season
outfile=$var.1948_cur.3mon
imxt=720
jmxt=360
imxp=360
jmxp=180
imxz=144
jmxz=73
undef_data=-9.99E+8
if [ $var = 't2m' ] || [ $var = 'hgt' ]; then
#=======================================
# rewrite t2m data from grib to grads
#=======================================
cat >havedata<<EOF
run data_rewrite.gs
EOF
#
if [ $var = 't2m' ]; then
cat >data_rewrite.gs<<EOF
    'reinit'
'sdfopen $datadir0/air.mon.mean.nc'
'set x 1 $imxt'
'set y 1 $jmxt'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(air,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1948 to curr
*'define clm=ave(air,t+0, t=$tmax,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set t $nts $nte'
'd ave(air-clm,t-1,t+1)'
'c'
EOF
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
ydef 360 linear -89.750000 0.5
xdef 720 linear 0.250000 0.500000
tdef 9999 linear feb1948 1mo
zdef  01 levels 1
vars 1
$var  0 99 obs
ENDVARS
EOF
fi
#
#=======================================
# rewrite hgt
#=======================================
if [ $var = 'hgt' ]; then
nts=2  # feb1948
nte=`expr $tmax - 1` # mid-mon of the latest season
cat >data_rewrite.gs<<EOF3
    'reinit'
'sdfopen $datadir0/hgt.mon.mean.nc'
'set x 1 144'
'set y 1  73'
'set z 10'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(hgt,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1949 to curr
*'define clm=ave(hgt,t+0, t=$tmax,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set t $nts $nte'
'd ave(hgt-clm,t-1,t+1)'
'c'
EOF3
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
xdef 144 linear 0 2.5
ydef  73 linear -90 2.5
tdef 9999 linear feb1948 1mo
zdef  01 levels 1
vars 1
$var  0 99 regression
ENDVARS
EOF
fi
#
/usr/bin/grads -bl <havedata
#
#=======================================
# regrid to 1x1
#=======================================
ntend=`expr $tmax - 2` # from feb1948 to the mid of latest season
cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $outfile.ctl'
'open /home/ppeng/src/utility/intpl/grid.360x180.ctl'
'set gxout fwrite'
'set fwrite $datadir/$outfile.1x1.gr'
nt=1
while ( nt <= $ntend)

'set t 'nt
say 'time='nt
'set lon   0.5 359.5'
'set lat -89.5  89.5'
'd lterp($var,sst.2(time=jan1982))'

nt=nt+1
endwhile
gsEOF

/usr/bin/grads -pb <int

cat>$datadir/$outfile.1x1.ctl<<EOF
dset ^$outfile.1x1.gr
undef -9.99E+8
*
options little_endian
*
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  01 levels 1 
tdef   9999 linear feb1948 1mo
*
VARS 1
$var 1  99   3mon ave
ENDVARS
EOF
#===============================
fi # eigher t2m or hgt
#=======================================
# rewrite prec data
#=======================================
if [ $var = 'prec' ]; then
#
undef_data=-9.99E+8
#
cat >data_rewrite.gs<<EOF3
    'reinit'
'sdfopen $datadir0/precip.mon.mean.1x1.nc'
'set x 1 $imxp'
'set y 1 $jmxp'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(precip,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1948 to curr
*'define clm=ave(precip,t+0, t=$tmax,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $datadir/$outfile.1x1.gr'
'set t $nts $nte'
'd ave(precip-clm,t-1,t+1)'
'c'
EOF3
cat>$datadir/$outfile.1x1.ctl<<EOF
dset ^$outfile.1x1.gr
undef $undef_data
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
tdef 9999 linear feb1948 1mo
zdef  01 levels 1
vars 1
$var  0 99 obs
ENDVARS
EOF
/usr/bin/grads -bl <havedata
fi
#=======================================
#
outfile2=${sst_analysis}.msic.ic
cat >haveic<<EOF
run sstic.gs
EOF
ic1=`expr $tmax - 2`
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
nseason=`expr $nyear - 2` #for eof and ca analysis
#
mlead=16   #maximum lead
mldp=`expr $mlead + 1` 
#
#
for msic in 1 2 3 4; do
for modemax in 15 25 40; do
#for msic in 1; do
#for modemax in 15; do
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
      parameter(dridge=$dridge)
eof
#
gfortran -mcmodel=medium -g -o ca.x sst_prd.f eof_4_ca.s.f
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
ln -s $outdata/real_ca_prd.$var.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr fort.85
#
#ca.x > $outdata/realtime.$var.${sst_analysis}.${eof_range}.$modemax.${msic}ics.out
./ca.x 
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
cat>$outdata/real_ca_prd.$var.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.ctl<<EOF
dset ^real_ca_prd.$var.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr
undef $undef_data
title EXP1
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  $mldp linear $icmomidyr 1mon
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

done # curmo loop
done # curyr loop
