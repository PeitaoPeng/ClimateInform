'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/obs/sst/sst.had-oi.jan1979-cur.mon.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 7.5 HADSST Diff: avg(2000-2010)-avg(1990-1999)'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
xmin0=1.5;  xlen=8.;  xgap=0.5
ymax0=7.5; ylen=-4.;  ygap=0.4
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
  by=ymin-0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define s1=ave(sst,time=jan1990,time=dec1999)'
'define s2=ave(sst,time=jan2000,time=dec2010)'
'set t 1'
'set lon 0 360'
'set lat  -65 65'
'set yaxis -65 65 15'
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs   -1.0 -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8 1.0'
'set ccols   47 46 45 43 41 0 21 23 25 26 27'
'd s2-s1'
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -65 180 65'
'set string 1 tl 6 0'
'set strsiz 0.14 0.14'
*if(iframe = 1); 'draw string 'tlx' 'tly'  EOF1 32.4%'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  EOF2 9.2%'; endif
if(iframe = 3); 'draw string 'tlx' 'tly'  EOF3 7.8%'; endif
if(iframe = 4); 'draw string 'tlx' 'tly'  EOF4 6.4%'; endif
if(iframe = 5); 'draw string 'tlx' 'tly'  EOF5 4.4%'; endif
if(iframe = 6); 'draw string 'tlx' 'tly'  EOF6 2.8%'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.75 0 'bx' 'by''
'print'
'printim hadsst.decadal_diff.png gif x1600 y1200'

