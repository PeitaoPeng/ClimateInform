#!/bin/sh

set -eaux

lcdir=/home/ppeng/src/forecast/ca_ss
tmp=/home/ppeng/data/tmp
#
cyr=`date --date='today' '+%Y'`
mcur=`date --date='today' '+%m'`  # current month
#
if [ $mcur = 01 ]; then icmon=12; icmonc=Dec; fi
if [ $mcur = 02 ]; then icmon=01;  icmonc=Jan; fi
if [ $mcur = 03 ]; then icmon=02;  icmonc=Feb; fi
if [ $mcur = 04 ]; then icmon=03;  icmonc=Mar; fi
if [ $mcur = 05 ]; then icmon=04;  icmonc=Apr; fi
if [ $mcur = 06 ]; then icmon=05;  icmonc=May; fi
if [ $mcur = 07 ]; then icmon=06;  icmonc=Jun; fi
if [ $mcur = 08 ]; then icmon=07;  icmonc=Jul; fi
if [ $mcur = 09 ]; then icmon=08;  icmonc=Aug; fi
if [ $mcur = 10 ]; then icmon=09;  icmonc=Sep; fi
if [ $mcur = 11 ]; then icmon=10; icmonc=Oct; fi
if [ $mcur = 12 ]; then icmon=11; icmonc=Nov; fi
#
icyr=$cyr
if [ $icmon = 12 ]; then icyr=`expr $cyr - 1`; fi
datadir=/home/ppeng/data/ss_fcst/ca/$icyr/$icmon
#
cd $tmp
#
for var in t2m; do
v1=sst
if [ $var = 't2m' ]; then varb=T2m; unit=K; fi
#cleve and ccols
clevsSST="-3 -2 -1 -0.5 -0.25 0.25 0.5 1 2 3"
ccolsSST="59 49 46 44 42 0 22 24 26 29 79"
clevsPrecGL="-7 -5 -3 -1 -0.5 -0.2  0.2 0.5 1 3 5 7"
ccolsPrecGL="79 29 28 26 24  22  0  32  34 36 38 39 49"
clevsPrecNA="-3 -2 -1 -0.5 -0.3 -0.1  0.1 0.3 0.5 1  2 3"
ccolsPrecNA="79 29 28 26 24  22  70  32  34 36 38 39 49"
clevsT2mGL="-4 -3 -2 -1 -0.5 -0.25 0.25 0.5 1 2 3 4"
ccolsT2mGL="59 56 49 46 44 42 0 22 24 26 29 74 78"
clevsT2mNA="-4 -3 -2 -1 -0.5 0.5 1 2 3 4"
ccolsT2mNA="59 56 49 46 43 70  23 26 29 74 78"
clevsSMGL="-150 -120 -90 -60 -30 30 60 90 120 150"
ccolsSMGL="79 75 29 26 23 70 33 36 39 45 49"
clevsSMNA="-150 -120 -90 -60 -30 30 60 90 120 150"
ccolsSMNA="79 75 29 26 23 70 33 36 39 45 49"
clevsz200GL="-90 -75 -60 -45 -30 -15 15 30 45 60 75 90"
ccolsz200GL="49 47 46 45 43 42 0 22 23 25 26 27 29"
clevsz200NA="-90 -75 -60 -45 -30 -15 0 15 30 45 60 75 90"
ccolsz200NA="49 47 46 45 43 42 70 70 22 23 25 26 27 29"
#
#======================================
# plot global map of CA fcst
#======================================
cat >glmap<<EOF
run glplot.gs
EOF

