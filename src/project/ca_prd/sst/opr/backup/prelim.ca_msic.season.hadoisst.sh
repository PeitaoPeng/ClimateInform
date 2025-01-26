#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/opr
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/cpc/analysis/verif/ocean/sst/oi/ctl
datadir=/cpc/home/wd52pp/data/ca_prd
#
#
cd $tmp
#
#======================================
# have SST IC
#======================================
curyr=`date --date='today' '+%Y'`  # year of making fcst
curmo=`date --date='today' '+%m'`  # mon  of making fcst
curdy=`date --date='today' '+%d'`  # day  of making fcst
#
if [ $curmo = 01 ]; then cmon=1; icmon_end=dec; icmoe=12; icmon_mid=nov; icssnmb=10; fi #icmon_mid: mid mon of icss
if [ $curmo = 02 ]; then cmon=2; icmon_end=jan; icmoe=1 ; icmon_mid=dec; icssnmb=11; fi #icssnmb: 1st mon of icss
if [ $curmo = 03 ]; then cmon=3; icmon_end=feb; icmoe=2 ; icmon_mid=jan; icssnmb=12 ; fi
if [ $curmo = 04 ]; then cmon=4; icmon_end=mar; icmoe=3 ; icmon_mid=feb; icssnmb=1 ; fi
if [ $curmo = 05 ]; then cmon=5; icmon_end=apr; icmoe=4 ; icmon_mid=mar; icssnmb=2; fi
if [ $curmo = 06 ]; then cmon=6; icmon_end=may; icmoe=5 ; icmon_mid=apr; icssnmb=3; fi
if [ $curmo = 07 ]; then cmon=7; icmon_end=jun; icmoe=6 ; icmon_mid=may; icssnmb=4; fi
if [ $curmo = 08 ]; then cmon=8; icmon_end=jul; icmoe=7 ; icmon_mid=jun; icssnmb=5; fi
if [ $curmo = 09 ]; then cmon=9; icmon_end=aug; icmoe=8 ; icmon_mid=jul; icssnmb=6; fi
if [ $curmo = 10 ]; then cmon=10; icmon_end=sep; icmoe=9 ; icmon_mid=aug; icssnmb=7; fi
if [ $curmo = 11 ]; then cmon=11; icmon_end=oct; icmoe=10; icmon_mid=sep; icssnmb=8; fi
if [ $curmo = 12 ]; then cmon=12; icmon_end=nov; icmoe=11; icmon_mid=oct; icssnmb=9; fi
#
yyyy=$curyr
yyym=`expr $curyr - 1`
#
icmomidyr=$icmon_mid$yyyy
icmoendyr=$icmon_end$yyyy
#
if [ $cmon = 1 ]; then icmomidyr=$icmon_mid$yyym; icmoendyr=$icmon_end$yyym; fi
if [ $cmon = 2 ]; then icmomidyr=$icmon_mid$yyym; fi
#
icseason=$icssnmb  # jfm=1
#
yrn=`expr $curyr - 1948` # total full years,=68 for 1948-2015
if [ $cmon = 1 ]; then yrn=`expr $yyym - 1948`; fi
mmn=`expr $yrn \* 12`
#
tmax=`expr $mmn + $icmoe` # 816=dec2015
#
nyear=`expr $curyr - 1948`  # total full year data used for CA, 68 for 1948-2015
if [ $cmon -le 2 ]; then nyear=`expr $curyr - 1948 - 1`; fi #for having 12 3-mon avg data for past year
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
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10 
kocn=15

