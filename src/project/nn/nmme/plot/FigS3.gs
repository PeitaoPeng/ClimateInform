'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
'enable print FigS3.meta'
*
'open /cpc/consistency/nn/nmme/NMME_sst.may_ic.1982-2019.djf.new.ctl'
'open /cpc/consistency/nn/nmme/obs_sst.1982-2019.djf.ctl'
*
'set string 1 tc 5'
'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=3
nframe3=6
xmin0=0.5;  xlen=3.75;  xgap=0.2
ymax0=10.; ylen=-1.5;  ygap=-0.05
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
  tlx=xmin + 1.875
  tly=ymax + 0.1
  tlx2=xmin + 3.75 +0.1
  tly2=ymax + 0.05
  bx=4.25
  by=ymin-0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define p1=sst(t=20)'
'define p2=sst(t=31)'
'define p3=sst(t=36)'
'define p4=sst.2(t=20)'
'define p5=sst.2(t=31)'
'define p6=sst.2(t=32)'
'set t 1'
'set lon 120 285'
'set lat  -20 20'
'set yaxis -20 20 10'
*'set frame off'
'set grads off'
*'set grid off'
'set xlab off'
'set ylab off'
if(iframe <= 3); 'set ylab on'; endif
if(iframe = 3); 'set xlab on'; endif
if(iframe = 6); 'set xlab on'; endif
*'set map 15 1 2'
'set gxout shaded'
'set clevs -1.2  -1. -0.8 -0.6 -0.4 -0.2 0 0.2 0.4 0.6 0.8 1.0 1.2'
'set ccols   49 48 47 46 45 43 42 22 23 25 26 27 28 29'
'd p'%iframe
*'run /cpc/home/wd52pp/bin/dline.gs 120 0 285 0'
*'run /cpc/home/wd52pp/bin/dline.gs 180 -20 180 20'

'run /cpc/home/wd52pp/bin/dline.gs 190 -5 190 5'
'run /cpc/home/wd52pp/bin/dline.gs 240 -5 240 5'
'run /cpc/home/wd52pp/bin/dline.gs 190 -5 240 -5'
'run /cpc/home/wd52pp/bin/dline.gs 190 5 240 5'
'set string 1 tc 5 0'
'set strsiz 0.13 0.13'
if(iframe = 1); 'draw string 'tlx' 'tly' NMME'; endif
if(iframe = 4); 'draw string 'tlx' 'tly' OBS'; endif
if(iframe = 1); 'draw string 'tlx2' 'tly2' 2001/02'; endif
if(iframe = 2); 'draw string 'tlx2' 'tly2' 2012/13'; endif
if(iframe = 3); 'draw string 'tlx2' 'tly2' 2017/18'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.75 0 'bx' 'by''
'print'
'printim FigS3.png gif x600 y800'

