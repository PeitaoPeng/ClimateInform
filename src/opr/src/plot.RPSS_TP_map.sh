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
vyrend=`expr $cyr - 1`  # current month
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
prec_ctl=cvcor.fcst.ensmsynth.prec.mlead8.nprd4.wts2.3mon.v4.ctl
t2m_ctl=cvcor.fcst.ensmsynth.t2m.mlead8.nprd5.wts2.3mon.v4.ctl
#
cd $tmp
#
for var in t2m prec; do
#
if [ $var = 't2m' ]; then varb=T2m; unit=K; fi
if [ $var = 'prec' ]; then varb=Prec; unit=mm/day; fi

#cleve and ccols
clevsPrec="0 0.03 0.06 0.09 0.12 0.15 0.18 0.21 0.24"
ccolsPrec="0 21 22 23 24 25 26 27 28 29"

clevsT2m="0 0.10 0.20 0.30 0.40 0.50 0.60 0.70"
ccolsT2m="0 21 23 24 25 26 27 28 29"

#======================================
# plot global map of fcst
#======================================
cat >glmap<<EOF
run glplot.gs
EOF

cat >glplot.gs<<EOFgs
'reinit'
'run $bindir/white.gs'
'run $bindir/rgbset.ss.gs'
*
if ($var = 'prec'); 'open $datadir/${prec_ctl}'; endif
if ($var = 't2m');   'open $datadir/${t2m_ctl}';  endif

vr=$var
varb=$varb
icmon=$icmon
icmonc=$icmonc
icyr=$icyr

ts=1
te=8
*
tx=ts
while(tx <= te)
*
lead=tx-1
say 'lead='lead
*
mtgt=tx+icmon+2
say 'mtgt='mtgt
*
tgtss=getseas(mtgt)
say 'tgtss='tgtss
*
'set t 'tx
*
'define detfcst='vr'*stdo'
*---------------------------string/caption
'set string 1 tc 6'
'set strsiz 0.16 0.16'
'draw string 5.5 8.25 RPSS of 'varb' FCST for 'tgtss'(1981-$vyrend), Lead 'lead''
'set strsiz 0.13 0.13'
*'draw string 5.5 7.85 Verification Period: 1981-$vyrend'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=0.5; xlen=10;  xgap=0.5
ymax0=8.0; ylen=-7.0;  ygap=-0.5
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
  fty=ymin-0.75 
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj scaled'
'set lon 0 360'
'set lat -90 90'
*if ( $var = 'prec' );'set lat -60 90'; endif 
if ( $var = 'prec' );'set lat -90 90'; endif 
*'set xlab off'
*'set yaxis -90 90 30'
if(iframe = 5);'set xlab on';endif
'set grads off'
*'set grid off'
*'set gxout shaded'
'set gxout grfill'

'set mpdset hires'
'set map 1 1 6'

*if(vr='t2m')
'set clevs $clevsT2m'
'set ccols $ccolsT2m'
*endif
*if(vr='prec')
*'set clevs  $clevsPrec'
*'set ccols  $ccolsPrec'
*endif
*
'd rpss'
*
'set rgb 17 150 150 150'
'set line 17 1'
'draw shp /home/ppeng/shapes/ne_countries/10m_cultural/ne_10m_admin_0_countries.shp'
*
'set string 1 tl 5 0'
'set strsiz 0.13 0.13'
'run $bindir/dline.gs 0 0 360 0'
*if ( $var = 'prec' );'run $bindir/dline.gs 180 -60 180 90'; endif 
if ( $var = 'prec' );'run $bindir/dline.gs 180 -90 180 90'; endif 
 'set string 1 tc 5 0'
  iframe=iframe+1
'run $bindir/cbarn2.gs 1. 0 5.5 0.5'
endwhile
*
'set string 4 tl 6'
'set strsiz 0.13 0.13'
'draw string 'ftx' 'fty' ClimateInform' 
*
*'print'
*'printim ${var}_RPSS.'lead'.png gif x800 y600'
'gxprint ${var}_RPSS.'lead'.png x1600 y1200'
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
cp ${var}_RPSS.*.png $datadir
#
done  # var loop
#
#done # mcur loop