cd $tmp
#=======================================
# have HAD sst jan1948-oct1981
#=======================================
sstdir=/cpc/home/wd52pp/data/obs/sst
bjha=/cpc/GODAS/bjha/MERGEDSST
datadir=/cpc/home/wd52pp/data/ca_prd
outdir=/cpc/home/wd52pp/data/casst
#
outsst1=hadsst.jan1948-oct1981
times=jan1948
timee=oct1981
#
cat >hadsst<<EOF
run havehadsst.gs
EOF
#
cat >havehadsst.gs<<EOF
'reinit'
'open $bjha/ncar.SST.HAD187001-198110.OI198111-201003.ctl'
'open $sstdir/mask_had.ctl'
'set gxout fwrite'
'set fwrite $outsst1.gr'
'set x 1 360'
'set y 1 180'
'set time '$times' '$timee''
'd maskout(sst,mask.2(time=jan1949)-1)'
'c'
EOF
#===========================================
# excute grads data process
#===========================================
grads -l <hadsst
#
#=======================================
# have OI sst nov1981-cur
#=======================================
outsst2=oisst.nov1981-cur
times=nov1981
timee=$icmoendyr
#
cat >oisst<<EOF
run haveoisst.gs
EOF
#
cat >haveoisst.gs<<EOF
'reinit'
'open /cpc/analysis/verif/ocean/sst/oi/ctl/monoiv2.ctl'
'open $sstdir/mask_oi.ctl'
'set gxout fwrite'
'set fwrite $outsst2.gr'
'set x 1 360'
'set y 1 180'
'set time '$times' '$timee''
'd maskout(273.16+sst,mask.2(time=nov1981)-1)'
'c'
EOF
#
#===========================================
# excute grads data process
#===========================================
grads -l <oisst
#
outfile=sst.hadoi.jan1948-cur.mon.tot
#
cat $outsst1.gr $outsst2.gr > $outfile.gr
#
cat>$outfile.ctl<<EOF
dset ^$outfile.gr
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
#=======================================
# have daily SST of current month
#=======================================
rm -f sstgrb*
#
analdir=/cpc/analysis/cdas/rot_6hrly
bindir=/cpc/home/wd52pp/bin
maxago=`expr $curdy - 2`
totday=`expr $curdy - 3`
#
idy=2
while [ $idy -le $maxago ]; do # "le" for taking the end of a day
echo $idy
YEAR=`date --date=''$idy' day ago' '+%Y'`
MONTH=`date --date=''$idy' day ago' '+%m'`
DAY=`date --date=''$idy' day ago' '+%d'`
cp $analdir/sstgrb${YEAR}${MONTH}${DAY}00 $tmp
let idy=idy+1
done
cat sstgrb* > sstgrball
$bindir/./wgrib sstgrball | egrep -e ":TMP:" | grep -e ":sfc:" | $bindir/./wgrib sstgrball -i -bin -o sstbin.gr
#
cat >sstbin.ctl<<EOF
dset ^sstbin.gr
undef 9.999E+20
options sequential yrev
ydef 180 linear -89.5 1.0
xdef 360 linear  0.5 1.0
tdef $totday linear 01jan2017 1dy
zdef 1 linear 1 1
vars 1
TMP  0 33,100,200  daily oi sst from R1
ENDVARS
EOF
cat >readsst<<EOF
run read.gs
EOF
cat >read.gs<<EOF
'reinit'
'open sstbin.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite sst.gr'
'set t 1 $totday'
'd TMP'
'c'
EOF

$bindir/grads -bl <readsst

cat >sst.ctl<<EOF
dset ^sst.gr
undef 9.999E+20
ydef 180 linear -89.5 1.0
xdef 360 linear  0.5 1.0
tdef $totday linear 01jan2017 1dy
zdef 1 linear 1 1
vars 1
TMP  0 33,100,200  daily oi sst from R1
ENDVARS
EOF
#======================================
# have daily amom then monthly anom
#=======================================
cp $lcdir/daily_2_monthly.f $tmp/d2m.f
#
cat > parm.h << eof
      parameter(nday=$totday)
      parameter(mfinal=$cmon)
      parameter(idim=360,jdim=180)   !input sst dimension
