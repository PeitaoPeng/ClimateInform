#!/bin/sh

set -eaux

lcdir=/home/peitao/forecast/ca_ss
tmp=/home/peitao/data/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/home/peitao/data/downloads
datadir1=/home/peitao/data/sst
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
icmomidyr=$icmon_mid$yyyy  # the mid-mon of the latest IC season
icmoendyr=$icmon_end$yyyy
#
if [ $cmon -le 2 ]; then icmomidyr=$icmon_mid$yyym; fi
#
yrn=`expr $curyr - 1948` # total full years,=68 for 1948-2015
if [ $cmon = 1 ]; then yrn=`expr $yyym - 1948`; fi
mmn=`expr $yrn \* 12`
#
tmax=`expr $mmn + $icmoe` # 816=dec2015
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
dridge=0.01

cd $tmp
#=======================================
# have HAD sst jan1948-oct1981
#=======================================
#
outsst0=hadsst.jan1948-oct1981
times=jan1948
timee=oct1981
#
cat >hadsst<<EOF
run havehadsst.gs
EOF
#
cat >havehadsst.gs<<EOF
'reinit'
'sdfopen $datadir1/MODEL.SST.HAD187001-198110.OI198111-201003.nc'
'set gxout fwrite'
'set fwrite $outsst0.gr'
'set x 1 360'
'set y 1 180'
'set time '$times' '$timee''
'd sst'
'c'
EOF
#===========================================
# excute grads data process
#===========================================
/usr/bin/grads -bl <hadsst
#
cat>$outsst0.ctl<<EOF
dset ^$outsst0.gr
undef -9.99E+8
*
options little_endian
*
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  01 levels 1
tdef   9999 linear jan1948 1mo
*
VARS 1
sst 1  99   sst
ENDVARS
EOF

outsst1=hadsst.jan1948-oct1981.masked

cat >maskoutland<<EOF
run mask.gs
EOF
#
cat >mask.gs<<EOF
'reinit'
'open $outsst0.ctl'
'open /home/peitao/utility/mask/mask1X1.dat.ctl'
'set gxout fwrite'
'set fwrite $outsst1.gr'
'set x 1 360'
'set y 1 180'
'set time '$times' '$timee''
'd maskout(sst,mask.2(time=jan1981)-1)'
'c'
EOF
#===========================================
# excute grads data process
#===========================================
/usr/bin/grads -bl <maskoutland
##
cat>$outsst1.ctl<<EOF
dset ^$outsst1.gr
undef -9.99E+8
*
options little_endian
*
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  01 levels 1
tdef   9999 linear jan1948 1mo
*
VARS 1
sst 1  99   sst
ENDVARS
EOF

#=======================================
# have high resolution OIsst nov1981-cur
# and regrid to 360x180
#=======================================
outsst00=oisst.nov1981-cur
times=nov1981
timee=$icmoendyr
#
cat >oisst<<EOF
run haveoisst.gs
EOF
#
cat >haveoisst.gs<<EOF
'reinit'
'sdfopen $datadir0/sst.mon.mean.nc'
'set gxout fwrite'
'set fwrite $outsst00.gr'
'set x 1 1440'
'set y 1 720'
'set time '$times' '$timee''
'd sst'
'c'
EOF
#===========================================
# excute grads data process
#===========================================
/usr/bin/grads -bl <oisst
#
cat>$outsst00.ctl<<EOF
dset ^$outsst00.gr
undef -9.99E+8
*
options little_endian
*
XDEF 1440 LINEAR    0.125  0.25
YDEF  720 LINEAR  -89.875  0.25
zdef  01 levels 1
tdef   9999 linear nov1981 1mo
*
VARS 1
sst 1  99   sst
ENDVARS
EOF
#
outsst2=oisst.nov1981-cur2
#
cat >intpl<<EOF
run intp.gs
EOF
#
cat >intp.gs<<EOF
'reinit'
'open $outsst00.ctl'
'open /home/peitao/utility/intpl/grid.360x180.ctl'
'set gxout fwrite'
'set fwrite $outsst2.gr'
'set lon   0.5 359.5'
'set lat -89.5  89.5'
'set time '$times' '$timee''
'd lterp(sst,sst.2(time=jan1982))'
'c'
EOF
#===========================================
/usr/bin/grads -bl <intpl
#=======================================
outfile0=sst.hadoi.jan1948-cur.mon.tot
#
cat $outsst1.gr $outsst2.gr > $outfile0.gr
\rm $outsst00.*
#
cat>$outfile0.ctl<<EOF
dset ^$outfile0.gr
*options little_endian
undef -999000000
TITLE  Nr. of Valid Months
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
ZDEF 01 LEVELS 1
tdef 9999 linear jan1948 1mo
VARS 1
sst  0 99     veg
ENDVARS
EOF
#
#======================================
# define some parameters
#======================================
 sst_analysis=hadoisst
#
#for eof_range in tp_ml tp_np; do
for eof_range in tp_ml; do
#
# eof_range=tp_np   #30S-60N
# eof_range=tp_ml   #45S-45N
#
if [ $eof_range == tp_np ]; then neoflat=92; eoflats=-30.5; lats=60; late=151; ngrd=20700; fi
if [ $eof_range == tp_ml ]; then neoflat=92; eoflats=-45.5; lats=45; late=136; ngrd=25057; fi
#if [ $eof_range == tp_ml ]; then neoflat=92; eoflats=-45.5; lats=45; late=136; ngrd=33120; fi
#
clm_bgn=516  #dec1990
clm_end=`expr $clm_bgn + 360`
nts=2  # feb1948
nte=`expr $tmax - 1` # mid-mon of the latest season
#
outfile=${sst_analysis}.3mon.1948-curr.1x1
cat >sst3monavg<<EOF
run avg.gs
EOF
cat >avg.gs<<EOF
'reinit'
'open $outfile0.ctl'
'set x 1 360'
'set y 1 180'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(sst,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1948 to curr
*'define clm=ave(sst,t+$clm_bgn, t=$tmax,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set t $nts $nte'
'd ave(sst-clm,t-1,t+1)'
'c'
EOF
#
/usr/bin/grads -bl <sst3monavg
#
cat>$outfile.ctl<<EOF
dset ^$outfile.gr
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
sst 1  99   sst
ENDVARS
EOF
#=======================================
#
outfile1=${sst_analysis}.msic.ic
cat >haveic<<EOF
run sstic.gs
EOF
ic1=`expr $nte - $nts + 1`
ic2=`expr $ic1 - 3`
ic3=`expr $ic1 - 6`
ic4=`expr $ic1 - 9`
cat >sstic.gs<<EOF
'reinit'
'open $outfile.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite $outfile1.gr'
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
cat>$outfile1.ctl<<EOF
dset ^$outfile1.gr
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
mv $outfile.* $datadir
mv $outfile1* $datadir
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
#for msic in 4; do
for modemax in 15 25 40; do
#for modemax in 40; do
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
      parameter(itgtm=$icssnmb)
      parameter(mlead=$mlead)
      parameter(mldp=$mldp)
      parameter(ngrd=$ngrd)
      parameter(msic=$msic)
      parameter(dridge=$dridge)
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
XDEF  $nseason LINEAR    0  1.0
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
\rm $tmp/*.gr
