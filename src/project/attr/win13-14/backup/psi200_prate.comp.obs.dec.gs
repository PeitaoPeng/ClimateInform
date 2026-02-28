'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open prate.comp.obs.mon.ctl'
'open psi200.comp.obs.79-13.mon.ctl'
*
'set string 1 tc 5'
'set strsiz 0.13 0.13'
'draw string 4.25 10.5 OBS PSI200 and Prate Composite'
'draw string 4.25 10.3 (based on NPNA PSI200 COR to Dec2013 data)'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=4
nframe3=4
xmin0=1.5;  xlen=5.5;  xgap=0.2
ymax0=9.8; ylen=-2.0;  ygap=-0.4
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
  tly=ymax+0.2
  bx=xmax+0.
  by=ymax+2.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 2'
'define st1=obs'
'define st2=cp'
'define st3=-cn'
'define st4=(cp-cn)/2.'
'define zz1=obs.2'
'define zz2=cp.2'
'define zz3=-cn.2'
'define zz4=(cp.2-cn.2)/2.'
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
'set clevs -4 -3 -2 -1 -0.5 0.5 1 2 3 4'
'set ccols   79 77 75 73 71 0 31 33 35 37 39'
'd st'%iframe
'set gxout contour'
'set ccolor 1'
'set cint 2'
'd 0.000001*zz'%iframe
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 90'
'set string 1 tl 1 0'
'set strsiz 0.12 0.12'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) Dec2013'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) CMP for COR>0.55; 2 samples'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' (c) -CMP for COR<-0.55, 3 sample'; endif
if(iframe = 4); 'draw string 'tlx' 'tly' (d) (b+c)/2'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim prate_psi200.comp.obs.dec.png gif x600 y800'

