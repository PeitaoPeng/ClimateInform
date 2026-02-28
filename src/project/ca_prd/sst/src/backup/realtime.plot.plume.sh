#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
datadir=/cpc/home/wd52pp/data/casst
#
cyr=`date --date='today' '+%Y'`
mcur=`date --date='today' '+%m'`  # current month
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
cd $tmp
#
#======================================
# plot global map of CA fcst
#======================================
cat >nino34plume<<EOF
run plumeplot.gs
EOF
cat >plumeplot.gs<<EOFgs
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
*
analy_1=ersst
analy_2=hadoisst
eofrange_1=tp_ml
eofrange_2=tp_np
ic_mon=$icmonc$cyr
*
*'enable print real.nino34.ca_fcst.'ic_mon'ic.gm'
*
ics=1
while ( ics <= 4 )
icut=1
while ( icut <= 3 )
if (icut = 1); ieof=15; endif
if (icut = 2); ieof=25; endif
if (icut = 3); ieof=40; endif
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
icut=icut+1
endwhile
ics=ics+1
endwhile
*
ics=1
while ( ics <= 4 )
icut=1
while ( icut <= 3 )
if (icut = 1); ieof=15; endif
if (icut = 2); ieof=25; endif
if (icut = 3); ieof=40; endif
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
icut=icut+1
endwhile
ics=ics+1
endwhile
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.14 0.14'
'draw string 5.5 7.5 CA Forecast for Nino3.4 SST Index'
'draw string 5.5 7.25 24 members, data thru 'ic_mon''
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.14 0.14'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.5;  xlen=8;  xgap=0.6
ymax0=7.0; ylen=-6;  ygap=-0.1
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
  x2=xmin+4.
  y11=ymax-0.5
  y22=ymax-0.7
  y33=ymax-0.9
  y44=ymax-1.1
  x3=xmin+3.0
  y55=ymax-0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set x 1'
'set y 1'
'set grads off'
*'set vrange -3. 3.'
'set vrange -1.5 1.5'
*'set grid off'
'set t 1 11'
*'set cthick 1'
ii=1
while(ii<4)
'set ccolor 1'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=4
while(ii<7)
'set ccolor 2'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=7
while(ii<10)
'set ccolor 3'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=10
while(ii<13)
'set ccolor 4'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=13
while(ii<16)
'set ccolor 5'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=16
while(ii<19)
'set ccolor 6'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=19
while(ii<22)
'set ccolor 7'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=22
while(ii<25)
'set ccolor 8'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
* ens mean
'set ccolor 1'
'set cthick 25'
'set cmark 5'
'd tloop(aave((sst.1+sst.2+sst.3+sst.4+sst.5+sst.6+sst.7+sst.8+sst.9+sst.10+sst.11+sst.12+sst.13+sst.14+sst.15+sst.16+sst.17+sst.18+sst.19+sst.20+sst.21+sst.22+sst.23+sst.24)/24,lon=190,lon=240,lat=-5,lat=5))'
*
'draw xlab central month of season'
'draw ylab SST-anomaly(C`ao`n)'
 'set string 1 tc 5 90'
 'set strsiz 0.13 0.13'
 'set string 1 tc 5 0'
  iframe=iframe+1
endwhile
 'set string 1 tl 5 0'
 'draw string 'x1' 'y1' ER-SST,IC-1'
 'set string 2 tl 5 0'
 'draw string 'x1' 'y2' ER-SST,IC-2'
 'set string 3 tl 5 0'
 'draw string 'x1' 'y3' ER-SST,IC-3'
 'set string 4 tl 5 0'
 'draw string 'x1' 'y4' ER-SST,IC-4'
*
 'set string 5 tl 5 0'
 'draw string 'x2' 'y11' OI-SST,IC_1'
 'set string 6 tl 5 0'
 'draw string 'x2' 'y22' OI-SST,IC-2'
 'set string 7 tl 5 0'
 'draw string 'x2' 'y33' OI-SST,IC-3'
 'set string 8 tl 5 0'
 'draw string 'x2' 'y44' OI-SST,IC-4'
 'set string 1 tl 7 0'
 'draw string 'x3' 'y55' ENSEMBL MEAN'
'printim real.nino34.ca_fcst.'ic_mon'ic.png gif x800 y600'
'print'
*
'c'
'set vpage off'
EOFgs

/usr/local/bin/grads -l <nino34plume