cat >glplot.gs<<EOFgs
'reinit'
'run /home/ppeng/src/bin/white.gs'
'run /home/ppeng/src/bin/rgbset.ss.gs'
*
analy_1=ersst
analy_2=hadoisst
eofrange_1=tp_ml
*
ics=1
while ( ics <= 4 )
icut=1
while ( icut <= 3 )
if (icut = 1); ieof=15; endif
if (icut = 2); ieof=25; endif
if (icut = 3); ieof=40; endif
'open $datadir/real_ca_prd.sst.'analy_1'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
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
'open $datadir/real_ca_prd.sst.'analy_2'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
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
'open $datadir/real_ca_prd.t2m.'analy_1'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
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
'open $datadir/real_ca_prd.t2m.'analy_2'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
icut=icut+1
endwhile
ics=ics+1
endwhile
*
vr=$var
v1=$v1
varb=$varb
icmon=$icmon
icmonc=$icmonc
icyr=$icyr
ts=1
te=17
*
tx=ts
while(tx <= te)
*
lead=tx-4
say 'lead='lead
*
mtgt=tx+icmon-1
say 'mtgt='mtgt
*
tgtssyy=mmyysea(mtgt,icyr)
say 'tgtssyy='tgtssyy
*
'set t 'tx
*
'define fsst=('v1'.1+'v1'.2+'v1'.3+'v1'.4+'v1'.5+'v1'.6+'v1'.7+'v1'.8+'v1'.9+'v1'.10+'v1'.11+'v1'.12+'v1'.13+'v1'.14+'v1'.15+'v1'.16+'v1'.17+'v1'.18+'v1'.19+'v1'.20+'v1'.21+'v1'.22+'v1'.23+'v1'.24)/24'
'define ft2m=('vr'.25+'vr'.26+'vr'.27+'vr'.28+'vr'.29+'vr'.30+'vr'.31+'vr'.32+'vr'.33+'vr'.34+'vr'.35+'vr'.36+'vr'.37+'vr'.38+'vr'.39+'vr'.40+'vr'.41+'vr'.42+'vr'.43+'vr'.44+'vr'.45+'vr'.46+'vr'.47+'vr'.48)/24'
*'define masko=sdo.1'
*'define maskl=sdo.25'
*'define land0=maskout(ft2m,maskl)'
*'define ocean0=maskout(fsst,masko)'

*'define land=const(land0,0,-u)'
*'define ocean=const(ocean0,0,-u)'
*'define fcst=land+ocean'
'define fcst=ft2m'
*---------------------------string/caption
'set string 1 tc 6'
'set strsiz 0.18 0.18'
'draw string 5.5 7.8.0 CA 'varb' Prd for 'tgtssyy', ICs through 'icmonc''icyr'($unit), Lead 'lead''
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=0.5;  xlen=10;  xgap=0.5
ymax0=8.2; ylen=-7.5;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+0.2
  tly=ymax+0.2
  ftx=0.2
  fty=ymin-0.5 
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set lon 0 360'
'set lat -90 90'
*'set xlab off'
*'set yaxis -90 90 30'
if(iframe = 5);'set xlab on';endif
'set grads off'
*'set grid off'
'set gxout shaded'
if(vr='sst')
'set clevs $clevsSST'
'set ccols $ccolsSST'
endif
if(vr='t2m')
'set clevs $clevsT2mGL'
'set ccols $ccolsT2mGL'
endif
if(vr='prec')
'set clevs  $clevsPrecGL'
'set ccols  $ccolsPrecGL'
endif
if(vr='hgt')
'set clevs  $clevsz200GL'
'set ccols  $ccolsz200GL'
endif
*
'd fcst'
*
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
'run /home/ppeng/src/bin/dline.gs 0 0 360 0'
'run /home/ppeng/src/bin/dline.gs 180 -90 180 90'
 'set string 1 tc 5 0'
  iframe=iframe+1
