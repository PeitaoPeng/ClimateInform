#!/bin/sh

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp_opr
bindir=/home/ppeng/ClimateInform/src/bin
#
cyr=`date --date='today' '+%Y'`
mcur=`date --date='today' '+%m'`  # current month
#cyr=2025
#for mcur in 01 02 03 04 05 06 07 08 09 10 11 12; do
#for mcur in 01; do
#
if [ $mcur = 01 ]; then icmon=12; icmonc=Dec; fi
if [ $mcur = 02 ]; then icmon=1;  icmonc=Jan; fi
if [ $mcur = 03 ]; then icmon=2;  icmonc=Feb; fi
if [ $mcur = 04 ]; then icmon=3;  icmonc=Mar; fi
if [ $mcur = 05 ]; then icmon=4;  icmonc=Apr; fi
if [ $mcur = 06 ]; then icmon=5;  icmonc=May; fi
if [ $mcur = 07 ]; then icmon=6;  icmonc=Jun; fi
if [ $mcur = 08 ]; then icmon=7;  icmonc=Jul; fi
if [ $mcur = 09 ]; then icmon=8;  icmonc=Aug; fi
if [ $mcur = 10 ]; then icmon=9;  icmonc=Sep; fi
if [ $mcur = 11 ]; then icmon=10; icmonc=Oct; fi
if [ $mcur = 12 ]; then icmon=11; icmonc=Nov; fi
#
icyr=$cyr
if [ $icmon = 12 ]; then icyr=`expr $cyr - 1`; fi
datadir=/home/ppeng/data/ss_fcst/pcr/$icyr/$icmon
#
sst_ctl=fcst.ersst.2.sst.mics4.mlead8.ncut3.icut1_15.id_ceof1.cv1.3mon.pac.ctl
#
cd $tmp
#
#======================================
# plot time series of NINO34 fcst
#======================================
cat >nino34_ts<<EOF
run tsplot.gs
EOF
cat >tsplot.gs<<EOFgs
'reinit'
'run $bindir/white.gs'
'run $bindir/rgbset.gs'
*
icyr=$icyr
ic_monyr=${icmonc}$icyr
*
*'enable print real.nino34.fcst.'ic_mon'ic.gm'
*
'open $datadir/${sst_ctl}'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.16 0.16'
'draw string 5.5 7.75 Seasonal Forecast of Nino3.4 SST Index, data through 'ic_monyr''
'set strsiz 0.13 0.13'
'draw string 5.5 7.5 Base period 1991-2020'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.14 0.14'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.;  xlen=9.5;  xgap=0.6
ymax0=7.25; ylen=-6;  ygap=-0.1
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin-0.4
  tly=ymin+0.875
  x1=xmin+2.5
  y1=ymax-0.5
  y2=ymax-0.7
  y3=ymax-0.9
  y4=ymax-1.1
  y5=ymax-1.3
  x2=xmin+4.
* y11=ymax-0.5
* y22=ymax-0.7
* y33=ymax-0.9
* y44=ymax-1.1
  x3=xmin+3.0
  ftx=xmin-0.75
  fty=ymin-1. 
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set x 1'
'set y 1'
'set grads off'
'set vrange -2. 3.'
*'set vrange -1.5 2.5'
*'set grid off'
'set t 1 8'
*'set cthick 1'
'set ccolor 4'
'set cmark 1'
'd tloop(aave(sst*stdo,lon=190,lon=240,lat=-5,lat=5))'
*
'draw xlab First Months of 3-mon Seasons'
'draw ylab NINO3.4 Index Aanomaly (K)'
 'set string 1 tc 5 90'
 'set strsiz 0.13 0.13'
 'set string 1 tc 5 0'
  iframe=iframe+1
endwhile
*
'set string 4 tl 6'
'set strsiz 0.11 0.11'
'draw string 'ftx' 'fty' ClimateInform' 
*
*'printim real.nino34.ca_fcst.png gif x800 y600'
'gxprint nino34_fcst.png x1600 y1200'
*'print'
*
'c'
'set vpage off'
EOFgs

/usr/bin/grads -bl <nino34_ts
cp nino34_fcst.png $datadir

#done # mcur loop
