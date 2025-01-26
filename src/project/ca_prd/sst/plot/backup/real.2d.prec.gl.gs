'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
tgts1=DJF2017
tgts2=MAM2017
tgts3=JJA2017
analy_1=ersst
analy_2=hadoisst
eofrange_1=tp_ml
ic_mon=Oct2016
*
'enable print real.2d-sst_fcst.'ic_mon'IC.gm' 
ics=1
while ( ics <= 4 )
icut=1
while ( icut <= 3 )
if (icut = 1); ieof=15; endif
if (icut = 2); ieof=25; endif
if (icut = 3); ieof=40; endif
'open /cpc/home/wd52pp/data/casst/real_ca_prd.prec.'analy_1'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
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
'open /cpc/home/wd52pp/data/casst/real_ca_prd.prec.'analy_2'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
icut=icut+1
endwhile
ics=ics+1
endwhile
*
'set t 5'
'define fcst1=(prec.1+prec.2+prec.3+prec.4+prec.5+prec.6+prec.7+prec.8+prec.9+prec.10+prec.11+prec.12+prec.13+prec.14+prec.15+prec.16+prec.17+prec.18+prec.19+prec.20+prec.21+prec.22+prec.23+prec.24)/24'
'set t 8'
'define fcst2=(prec.1+prec.2+prec.3+prec.4+prec.5+prec.6+prec.7+prec.8+prec.9+prec.10+prec.11+prec.12+prec.13+prec.14+prec.15+prec.16+prec.17+prec.18+prec.19+prec.20+prec.21+prec.22+prec.23+prec.24)/24'
'set t 11'
'define fcst3=(prec.1+prec.2+prec.3+prec.4+prec.5+prec.6+prec.7+prec.8+prec.9+prec.10+prec.11+prec.12+prec.13+prec.14+prec.15+prec.16+prec.17+prec.18+prec.19+prec.20+prec.21+prec.22+prec.23+prec.24)/24'
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.14 0.14'
'draw string 4.25 10.250 CA Prec(0.1mm/day) Forecast, SST ICs through 'ic_mon''
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.25;  xlen=6;  xgap=0.6
ymax0=9.75; ylen=-2.5;  ygap=-0.5
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
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set lon 0 360'
'set lat -60 80'
*'set xlab off'
'set yaxis -60 80 20'
if(iframe = 5);'set xlab on';endif
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs  -16 -8 -4. -2 -1. -0.5 0.5 1 2 4 8 16'
'set ccols  39 37 35 33 32 31 0 71 72 73 75 77 79'
'd fcst'%iframe
*
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
if(iframe = 1);'draw string 'tlx' 'tly' 'tgts1'';endif
if(iframe = 2);'draw string 'tlx' 'tly' 'tgts2'';endif
if(iframe = 3);'draw string 'tlx' 'tly' 'tgts3'';endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -60 180 80'
 'set string 1 tc 5 0'
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 0 4.25 0.75'
endwhile
'print'
'printim real.2d-prec_fcst.'ic_mon'IC.png gif x1200 y1600'
*
*'c'
'set vpage off'
