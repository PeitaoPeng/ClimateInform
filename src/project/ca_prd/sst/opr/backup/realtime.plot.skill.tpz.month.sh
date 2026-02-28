#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/opr
tmp=/cpc/home/wd52pp/tmp/opr2
#
cyr=`date --date='today' '+%Y'`
mcur=`date --date='today' '+%m'`  # current month
vyrend=`expr $cyr - 1`  # current month
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
datadir=/cpc/home/wd52pp/data/season_fcst/ca/$icyr/$icmon
#
cd $tmp
#
#for var in sst t2m prec hgt; do
for var in t2m prec hgt; do
#
if [ $var = 'sst' ]; then varb=SST; unit=K; fi
if [ $var = 't2m' ]; then varb=T2m; unit=K; fi
if [ $var = 'prec' ]; then varb=Prec; unit=mm/day; fi
if [ $var = 'hgt' ]; then varb=HGT200; unit=m; fi
#cleve and ccols
clevsacGL=" 10 20 30 40 50 60 70 80 90"
ccolsacGL=" 0 91 92 31 33 35 37 81 82 85"
#
#======================================
# plot global map of CA fcst
#======================================
cat >glmap<<EOF
run glplot.gs
EOF

cat >glplot.gs<<EOFgs
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
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
'open  $datadir/real_ca_prd.$var.'analy_1'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
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
'open  $datadir/real_ca_prd.$var.'analy_2'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
icut=icut+1
endwhile
ics=ics+1
endwhile
*
vr=$var
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
lead=tx-3
say 'lead='lead
*
mtgt=tx+icmon-1
say 'mtgt='mtgt
*
tgtss=getseas(mtgt)
say 'tgtss='tgtss
*
'set t 'tx
*
'define skill=100*('ac'.1+'ac'.2+'ac'.3+'ac'.4+'ac'.5+'ac'.6+'ac'.7+'ac'.8+'ac'.9+'ac'.10+'ac'.11+'ac'.12+'ac'.13+'ac'.14+'ac'.15+'ac'.16+'ac'.17+'ac'.18+'ac'.19+'ac'.20+'ac'.21+'ac'.22+'ac'.23+'ac'.24)/24'
*---------------------------string/caption
'set string 1 tc 6'
'set strsiz 0.18 0.18'
'draw string 5.5 7.85 AC Skill(%) of CA 'varb' Forecast for 'tgtss' (Lead 'lead')'
'draw string 5.5 7.55 Verification Period: 1981-$vyrend'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=0.5;  xlen=10;  xgap=0.5
ymax0=8.0; ylen=-7.5;  ygap=-0.5
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
'set clevs  $clevsacGL'
'set ccols  $ccolsacGL'
*
'd skill'
*
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -90 180 90'
 'set string 1 tc 5 0'
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 0.5'
endwhile
'print'
'printim ca'vr'.ac.'lead'.mon.png gif x800 y600'
*
c
'set vpage off'
*
tx=tx+1
endwhile
*
function getseas(time)
if(time=1);seas='Dec';endif;
if(time=2);seas='Jan';endif;
if(time=3);seas='Feb';endif;
if(time=4);seas='Mar';endif;
if(time=5);seas='Apr';endif;
if(time=6);seas='May';endif;
if(time=7);seas='Jun';endif;
if(time=8);seas='Jul';endif;
if(time=9);seas='Aug';endif;
if(time=10);seas='Sep';endif;
if(time=11);seas='Oct';endif;
if(time=12);seas='Nov';endif;
if(time=13);seas='Dec';endif;
if(time=14);seas='Jan';endif;
if(time=15);seas='Feb';endif;
if(time=16);seas='Mar';endif;
if(time=17);seas='Apr';endif;
if(time=18);seas='May';endif;
if(time=19);seas='Jun';endif;
if(time=20);seas='Jul';endif;
if(time=21);seas='Aug';endif;
if(time=22);seas='Sep';endif;
if(time=23);seas='Oct';endif;
if(time=24);seas='Nov';endif;
if(time=25);seas='Dec';endif;
if(time=26);seas='Jan';endif;
if(time=27);seas='Feb';endif;
if(time=28);seas='Mar';endif;
if(time=29);seas='Apr';endif;
if(time=30);seas='May';endif;
return seas
EOF
function mmyysea(mm,yyyy)
if(mm=1);sea='Dec';endif;
if(mm=2);sea='Jan';endif;
if(mm=3);sea='Feb';endif;
if(mm=4);sea='Mar';endif;
if(mm=5);sea='Apr';endif;
if(mm=6);sea='May';endif;
if(mm=7);sea='Jun';endif;
if(mm=8);sea='Jul';endif;
if(mm=9);sea='Aug';endif;
if(mm=10);sea='Sep';endif;
if(mm=11);sea='Oct';endif;
if(mm=12);sea='Nov';endif;
if(mm=13);sea='Dec';endif;
if(mm=14);sea='Jan';endif;
if(mm=15);sea='Feb';endif;
if(mm=16);sea='Mar';endif;
if(mm=17);sea='Apr';endif;
if(mm=18);sea='May';endif;
if(mm=19);sea='Jun';endif;
if(mm=20);sea='Jul';endif;
if(mm=21);sea='Aug';endif;
if(mm=22);sea='Sep';endif;
if(mm=23);sea='Oct';endif;
if(mm=24);sea='Nov';endif;
if(mm=25);sea='Dec';endif;
if(mm=26);sea='Jan';endif;
if(mm=27);sea='Feb';endif;
if(mm=28);sea='Mar';endif;
if(mm=29);sea='Apr';endif;
if(mm=30);sea='May';endif;
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

/usr/local/bin/grads -bl <glmap

#
cp ca${var}.ac.*.mon.png $datadir
#
done  # var loop
#

