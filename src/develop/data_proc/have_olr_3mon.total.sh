#!/bin/sh

set -eaux

lcdir=/home/ppeng/src/develop/data_proc
tmp=/home/ppeng/data/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/home/ppeng/data/downloads
datadir=/home/ppeng/data/sst
#
cd $tmp
#
#======================================
# have SST IC
#======================================
curyr=`date --date='today' '+%Y'`  # yr of making fcst
curmo=`date --date='today' '+%m'`  # mo of making fcst
datayr=`date --date='30 day ago' '+%Y'`  # year of the latest data
datamo=`date --date='30 day ago' '+%m'`  # mo of the latest data
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
yrn1=`expr $curyr - 1979`
if [ $cmon = 1 ]; then yrn1=`expr $yyym - 1979`; fi
mmn1=`expr $yrn1 \* 12`
ttlong=`expr $mmn1 + $icmoe` # total mon of ersst data from jan1979 to the latest_mon;
#
yrn2=`expr $curyr - 1979` # total full years,=68 for 1948-2015
if [ $cmon = 1 ]; then yrn2=`expr $yyym - 1979`; fi
mmn2=`expr $yrn2 \* 12`
#
tmax=`expr $mmn2 + $icmoe` # 
#
nyear=`expr $curyr - 1979`  # total full year data used for CA, 68 for 1948-2015
if [ $cmon -le 2 ]; then nyear=`expr $curyr - 1979 - 1`; fi # for having 12 3-mon avg data for past year
#
icyr=$curyr
if [ $icmoe = 12 ]; then icyr=`expr $curyr - 1`; fi
outd=/home/ppeng/data/ss_fcst/ca/$icyr
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
#======================================
# define some parameters
#======================================
 sst_analysis=ersst
#
clm_bgn=144  #dec1990
clm_end=`expr $clm_bgn + 360`
nts=2  # feb1979
nte=`expr $ttlong - 1` # mid-mon of the latest season
#
inputfile=olr-monthly_v02r07_197901_$datayr$datamo
outfile=olr.3mon.1979-curr.total
cat >sst3monavg<<EOF
run avg.gs
EOF
cat >avg.gs<<EOF
'reinit'
'sdfopen $datadir0/$inputfile.nc'
'set x 1 144'
'set y 1  72'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(olr,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1948 to curr
*'define clm=ave(olr,t+$clm_bgn, t=$ttlong,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $datadir/$outfile.gr'
'set t $nts $nte'
#'d ave(olr-clm,t-1,t+1)'
'd ave(olr,t-1,t+1)'
'c'
EOF
#
/usr/bin/grads -bl <sst3monavg
#
cat>$datadir/$outfile.ctl<<EOF
dset ^$outfile.gr
undef -999000000
*
TITLE SST
*
xdef  144 linear   0. 2.5
ydef   72 linear -88.75 2.5
zdef   01 levels 1
tdef   9999 linear feb1979 1mo
vars 1
olr  1 99 3-mon mean (C)
ENDVARS
EOF
#
# regrid to 1x1
#=======================================
cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $datadir/$outfile.ctl'
'open /home/ppeng/src/utility/intpl/grid.360x180.ctl'
'set gxout fwrite'
'set fwrite $datadir/$outfile.1x1.gr'
nt=1
ntend=$tmax-2
while ( nt <= ntend)

'set t 'nt
say 'time='nt
'set lon   0.5 359.5'
'set lat -89.5  89.5'
'd lterp(olr,sst.2(time=jan1982))'

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
tdef   9999 linear feb1979 1mo
*
VARS 1
olr  1  99   sst
ENDVARS
EOF
#
