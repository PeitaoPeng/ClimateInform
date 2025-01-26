'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open cor_psi200.obs.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 7.75 OBS NA PSI200 Pattern COR of DJFM2013/14 to Other Winters'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
xmin0=1.;  xlen=9.;  xgap=0.2
ymax0=7.5; ylen=-4.;  ygap=-0.5
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
  tlx=xmin+0.2
  tly=ymax-0.1
  tly2=ymax-0.3
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
'set xaxis 1950 2013 5'
'set bargap 30'
'set ccolor 4'
'set t 1 64'
'set ccolor 29'
'd maskout(cor,cor)'
'set ccolor 49'
'd maskout(cor,-cor)'
'set string 1 tl 5'
'set strsiz 0.13 0.13'
'draw ylab Pattern COR'
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
*'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim patcor_spi200.obs.na.png gif x800 y600'

