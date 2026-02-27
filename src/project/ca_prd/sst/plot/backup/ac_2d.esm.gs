'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
eof_range=tp_ml
ic_season=mjj
last_ic_mon=jul
lead=1
tt=5
tgts=SON
*lead=1
*tt=5
*tgts=OND
*
'open /cpc/home/wd52pp/data/casst/ac3d.hadoisst.'ic_season'.'eof_range'.ctl'
'open /cpc/home/wd52pp/data/casst/ac3d.ersst.'ic_season'.'eof_range'.ctl'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.14 0.14'
'draw string 4.25 10.25 AC Skill(%) of CA SST FCST For 'tgts''
'draw string 4.25 10. ICs through 'last_ic_mon''
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.25;  xlen=6;  xgap=0.6
ymax0=9.6; ylen=-3.;  ygap=-0.3
'define sk1=100*ac(t='tt')' 
'define sk2=100*ac.2(t='tt')' 
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+0
  tly=ymax+0.0
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set lon 0 360'
'set lat -65 65'
*'set xlab off'
'set yaxis -65 65 20'
if(iframe = 5);'set xlab on';endif
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs 10 20 30 40 50 60 70 80 90'
'set ccols  0 91 92 31 33 35 37 81 82 85'
*'set clevs   10 20 30 40 50 60 70 80 90'
*'set ccols   0 21 23 32 34 36 38 51 53 55'
'd sk'%iframe
*
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
if(iframe = 1);'draw string 'tlx' 'tly' a)HAD-OI SST';endif
if(iframe = 2);'draw string 'tlx' 'tly' b)ERSST';endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -65 180 65'
 'set string 1 tc 5 0'
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 0 4.25 3.0'
endwhile
'printim ac_2d.'ic_season'_to_'tgts'.ld'lead'.'eof_range'.png gif x1200 y1600'
'print'
*
*'c'
'set vpage off'
