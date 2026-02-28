'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open ersst.ndjfm1949-2013.mon.ctl'
'open z200.ndjfm1949-curr.mon.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.3 SST(C`ao`n) & 200mb HGT(m) Anom'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=4
nframe3=4
xmin0=1.5;  xlen=5.5;  xgap=0.2
ymax0=10.; ylen=-2.0;  ygap=-0.05
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
  tlx=xmin-0.2
  tly=ymax-1.5
  bx=xmax+0.
  by=ymax+2.1
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 54'
'define p1=tn'
'define p2=td'
'define p3=tj'
'define p4=tf'
'define st1=zn.2'
'define st2=zd.2'
'define st3=zj.2'
'define st4=zf.2'
'set t 1'
'set lon 0 360'
'set lat  -40 90'
'set yaxis -40 90 30'
*'set frame off'
'set grads off'
*'set grid off'
'set xlab off'
if(iframe = 4); 'set xlab on'; endif
*'set map 15 1 2'
'set gxout shaded'
'set clevs   -2.5 -2 -1.5 -1 -0.5 0.5 1 1.5 2 2.5'
'set ccols   49 47 45 43 41 0 21 23 25 27 29'
'd p'%iframe
'set gxout contour'
'set ccolor 1'
'set cint 50'
'd st'%iframe
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 90'
'set string 1 tl 6 90'
'set strsiz 0.14 0.14'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) Nov02'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) Dec02'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' (c) Jan03'; endif
if(iframe = 4); 'draw string 'tlx' 'tly' (d) Feb03'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim sst_z200.ndjf02.png gif x600 y800'