'run /home/ppeng/src/bin/cbarn2.gs 1. 0 5.5 0.75'
endwhile
*
'set string 4 tl 6'
'set strsiz 0.11 0.11'
'draw string 'ftx' 'fty' Peitao Peng CPC/NCEP/NWS/NOAA                  Base Period 1991-2020'
*
*'print'
*'printim ca'vr'_anom.'lead'.png gif x800 y600'
'gxprint ca'vr'_anom.'lead'.png x1600 y1200'
*
c
'set vpage off'
*
tx=tx+1
endwhile
*
function getseas(time)
if(time=1);seas='NDJ';endif;
if(time=2);seas='DJF';endif;
if(time=3);seas='JFM';endif;
if(time=4);seas='FMA';endif;
if(time=5);seas='MAM';endif;
if(time=6);seas='AMJ';endif;
if(time=7);seas='MJJ';endif;
if(time=8);seas='JJA';endif;
if(time=9);seas='JAS';endif;
if(time=10);seas='ASO';endif;
if(time=11);seas='SON';endif;
if(time=12);seas='OND';endif;
if(time=13);seas='NDJ';endif;
if(time=14);seas='DJF';endif;
if(time=15);seas='JFM';endif;
if(time=16);seas='FMA';endif;
if(time=17);seas='MAM';endif;
if(time=18);seas='AMJ';endif;
if(time=19);seas='MJJ';endif;
if(time=20);seas='JJA';endif;
if(time=21);seas='JAS';endif;
if(time=22);seas='ASO';endif;
if(time=23);seas='SON';endif;
if(time=24);seas='OND';endif;
if(time=25);seas='NDJ';endif;
if(time=26);seas='DJF';endif;
if(time=27);seas='JFM';endif;
if(time=28);seas='FMA';endif;
if(time=29);seas='MAM';endif;
if(time=30);seas='AMJ';endif;
return seas
EOF
function mmyysea(mm,yyyy)
  if(mm=1); sea='NDJ'; endif
  if(mm=2); sea='DJF'; endif
  if(mm=3); sea='JFM'; endif
  if(mm=4); sea='FMA'; endif
  if(mm=5); sea='MAM'; endif
  if(mm=6); sea='AMJ'; endif
  if(mm=7); sea='MJJ'; endif
  if(mm=8); sea='JJA'; endif
  if(mm=9); sea='JAS'; endif
  if(mm=10); sea='ASO'; endif
  if(mm=11); sea='SON'; endif
  if(mm=12); sea='OND'; endif
  if(mm=13); sea='NDJ'; endif
  if(mm=14); sea='DJF'; endif
  if(mm=15); sea='JFM'; endif
  if(mm=16); sea='FMA'; endif
  if(mm=17); sea='MAM'; endif
  if(mm=18); sea='AMJ'; endif
  if(mm=19); sea='MJJ'; endif
  if(mm=20); sea='JJA'; endif
  if(mm=21); sea='JAS'; endif
  if(mm=22); sea='ASO'; endif
  if(mm=23); sea='SON'; endif
  if(mm=24); sea='OND'; endif
  if(mm=25); sea='NDJ'; endif
  if(mm=26); sea='DJF'; endif
  if(mm=27); sea='JFM'; endif
  if(mm=28); sea='FMA'; endif
  if(mm=29); sea='MAM'; endif
  if(mm=30); sea='AMJ'; endif
  if(mm<13&mm>2); cyyyy=yyyy; endif
  if(mm<3)
   yyyy0=yyyy-1
   cyyyy=yyyy0'/'yyyy
  endif
  if(mm<15&mm>12)
   yyyy2=yyyy+1
   cyyyy=yyyy'/'yyyy2
  endif
  if(mm>14&mm<25)
   yyyy2=yyyy+1
   cyyyy=yyyy2
  endif
  if(mm<27&mm>24)
   yyyy2=yyyy+1
   yyyy3=yyyy+2
   cyyyy=yyyy2'/'yyyy3
  endif
  if(mm>26)
   yyyy3=yyyy+2
   cyyyy=yyyy3
  endif
return (sea''cyyyy)
EOFgs

/usr/bin/grads -bl <glmap

#
cp ca${var}_anom.*.png $datadir
#
done  # var loop
#

