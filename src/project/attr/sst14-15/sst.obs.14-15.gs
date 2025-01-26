'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/obs/sst/sst.had-oi.jan1949-cur.3mon.anom.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 7.5 OBS SST 2014-2015'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=3
nframe3=6
xmin0=0.75;  xlen=4.5;  xgap=0.5
ymax0=7.5; ylen=-2.25;  ygap=0.4
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  if (iframe > nframe3); icx=3; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if (iframe > nframe3); icy=iframe-nframe3; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+0.3
  tly=ymax-0.5
  bx=5.5
  by=ymin-0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define s1=sst(time=apr2014)'
'define s2=sst(time=jun2014)'
'define s3=sst(time=aug2014)'
'define s4=sst(time=oct2014)'
'define s5=sst(time=dec2014)'
'define s6=sst(time=feb2015)'
'set t 1'
'set lon 0 360'
'set lat  -30 65'
'set yaxis -30 65 15'
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs   -1.5 -1.2 -0.9 -0.6 -0.3 0.3 0.6 0.9 1.2 1.5'
'set ccols   49 47 45 43 41 0 21 23 25 27 29'
'd s'%iframe
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 65'
'set string 1 tl 6 0'
'set strsiz 0.14 0.14'
if(iframe = 1); 'draw string 'tlx' 'tly'  MAM2014'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  AJJ2014'; endif
if(iframe = 3); 'draw string 'tlx' 'tly'  JAS2014'; endif
if(iframe = 4); 'draw string 'tlx' 'tly'  SON2014'; endif
if(iframe = 5); 'draw string 'tlx' 'tly'  NDJ2014'; endif
if(iframe = 6); 'draw string 'tlx' 'tly'  JFM2015'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.75 0 'bx' 'by''
'print'
'printim sst.obs.14-15.png gif x1600 y1200'

