#!/bin/sh

set -eaux

lcdir=/home/peitao/forecast/ca_ss
tmp=/home/peitao/data/tmp
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
datadir=/home/peitao/data/ss_fcst/ca/$icyr/$icmon
#
cd $tmp
#
var=sst
varb=SST
unit=K
#cleve and ccols
clevsSST="-3 -2 -1 -0.5 -0.25 0.25 0.5 1 2 3"
ccolsSST="59 49 46 44 42 0 22 24 26 29 79"
#
#======================================
# plot global map of CA fcst
#======================================
cat >glmap<<EOF
run glplot.gs
EOF

cat >glplot.gs<<EOFgs
'reinit'
'run /home/peitao/bin/white.gs'
'run /home/peitao/bin/rgbset.ss.gs'
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
'open $datadir/real_ca_prd.$var.'analy_1'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
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
'open $datadir/real_ca_prd.$var.'analy_2'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
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
*
*---------------------------first page
nframe=4
nframe2=4
xmin0=1.25;  xlen=6;  xgap=0.5
ymax0=10.25; ylen=-2.;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+1.25
  tly=ymax+0.22
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
tx=iframe+1
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
'set string 1 tl 6 0'
'set strsiz 0.16 0.16'
'draw string 'tlx' 'tly' Lead = 'lead'; 'tgtssyy''
*
'set t 'tx
*
'define fcst=('vr'.1+'vr'.2+'vr'.3+'vr'.4+'vr'.5+'vr'.6+'vr'.7+'vr'.8+'vr'.9+'vr'.10+'vr'.11+'vr'.12+'vr'.13+'vr'.14+'vr'.15+'vr'.16+'vr'.17+'vr'.18+'vr'.19+'vr'.20+'vr'.21+'vr'.22+'vr'.23+'vr'.24)/24'
*
'set mproj scaled'
'set lon 0 360'
'set lat -45 45'
'set xlab off'
*'set yaxis -45 45 10'
if(iframe = 4);'set xlab on';endif
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs $clevsSST'
'set ccols $ccolsSST'
*
'd fcst'
*
'run /home/peitao/bin/dline.gs 0 0 360 0'
'run /home/peitao/bin/dline.gs 180 -45 180 45'
iframe=iframe+1
endwhile
'run /home/peitao/bin/cbarn2.gs 1. 1 7.6 5.25'
*'print'
'gxprint ca'vr'_anom.-2_to_1.png x600 y800'
c
'set vpage off'
*---------------------------------------------------second page
nframe=4
nframe2=4
xmin0=1.25;  xlen=6;  xgap=0.5
ymax0=10.25; ylen=-2.;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+1.25
  tly=ymax+0.22
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
tx=iframe+5
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
'set string 1 tl 6 0'
'set strsiz 0.16 0.16'
'draw string 'tlx' 'tly' Lead = 'lead'; 'tgtssyy''
*
'set t 'tx
*
'define fcst=('vr'.1+'vr'.2+'vr'.3+'vr'.4+'vr'.5+'vr'.6+'vr'.7+'vr'.8+'vr'.9+'vr'.10+'vr'.11+'vr'.12+'vr'.13+'vr'.14+'vr'.15+'vr'.16+'vr'.17+'vr'.18+'vr'.19+'vr'.20+'vr'.21+'vr'.22+'vr'.23+'vr'.24)/24'
*
'set mproj scaled'
'set lon 0 360'
'set lat -45 45'
'set xlab off'
*'set yaxis -45 45 10'
if(iframe = 4);'set xlab on';endif
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs $clevsSST'
'set ccols $ccolsSST'
*
'd fcst'
*
'run /home/peitao/bin/dline.gs 0 0 360 0'
'run /home/peitao/bin/dline.gs 180 -45 180 45'
iframe=iframe+1
endwhile
'run /home/peitao/bin/cbarn2.gs 1. 1 7.6 5.25'
*'print'
'gxprint ca'vr'_anom.2_to_5.png x600 y800'
c
'set vpage off'
*---------------------------------------------------third page
nframe=4
nframe2=4
xmin0=1.25;  xlen=6;  xgap=0.5
ymax0=10.25; ylen=-2.;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+1.25
  tly=ymax+0.22
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
tx=iframe+9
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
'set string 1 tl 6 0'
'set strsiz 0.16 0.16'
'draw string 'tlx' 'tly' Lead = 'lead'; 'tgtssyy''
*
'set t 'tx
*
'define fcst=('vr'.1+'vr'.2+'vr'.3+'vr'.4+'vr'.5+'vr'.6+'vr'.7+'vr'.8+'vr'.9+'vr'.10+'vr'.11+'vr'.12+'vr'.13+'vr'.14+'vr'.15+'vr'.16+'vr'.17+'vr'.18+'vr'.19+'vr'.20+'vr'.21+'vr'.22+'vr'.23+'vr'.24)/24'
*
'set mproj scaled'
'set lon 0 360'
'set lat -45 45'
'set xlab off'
*'set yaxis -45 45 10'
if(iframe = 4);'set xlab on';endif
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs $clevsSST'
'set ccols $ccolsSST'
*
'd fcst'
*
'run /home/peitao/bin/dline.gs 0 0 360 0'
'run /home/peitao/bin/dline.gs 180 -45 180 45'
iframe=iframe+1
endwhile
'run /home/peitao/bin/cbarn2.gs 1. 1 7.6 5.25'
*'print'
'gxprint ca'vr'_anom.6_to_9.png x600 y800'
c
'set vpage off'
*---------------------------------------------------fourth page
nframe=4
nframe2=4
xmin0=1.25;  xlen=6;  xgap=0.5
ymax0=10.25; ylen=-2.;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+1.25
  tly=ymax+0.22
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
tx=iframe+13
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
'set string 1 tl 6 0'
'set strsiz 0.16 0.16'
'draw string 'tlx' 'tly' Lead = 'lead'; 'tgtssyy''
*
'set t 'tx
*
'define fcst=('vr'.1+'vr'.2+'vr'.3+'vr'.4+'vr'.5+'vr'.6+'vr'.7+'vr'.8+'vr'.9+'vr'.10+'vr'.11+'vr'.12+'vr'.13+'vr'.14+'vr'.15+'vr'.16+'vr'.17+'vr'.18+'vr'.19+'vr'.20+'vr'.21+'vr'.22+'vr'.23+'vr'.24)/24'
*
'set mproj scaled'
'set lon 0 360'
'set lat -45 45'
'set xlab off'
*'set yaxis -45 45 10'
if(iframe = 4);'set xlab on';endif
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs $clevsSST'
'set ccols $ccolsSST'
*
'd fcst'
*
'run /home/peitao/bin/dline.gs 0 0 360 0'
'run /home/peitao/bin/dline.gs 180 -45 180 45'
iframe=iframe+1
endwhile
'run /home/peitao/bin/cbarn2.gs 1. 1 7.6 5.25'
*'print'
'gxprint ca'vr'_anom.10_to_13.png x600 y800'
c
'set vpage off'
*--------------------------------------------------- page
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

/usr/bin/grads -bp <glmap

#
cp ca${var}_anom.*.png $datadir
#

