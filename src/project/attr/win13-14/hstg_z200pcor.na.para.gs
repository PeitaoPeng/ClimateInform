'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open pcor_hstg.z200.ndjfm1957-2013.para.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.2 Histogram of AMIP Z200 Pat Cor over NA for NDJFM'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=4
nframe3=4
xmin0=1.;  xlen=6.5;  xgap=0.2
ymax0=9.9; ylen=-1.75;  ygap=-0.5
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
'set vrange 0 18'
'set grads off'
'set yaxis 0 18 2'
'set xaxis -0.95 0.95 0.1'
'set gxout bar'
'set bargap 30'
'set ccolor 4'
'd 100*h'%iframe
'set string 1 tl 5'
'set strsiz 0.13 0.13'
if(iframe = 1); 'draw string 'tlx' 'tly'  0-mon Lag, 4104 CORs'; endif
if(iframe = 1); 'draw string 'tlx' 'tly2' Mean=0.20 STD=0.36'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  1-mon Lag, 3078 CORs'; endif
if(iframe = 2); 'draw string 'tlx' 'tly2' Mean=0.08 STD=0.37'; endif
if(iframe = 3); 'draw string 'tlx' 'tly'  2-mon Lag, 2052 CORs'; endif
if(iframe = 3); 'draw string 'tlx' 'tly2' Mean=0.06 STD=0.36'; endif
if(iframe = 4); 'draw string 'tlx' 'tly'  3-mon Lag, 1026 CORs'; endif
if(iframe = 4); 'draw string 'tlx' 'tly2' Mean=0.03 STD=0.35'; endif
if(iframe = 4);'draw xlab Pattern Correlation'; endif
'draw ylab %'
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim hstg.z200.na.para.png gif x600 y800'

