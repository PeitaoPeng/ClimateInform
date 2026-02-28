'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open cor_z200.obs.ctl'
'open cor_z200.esm.ctl'
*
'set string 1 tc 5'
'set strsiz 0.13 0.13'
'draw string 4.3 10 NEP-NA Z200 Pattern COR of DJFM2013/14 to Other Winters'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
nframe3=2
xmin0=1.5;  xlen=6.;  xgap=0.2
ymax0=9.5; ylen=-2.;  ygap=-0.65
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
  tlx=xmin-0.6
  tly=ymin+0.4
  tlx2=xmin+0.
  tly2=ymax+0.2
  bx=xmax+0.5
  by=ymax+1.75
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set gxout bar'
'set bargap 50'
'set barbase 0'
'set vrange -1 1'
'set grads off'
'set yaxis -1 1 0.2'
'set string 1 tl 5'
'set strsiz 0.13 0.13'
if(iframe = 1);
'set xaxis 1950 2013 5'
'set bargap 30'
'set ccolor 4'
'set t 1 64'
'set ccolor 29'
'd maskout(cor,cor)'
'set ccolor 49'
'd maskout(cor,-cor)'
'draw string 'tlx2' 'tly2' (a) OBS'
endif
if(iframe = 2);
'set xaxis 1950 2013 5'
*'set xaxis 1958 2013 5'
'set bargap 30'
'set ccolor 4'
'set t 1 64'
'set ccolor 29'
'd maskout(cor.2,cor.2)'
'set ccolor 49'
'd maskout(cor.2,-cor.2)'
'draw string 'tlx2' 'tly2' (b) GOGA'
endif
'set string 1 tl 5 90'
'set strsiz 0.13 0.13'
'draw string 'tlx' 'tly' Pattern COR'
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
*'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim patcor_z200.obs_goga.nepna.png gif x600 y800'

