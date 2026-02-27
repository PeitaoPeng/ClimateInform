#!/bin/sh

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp_opr
bindir=/home/ppeng/ClimateInform/src/bin
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

    if [ $var = 't2m' ]; then
      clevsT=' 0 40 50 60 70 80 90'
      ccolsTa=' 99 99 22 23 24 25 73 74'
      ccolsTb=' 99 99 43 44 45 46 47 48'
      ccolsTc=' 99 99 83 84 85 86 87 88 89'
    fi
#
    if [ $var = 'prec' ]; then
      clevsT=' 0 40 50 60 70  '
      ccolsTa=' 99 99 32 35 37 39'
      ccolsTb=' 99 99 72 74 76 78 79'
      ccolsTc=' 99 99 83 84 85 86 88 89'
    fi
#
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
if ($var = 't2m');  'open $datadir/${t2m_ctl}';  endif

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
tgtssyy=mmyysea(mtgt,icyr)
say 'tgtssyy='tgtssyy
*
'set t 'tx
*
*---------------------------string/caption
'set string 1 tc 6'
'set strsiz 0.16 0.16'
'draw string 5.5 8. 'varb' Prob Fcst (%) for 'tgtssyy', data through 'icmonc''icyr', Lead 'lead''
'set strsiz 0.13 0.13'
'draw string 5.5 7.6 Base Period 1991-2020'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=0.75; xlen=9.5;  xgap=0.5
*ymax0=8.0; ylen=-6.5;  ygap=-0.5
ymax0=7.75; ylen=-6.25;  ygap=-0.5
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
  ftx=0.8
  fty=ymin+0.25 
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj scaled'
'set lon 0 360'
'set lat -60 90' 
'set grads off'
*'set grid off'
*'set gxout shaded'
'set gxout grfill'

'set mpdset hires'
'set map 1 1 10'
*
'define a=((maskout(maskout(pa,pa-0.38),-pb+0.38)))*100'
'define b=((maskout(maskout(pb,pb-0.38),-pa+0.38)))*100'
'define c=(maskout(maskout(maskout(pn,pn-0.38),-pa+0.38),-pb+0.34))*100'
*
     'set gxout shaded'
     'set clevs $clevsT'
     'set ccols $ccolsTa'
     'set xlopts 1 3 .17'
     'set ylopts 1 3 .17'
     'd a'
     'query shades'
     ashades=result
     rec2=sublin(ashades,2)
*
     resB=subwrd(result,4)
     if (resB > -99.0)
       'set gxout shaded'
       'set clevs $clevsT'
       'set ccols $ccolsTb'
       'd b'
      endif
     'query shades'
     bshades=result
*
     resC=subwrd(result,4)
      if (resC > -99.0)
       'set gxout shaded'
       'set clevs $clevsT'
       'set ccols $ccolsTc'
*       'd c'
      endif
    'query shades'
     cshades=result

*******************************
*DRAWING THE COLORBAR
*******************************
y1=0.8
y2=1.0 
ylabel=0.725
anum=sublin(ashades,1)
anum=subwrd(anum,5)
num=1
'set strsiz 0.13 0.14'
while (num<anum)
  rec=sublin(ashades,num+2)
  col=subwrd(rec,1)
  lo=subwrd(rec,2)
  hi=subwrd(rec,3)
  'set line ' col
if (var='t'); x1=(0.5*num) ; else;  x1=(0.5*num)+1.5; endif
  x2=x1+0.5

  'draw recf 'x1' 'y1' 'x2' 'y2
  'set line ' 1
  'draw rec 'x1' 'y1' 'x2' 'y2
  if (num=1) ;   'draw string 'x1' 'ylabel' 'lo'%' ; endif
  if (num<anum-1) ; 'draw string 'x2' 'ylabel' 'hi ; endif
  num=num+1
endwhile
xs=((x2-1.5)/2)+1.75
'set strsiz 0.18 0.18'
'draw string 'xs' 0.5 Above'
'set strsiz 0.13 0.14'

x1=x1+0.1
x1a=x1+0.35
*
if (resB>-99.0)
  test=sublin(bshades,1)
  if (test!= 'None')

  bnum=sublin(bshades,1)
  bnum=subwrd(bnum,5)
  num=1
  while (num<bnum)
    rec=sublin(bshades,num+2)
    col=subwrd(rec,1)
    lo=subwrd(rec,2)
    hi=subwrd(rec,3)
    'set line ' col
    x3=(0.5*num)+x1a
    x4=x3+0.5
    'draw recf 'x3' 'y1' 'x4' 'y2
    'set line '1
    'draw rec 'x3' 'y1' 'x4' 'y2
    if (num=1) ;   'draw string 'x3' 'ylabel' 'lo'%' ; endif
    if (num<anum-1) ; 'draw string 'x4' 'ylabel' 'hi ; endif
    num=num+1
  endwhile
  xs=0.2+(((x4-x1a)/2)+x1a)
  'set strsiz 0.18 0.18'
  'draw string 'xs' 0.5 Below'
  'set strsiz 0.13 0.14'
  x3=x3+0.1
else
  x3=x1a+0.35
endif
endif

  x3a=x1a+0.35+0.35+0.4*anum
if (resC>-99.0)
  test=sublin(cshades,1)
  if (test!= 'None')

  cnum=sublin(cshades,1)
  cnum=subwrd(cnum,5)
  num=1
  while (num<anum)
    rec=sublin(cshades,num+2)
    col=subwrd(rec,1)
    lo=subwrd(rec,2)
    hi=subwrd(rec,3)
    'set line ' col
    x5=(0.5*num)+x3a-0.25
    x6=x5+0.5
    'draw recf 'x5' 'y1' 'x6' 'y2
    'set line '1
    'draw rec 'x5' 'y1' 'x6' 'y2
    if (num=1) ;   'draw string 'x5' 'ylabel' 'lo'%' ; endif
    if (num<anum-1) ; 'draw string 'x6' 'ylabel' 'hi ; endif
    num=num+1
  endwhile
  xs=(((x6-x3a)/2)+x3a)

  'set strsiz 0.18 0.18'
  'draw string 'xs' 0.5 Neutral'
endif
endif
*************************************************
* END COLORBAR
*************************************************

'set string 1 tl 5 0'
'set strsiz 0.13 0.13'
'run $bindir/dline.gs 0 0 360 0'
'run $bindir/dline.gs 180 -60 180 90' 
*if ( $var = 'prec' );'run $bindir/dline.gs 180 -90 180 90'; endif 
 'set string 1 tc 5 0'
  iframe=iframe+1
endwhile
*
'set string 4 tl 6'
'set strsiz 0.13 0.13'
'draw string 'ftx' 'fty' ClimateInform' 
*
'gxprint ${var}_prob.'lead'.png x1600 y1200'
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
cp ${var}_prob.*.png $datadir
#
done  # var loop
#

