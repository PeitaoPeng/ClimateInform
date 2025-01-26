'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open sst.comp.obs.ctl'
'open z200.comp.obs.ctl'
'open sst.comp.para.ctl'
'open z200.comp.para.esm.ctl'
*
'set string 1 tc 5'
'set strsiz 0.13 0.13'
'draw string 4.25 10.3 DJFM Z200 and SST Composite'
*'draw string 4.25 10.3 (Based on NEP-NA Z200 COR to DJFM2013/14 data)'
'draw string 2.575 10. OBS'
'draw string 5.95 10. GOGA'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=3
nframe3=6
xmin0=1.;  xlen=3.15;  xgap=0.2
ymax0=9.8; ylen=-2.0;  ygap=-0.15
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
  tlx=xmin+0.0
  tly=ymax-0.1
  tlx2=3.25
  tly2=ymax+0.2
  bx=4.25
  by=ymin-0.25
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define st1=sst'
'define st2=cp'
'define st3=-cn'
'define zz1=z200.2'
'define zz2=cp.2'
'define zz3=-cn.2'
'define st4=sst.3'
'define st5=cp.3'
'define st6=-cn.3'
'define zz4=z200.4'
'define zz5=cp.4'
'define zz6=-cn.4'
'set t 1'
'set lon 0 360'
'set lat  -40 90'
'set yaxis -40 90 30'
*'set frame off'
'set grads off'
*'set grid off'
'set xlab off'
'set ylab off'
if(iframe = 3); 'set xlab on'; endif
if(iframe = 6); 'set xlab on'; endif
if(iframe <= 3); 'set ylab on'; endif
*'set map 15 1 2'
'set gxout shaded'
'set clevs   -1. -0.8 -0.4 -0.2 0.2 0.4 0.8 1 2 4 6 8 10'
'set ccols    45 44 43 42 0 22 23 23 25 26 27 28 29 69'
'd st'%iframe
'set gxout contour'
'set ccolor 1'
'set cint 20'
'd zz'%iframe
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -40 180 90'
'set string 1 tl 1 0'
'set strsiz 0.12 0.12'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) 2013/14'; endif
if(iframe = 4); 'draw string 'tlx' 'tly' (d) 2013/14'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) sample size=6'; endif
if(iframe = 5); 'draw string 'tlx' 'tly' (e) sample size=16'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' (c) sample size=8'; endif
if(iframe = 6); 'draw string 'tlx' 'tly' (f) sample size=14'; endif
if(iframe = 2); 'draw string 'tlx2' 'tly2' CMP for COR>0.6'; endif
if(iframe = 3); 'draw string 'tlx2' 'tly2' -CMP for COR<-0.6'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.75 0 'bx' 'by''
'print'
'printim sst_z200.comp.obs-para.na.png gif x600 y800'

