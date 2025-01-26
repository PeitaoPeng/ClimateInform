#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/opr
tmp=/cpc/home/wd52pp/tmp/opr2
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
/usr/local/bin/grads -bl <hadsst
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
'd maskout(273.16+sst,mask.2(time=jan1982)-1)'
'c'
EOF
#
#
#===========================================
# excute grads data process
#===========================================
/usr/local/bin/grads -bl <oisst
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
'define sstc=ave(sst,t+516,t=876,1yr)'
*'define sstc=ave(sst,t+396,t=756,1yr)'
*'define sstc=ave(sst,t+0,t=$tmax,1yr)'
'modify sstc seasonal'
'set t 1 '$te''
'd sst-sstc'
*'d sst'
'c'
EOF
#
/usr/local/bin/grads -bl <anom
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
/usr/local/bin/grads -bl <3mavg
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
