'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
var=prec
eof_range=tp_np
ic_season=mjj
last_ic_mon=Jul
lead1=1
lead2=4
lead3=7
tt1=5
tt2=8
tt3=11
tgts1=SON
tgts2=DJF
tgts3=MAM
*
'open /cpc/home/wd52pp/data/casst/ac3d.'var'.'ic_season'.'eof_range'.ctl'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.14 0.14'
'draw string 4.25 10.25 AC Skill(%) of CA 'var' FCST'
'draw string 4.25 10. ICs through 'last_ic_mon''
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.25;  xlen=6;  xgap=0.6
ymax0=9.6; ylen=-2.5;  ygap=-0.5
'define sk1=100*ac(t='tt1')' 
'define sk2=100*ac(t='tt2')' 
'define sk3=100*ac(t='tt3')'
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+0.5
  tly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set lon 0 360'
'set lat -60 85'
*'set xlab off'
'set yaxis -60 85 20'
if(iframe = 5);'set xlab on';endif
'set grads off'
*'set grid off'
'set gxout shaded'
*'set clevs 10 20 30 40 50 60 70 80 90'
*'set ccols  0 91 92 31 33 35 37 81 82 85'
'set clevs   20 30 40 50 60 70 80 90'
'set ccols   0 42 43 62 63 64 65 67 69'
*'set clevs  -30 -20 20 30 40 50 60'
*'set ccols   44 42 0 22 24 25 27 29'
'd sk'%iframe
*
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
if(iframe = 1);'draw string 'tlx' 'tly' a)'tgts1''; endif
if(iframe = 2);'draw string 'tlx' 'tly' b)'tgts2''; endif
if(iframe = 3);'draw string 'tlx' 'tly' c)'tgts3''; endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -60 180 85'
 'set string 1 tc 5 0'
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 0 4.25 0.5'
endwhile
'printim ac_2d.'var'.'ic_season'.'eof_range'.png gif x1200 y1600'
'print'
*
*'c'
'set vpage off'