eof
#
gfortran -o d2m.x d2m.f
echo "done compiling"
#
/bin/rm $tmp/fort.*
#
ln -s sst.gr fort.10
ln -s $outfile.gr fort.11
#
ln -s sst.curmon.anom.gr fort.30
#
d2m.x 
#
cat >sst.curmon.anom.ctl<<EOF
dset ^sst.curmon.anom.gr
undef -999000000
ydef 180 linear -89.5 1.0
xdef 360 linear  0.5 1.0
tdef 999 linear 01jan2017 1dy
zdef 1 linear 1 1
vars 1
sst  0 33,100,200  monthly from daily
ENDVARS
EOF
#=======================================
# have monthly anomalies
#=======================================
outfile2=hadoisst.mon.1948-curr
ts=1
te=$tmax
#
cat >anom<<EOF
run haveanom.gs
EOF
#
cat >haveanom.gs<<EOF
'reinit'
'open $outfile.ctl'
'set gxout fwrite'
'set fwrite $outfile2.gr'
'set x 1 360'
'set y 1 180'
'set t 1 12'
'define sstc=ave(sst,t+396,t=756,1yr)'
*'define sstc=ave(sst,t+0,t=$tmax,1yr)'
'modify sstc seasonal'
'set t 1 '$te''
'd sst-sstc'
'c'
EOF
#
grads -l <anom
#
cat>$outfile2.ctl<<EOF
dset ^$outfile2.gr
*options little_endian
undef -999000000
TITLE  Nr. of Valid Months
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
ZDEF 1 LEVELS 1
tdef 1200 linear jan1948 1mo
VARS 1
sst  0 99     anom
ENDVARS
EOF
#
#
#=======================================
# have 3-mon avg anomalies
#=======================================
outfile3=hadoisst.3mon.1948-curr.1x1
ts=2
te=`expr $tmax - 1`
#
cat >3mavg<<EOF
run have3mavg.gs
EOF
#
cat >have3mavg.gs<<EOF
'reinit'
'open $outfile2.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite $outfile3.gr'
'set t '$ts' '$te''
'd ave(sst,t-1,t+1)'
'c'
EOF
#
grads -l <3mavg
#
cat>$outfile3.ctl<<EOF
dset ^$outfile3.gr
*options little_endian
undef -999000000
TITLE  3mon avg
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
ZDEF 1 LEVELS 1
tdef 1200 linear feb1948 1mo
VARS 1
sst  0 99     anom
ENDVARS
EOF
#
mv $outfile.* $datadir
mv $outfile2* $datadir
mv $outfile3* $datadir
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
if [ $eof_range == tp_np ]; then neoflat=92; eoflats=-30.5; lats=60; late=151; ngrd=20700; fi
if [ $eof_range == tp_ml ]; then neoflat=92; eoflats=-45.5; lats=45; late=136; ngrd=25057; fi
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
nps=17     #width of data window in season
nwextb=10  # 3mon season number to be extended at begining of a row of the array
nwexte=16  # 3mon season number to be extended at the end of a row of the array
runeof=1 # 0: read in ; 1: run eof
nseason=`expr $nyear - 3` #for eof and ca analysis
#
mlead=16  #maximum lead
mldp=`expr $mlead + 1` 
#
for msic in 1 2 3 4; do
for modemax in 15 25 40; do
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
ln -s $outdata/eof.${eof_range}.${msic}ics.3mon.gr fort.70
#
ln -s $outdata/prelim_ca_prd.sst.${eof_range}.$modemax.${msic}ics.3mon.gr fort.85
ln -s $outdata/prelim_ca_weights.${eof_range}.$modemax.${msic}ics.3mon.gr fort.86
#
 ca.x > $outdata/prelim.${eof_range}.$modemax.${msic}ics.out
#ca.x 
#
cat>$outdata/eof.${eof_range}.${msic}ics.3mon.ctl<<EOF
dset ^eof.${eof_range}.${msic}ics.3mon.gr
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
cat>$outdata/prelim_ca_prd.sst.${eof_range}.$modemax.${msic}ics.3mon.ctl<<EOF
dset ^prelim_ca_prd.sst.${eof_range}.$modemax.${msic}ics.3mon.gr
undef -9.99E+33
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
cat>$outdata/prelim_ca_weights.${eof_range}.$modemax.${msic}ics.3mon.ctl<<EOF
dset ^prelim_ca_weights.${eof_range}.$modemax.${msic}ics.3mon.gr
undef -9.99E+33
title EXP1
XDEF  $nseason LINEAR    0  1.0
YDEF  1 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  1 linear $icmomidyr 1mon
vars  1
wt    1 99 CA weights
endvars
EOF
done  # maxmode
done  # msics
done  # eof_range
